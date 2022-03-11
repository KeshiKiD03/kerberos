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

8. Copiar el krb5.conf a /etc/krb.conf

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


### PRACTICA 4 KSERVER + SSH.EDT.ORG (KCLIENT) + KCLIENT



### PRACTICA 5 KSERVER + SSH.EDT.ORG (KCLIENT) + KCLIENT + LDAP CERTIFICADO

### PRACTICA 6 TUNELES

## DEBIAN

DOCKER + CONEXIÓN A AWS (TODO DESDE MI ORDENADOR POR SSH)

INSTALAR KERBEROS USER