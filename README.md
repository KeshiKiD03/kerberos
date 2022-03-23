# Kerberos 2021-2022
## Aaron Andal ASIX M11 2021-2022


### Kerberos Containers:

 * **keshikid03/krb22:kserver** --> Server Kerberos BASE

 * **keshikid03/krb22:kclient** --> Client Kerberos BASE

 * **keshikid03/krb22:khostp** --> Client de Kerberos + PAM

 * **keshikid03/krb22:khostldap** --> Client de Kerberos + PAM + LDAP

* **keshikid03/krb22:kserverssh** --> Client de Kerberos + SSH Servidor + Keytab

* **keshikid03/krb22:kclientssh0** --> Client de Kerberos + SSH Cliente

### PRÁCTICA 1 KSERVER Y KHOST + KHOST DE PAM

#### INTERACTIVE

```
docker run --rm --name kserver.edt.org -h kserver.edt.org --net 2hisx -p 88:88 -p 464:464 -p 749:749 -it keshikid03/krb22:kserver
```

#### DETACH

```
docker run --rm --name kserver.edt.org -h kserver.edt.org --net 2hisx -p 88:88 -p 464:464 -p 749:749 -d keshikid03/krb22:kserver
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

### PRACTICA KCLIENT + KSERVER

1. Preparar el KSERVER *Interactivo* o *Detach* con *-no fork*

2. Abrir el KCLIENT y hacer peticiones al **KSERVER**.

### PRACTICA MINILINUX (OPCIONAL)

1. Instalar el DEBIAN 11 POR RED EN UNA MÁQUINA REAL.

2. `Eliminar del vostre host físic les particions sda2, sda3 i sda4. Crear una particiósda2 de 8GB. Instal·lar-hi DEBIAN amb una instal·lació MINIMAL.`

3. Rehacer el GRUB.

4. Instalar DOCKER.

5. Modificar el GRUB.

6. Instalar el `SSH y hacer el `SSH Desatendido`.

7. Instalar `KRB5-USER`.

8. Copiar el krb5.conf a `/etc/krb.conf`

9. Modificar el /etc/hosts. `1.2.3.4 kserver.edt.org`

### PRACTICA 1 KHOSTPAM

1. Modificar el KCLIENT y transformarlo en KHOSTPAM.

2. Modificar los COMMON PERTINENTES.

3. Copiar el `/opt/docker/krb5.conf` a `/etc/krb5.conf`.

4. Añadir los usuarios locales CON PASSWORD y los KUSERS sin PASSWORD.

5. Probar el acceso con `login local01` + `login local02` y posteriormente `login kuser01`

6. Al `iniciar sesión` deberíamos tener un `ticket de Kerberos`. Ya que tenemos los módulos de PAM de Kerberos activados.


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

1. Modificar el KCLIENT y transformarlo en KHOSTLDAP.

2. Modificar los COMMON PERTINENTES.

3. Tener instalado el `ldap-utils`. Copiar el `/opt/docker/krb5.conf` a `/etc/krb5.conf`.

4. Copiar los ficheros pertinentes para la resolución de `LDAP-NSSWITCH`:
```
cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/login.defs /etc/login.defs
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf
```

4. Añadir los usuarios locales CON PASSWORD y los KUSERS sin PASSWORD.

5. Encender los SERVICIOS `/usr/sbin/nscd` y `/usr/sbin/nslcd`.

6. Probamos conectividad con `getent passwd` y `getent group`.

7. Probar el acceso con `login local01` + `login local02` y posteriormente `login kuser01` y luego volver con `login local01` y `su -l pere`

8. Al `iniciar sesión` deberíamos tener un `ticket de Kerberos`. Ya que tenemos los módulos de PAM de Kerberos activados.

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

#### INTERACTIVO

```
docker run --rm --name sshd.edt.org -h sshd.edt.org -p 1022:22 --net 2hisx -it keshikid03/krb22:kserverssh
```

#### DETACH

```
docker run --rm --name sshd.edt.org -h sshd.edt.org -p 1022:22 --net 2hisx -d keshikid03/krb22:kserverssh
```

> IMPORTANTE PROPAGAR EL PUERTO 1022:22 - Para AMAZON AWS ya que se accederá por el puerto 1022 a SSH y 22 dentro de la AMI

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/SSH%20-%20KERBEROS.jpg)


