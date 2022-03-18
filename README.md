# Kerberos 2021-2022
## Aaron Andal ASIX M11 2021-2022


### Kerberos Containers:

 * **keshikid03/krb22:kserver** 

 * **keshikid03/krb22:kclient**

 * **keshikid03/krb22:khostp**

### PRÁCTICA 1 KSERVER Y KHOST + KHOST DE PAM

```
docker run --rm --name kserver.edt.org -h kserver.edt.org --net 2hisx -p 88:88 -p 464:464 -p 749:749 -it keshikid03/krb22:kserver
```
```
docker run --rm --name kclient.edt.org -h kclient.edt.org --net 2hisx -it keshikid03/krb22:kclient
```
```
docker run --rm --name khostp.edt.org -h khostp.edt.org --net 2hisx -it keshikid03/krb22:khostp /bin/bash
```

* Órdenes:

    * kinit [user]

    * klist

    * kadmin
    
        * listprincs

    * kadmin.local

### PRACTICA MINILINUX

1. Instalar el DEBIAN 11 POR RED EN UNA MÁQUINA REAL.

2. `Eliminar del vostre host físic les particions sda2, sda3 i sda4. Crear una particiósda2 de 8GB. Instal·lar-hi DEBIAN amb una instal·lació MINIMAL.`

3. Rehacer el GRUB.

4. Instalar DOCKER.

5. Modificar el GRUB.

6. Instalar el SSH y hacer el SSH Desatendido.

7. Instalar KRB5-USER.

8. Copiar el krb5.conf a `/etc/krb.conf`

9. Modificar el /etc/hosts. `1.2.3.4 kserver.edt.org`

### PRACTICA 2 KHOSTLDAP

```
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -p 389:389 -d keshikid03/ldap21:group

docker run --rm --name khostldap.edt.org --hostname khostldap.edt.org --net 2hisx --privileged -it keshikid03/krb22:khostldap
```

* Órdenes:

    * ldapsearch 

    * getent passwd

    * getent group
    
    * kinit [user]

    * klist

    * kadmin

        * listprincs


![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/KHOSTLDAP-VERIFICADO.png)

### PRACTICA 3 AWS + KSERVER + KHOSTP + KHOSTLDAP ---- KCLIENT (MINIMAL DEBIAN)

1. Abrir el AWS

2. https://www.awsacademy.com/LMS_Login 

3. Generar un DEBIAN - de 4GB RAM

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/AWS.png)

4. Instalar DOCKER y todo y tunearlo.

5. Abrir puertos necesarios en Security Wizard.


```
–	sgr-04e923758e31265ee	IPv4	Custom TCP	TCP	464	0.0.0.0/0	–
–	sgr-0aa9ac2835e888c6d	IPv4	SSH	TCP	22	0.0.0.0/0	–
–	sgr-014f86237d13b8a4d	IPv4	LDAP	TCP	389	0.0.0.0/0	–
–	sgr-0199be22841e350ad	IPv4	Custom TCP	TCP	88	0.0.0.0/0	–
–	sgr-06fcb9b50bb6b1134	IPv4	Custom TCP	TCP	749	0.0.0.0/0	–
```

6. Probar todo y modificar el /etc/hosts de AMAZON - Debian ``1.2.3.4 ssh.edt.org kserver.edt.org kclient.edt.org ....``


-------

**DEBIAN MINIMAL**

* apt-get install gnome-nettool

1. Abrir la máquina de DEBIAN MINIMAL

2. Configurar el /etc/hosts de AWS.

3. Abrir en AWS el `kserver.edt.org`.

4. Abrir el MINILINUX y conectarse por ssh --> `ssh aaron@i14`.

5. Modificaar el /etc/hosts de i14 para que apunte a AWS.

6. Instalar el KRB5-USER y probar de autenticar.

### PRACTICA 4 KSERVER + SSHD.EDT.ORG (KCLIENT) + KCLIENT-SSH

#### Requisitos

**PAQUETES**

- SSH

- KRB5-USER

- MLOCATE / NET-TOOLS


#### INTERACTIVO

1. Encender KSERVER en modo DETACH `(-nofork)` o INTERACTIVO

2. Encender Kclient para tunear.

```
docker run --rm --name sshd.edt.org -h sshd.edt.org --net 2hisx -it keshikid03/krb22:kclient
```

3. Instalar `SSH` y `net-tools`.
```
sudo apt-get install ssh
```

```
sudo apt-get install net-tools
```

4. Verificar el proceso para el SERVICIO SSH
```
service ssh status

```
sshd is not running ... `failed`!

```
service ssh start
```

running

**DETACH** --> /usr/sbin/sshd *En startup.sh*
```
mkdir /run/sshd
/usr/sbin/sshd -D
```


5. Tunear el `/etc/hosts` de `SSHD.EDT.ORG`
```
vim /etc/hosts
```

```
172.19.0.3	sshd.edt.org sshd
172.19.0.2	kserver.edt.org kserver
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

*Modificamos*

```
KerberosAuthentication yes
KerberosTicketCleanup yes

GSSAPIAuthentication yes
GSSAPICleanupCredentials no

```


7. Configurar el fichero `/etc/ssh/ssh_config`.
```
sudo vim /etc/ssh/ssh_config
```

*Modificamos*

```
   GSSAPIAuthentication yes
   GSSAPIDelegateCredentials yes
```

8. Reiniciar el sSH
```
service ssh restart
```

9. Iniciamos sesión con algún usuario `Kerberos Administrador` --> `Marta`
```
kinit marta
```

```
klist
```

![hola](6-r.png)

```
kadmin
```

```
listprincs
```

![hola](7-r.png)

10. Generamos el `KRB5.KEYTAB`.

```
ktadd -k /etc/krb5.keytab host/sshd.edt.org
```

![hola](1-Ktadd.png)

![hola](2-CatKeytab.png)



11. Reiniciar el SSH.
```
service ssh restart
```

12. Añadir los usuarios `locales` `con PASSWORD` y los de `kerberos` `sin PASSWORD` --> Luego lo pondremos en el `STARTUP.SH`

* `UNIX with PASSWORD`

```
for user in local01 local02 local03
do
  useradd $user
  echo -e "$user\n$user\n" | passwd $user  
done	
```

* `Kerberos sin PASSWORD`

```
for user in anna pere marta jordi pau kuser01 kuser02 kuser03 kuser04 kuser05 kuser06
do
  useradd $user
done
```

13. Acceder por `SSH` a los usuarios de `Kerberos` `marta` y `pere`.
```
ssh -v marta@sshd.edt.org
```

![hola](final.jpeg)



14. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

15. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

16. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

17. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

18. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

19. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

20. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

#### DETACH

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

6. Configurar el fichero `/etc/ssh/sshd_config`.
```
sudo vim /etc/ssh/sshd_config
```

### PRACTICA 5 KSERVER + SSH.EDT.ORG (KCLIENT) + KCLIENT + LDAP CERTIFICADO

### PRACTICA 6 TUNELES

## DEBIAN

DOCKER + CONEXIÓN A AWS (TODO DESDE MI ORDENADOR POR SSH)

INSTALAR KERBEROS USER