#### Requisitos

**PAQUETES**

- SSH

- KRB5-USER

- vim tree nmap mlocate less man procps ldap-utils iproute2 net-tools


#### INTERACTIVO

1. Encender KSERVER en modo DETACH `(-nofork)` o INTERACTIVO

2. Encender Kclient para tunear.

```
docker run --rm --name sshd.edt.org -h sshd.edt.org -p 1022:22 --net 2hisx -it keshikid03/krb22:kserverssh
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

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/6-r.png)

```
kadmin
```

```
listprincs
```

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/7-r.png)

10. Generamos el `KRB5.KEYTAB`.

```
ktadd -k /etc/krb5.keytab host/sshd.edt.org
```

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/1-Ktadd.png)

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/2-CatKeytab.png)



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

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/3-Users.png)

13. Acceder por `SSH` a los usuarios de `Kerberos` `marta` y `pere`.
```
ssh -v marta@sshd.edt.org
```

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/final.jpeg)


#### AUTOMATIZADO (SIN DETACH)

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/Acceso-OK.png)

#### KCLIENTSSH (SERVIDOR)

1. Dockerfile
```
# Kerberos SSHD Client
FROM debian:latest
LABEL version="1.0"
LABEL author="Keshi"
LABEL subject="Kerberos SSHD Client"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install ssh krb5-user vim tree nmap mlocate less man procps ldap-utils iproute2 net-tools
RUN mkdir /opt/docker
COPY . /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
```

2. `startup.sh`
```
#! /bin/bash

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/sshd_config /etc/ssh/sshd_config
cp /opt/docker/ssh_config /etc/ssh/ssh_config

# Generem la CLAU de HOST - Iniciem amb marta - kmarta i fem el kadmin: ktadd -k ....

kadmin -p admin -w kadmin -q "ktadd -k /etc/krb5.keytab host/sshd.edt.org"

# Creació d'usuaris Locals w Password

for user in local01 local02 local03
do
  useradd $user
  echo -e "$user\n$user\n" | passwd $user
done

# Creació d'usuaris Kerberos no Password

for user in anna pere marta jordi pau kuser01 kuser02 kuser03 kuser04 kuser05 kuser06
do
  useradd $user
done

mkdir /run/sshd
/usr/sbin/sshd && echo "SSH Activado"

# Detach
/usr/sbin/sshd -D && echo "SSH Activado"

# Comentar esto if detach
/bin/bash
```

* Se copian los ficheros `ssh_config` - `sshd_config`

* Se crea la `CLAVE DE HOST` para `SSH-KERBEROS`.

* Se puede visualizar con algún usuario de Kerberos con Permisos --> `kinit marta` --> `kadmin` --> `listprincs`

* Se ejecutan los USUARIOS UNIX LOCALES sin password y Kerberos con Password.

* Se inicia el SSH tanto como INTERACTIVO como DETACH.

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/SSH-KRB-DETACH.png)

----------------------------------------------------------------------------------

#### KCLIENT-SSH0 (CLIENTE)

* Hacer lo mismo para el kclient-ssh (kclientssh0) normal pero sin el `sshd_config` configurado

```
docker run --rm --name ssh.edt.org -h ssh.edt.org --net 2hisx -it keshikid03/krb22:kclientssh0
```

* **IMPORTANTE**: Modificar el `/etc/hosts`:

```
172.19.0.3	sshd.edt.org sshd
172.19.0.2	kserver.edt.org kserver
```

* Probar de acceder por SSH al Servidor

    * `kinit kuser01` --> `ssh -v kuser01@sshd.edt.org`.

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/kclientssh0.png)

----------------------------------------------------------------------------------

#### KCLIENT-SSH0 (CLIENTE-AWS)

* Hacer lo mismo para el kclient-ssh (kclientssh0) normal pero sin el `sshd_config` configurado

```
docker run --rm --name ssh.edt.org -h ssh.edt.org --net 2hisx -it keshikid03/krb22:kclientssh0
```
* **IMPORTANTE**: Abrir el DOCKER de SSHD.EDT.ORG habiendolo abierto con `-p 1022:22`:

* **IMPORTANTE**: Añadir un SECURITY GROUP --> Para el puerto 1022 en AMAZON AWS:

* **IMPORTANTE**: Modificar el `/etc/hosts`:

```
 54.89.174.191 sshd.edt.org kserver.edt.org
```

> IMPORTANTE QUE **SSHD.EDT.ORG** ESTÉ CON EL PUERTO 1022 PROPAGADO YA QUE SE ACCEDERÁ DESDE AHÍ A SSH
```
ssh -v -p 1022 pere@sshd.edt.org
```

* Probar de acceder por SSH al Servidor

    * `kinit kuser01` --> `ssh -v -p 1022 kuser01@sshd.edt.org`.

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/kclientssh0.png)

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/aws3.PNG)

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/aws2.PNG)

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/aws4.PNG)

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/aws1.jpeg)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

#### AWS - KserverSSH + LdapGroup + SSHD.EDT.ORG < ----------- KclientSSHLdap

1. Las máquinas están actualizadas en mi Dockerhub `keshikid03/krb22:kserver` + `keshikid03/krb22:kserverssh` + `keshikid03/krb22:kclientsshldap`

2. Iniciar sesión en AWS: [AWS](https://awsacademy.instructure.com/login/canvas) --> Abrir EC2 y abrir mi máquina Cloud Keshi Debian.

   * Previamente deberíamos haber propagado los PUERTOS en Security Groups (Hecho antes).

3. Iniciar por SSH `ssh -i KeshiProtable.pem admin@ip_publica_aws`.

4. Desplegar las Dockers en AWS:

```
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -p 389:389 keshikid03/ldap21:group
```

```
docker run --rm --name kserver.edt.org -h kserver.edt.org --net 2hisx -p 88:88 -p 464:464 -p 749:749 -d keshikid03/krb22:kserver
```

```
docker run --rm --name sshd.edt.org -h sshd.edt.org -p 1022:22 --net 2hisx -d keshikid03/krb22:kserverssh
```

* Verificar con DOCKER PS

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/L7.PNG)


5. ``IMPORTANTE``: La SSHD tiene que desplegarse en 1022:22 ya que accederemos por el puerto 1022 desde el HOST CLIENTE (Casa) a AWS.

6. Verificar IPs correctamente:

```
nmap localhost
```

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/L5.PNG)

```
docker network inspect 2hisx
```

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/L4.PNG)

7. Anotar las IP de los DOCKERS y ponerlo en `/etc/hosts`.

8. En HOST Local (Casa) en VirtualBox o en Ubuntu mismo, desplegar el `keshikid03/krb22:kclientsshldap`

```
docker run --rm --name ssh.edt.org -h ssh.edt.org --net 2hisx -it keshikid03/krb22:kclientsshldap /bin/bash /bin/bash
```

9. Dentro de `kclientsshldap` modificar el `/etc/hosts`.

```
ip_publica_AWS    sshd.edt.org kserver.edt.org ldap.edt.org
```

10. Ejecutar el `startup.sh`

```
bash startup
```

11. Probar el funcionamiento de LDAP con un `getent passwd` o `ldapsearch -x -LLL`.

12. Probar el funcionamiento de Kerberos con un `kinit pere` o `kinit kuser01`.

##### Verificación: KERBEROS - LDAP

1. Probamos con un `login local01` o `login local02` y posteriormente `login kuser01` y verificamos con `klist` para ver que nos ha dado un *TICKET DE KERBEROS*.

2. A partir de ahora realizamos un `su -l pere` y entramos a `/tmp/home/pere` que es el Directorio de Pere en LDAP.

3. Observamos que funciona.

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/L3.PNG)

##### Verificación: KERBEROS - SSH

1. Realizamos un `kinit pere`

2. Verificamos con un `klist`

3. Hacemos el SSH: `ssh -v -p 1022 pere@sshd.edt.org`.

4. Con el *debug*, observamos que nos hace un method: `gssapi-with-mic` y posteriormente `Delegating Credentials`

5. Hemos entrado perfectamente y `sin contraseña`.

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/L2.png)

![hola](https://github.com/KeshiKiD03/kerberos/blob/main/Photos/L1.PNG)

### PRACTICA 5 KSERVER + SSH.EDT.ORG (KCLIENT) + KCLIENT + LDAP CERTIFICADO

### PRACTICA 6 TUNELES

## DEBIAN

DOCKER + CONEXIÓN A AWS (TODO DESDE MI ORDENADOR POR SSH)

INSTALAR KERBEROS USER
