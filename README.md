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

    * listprincs

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

    * listprincs


### PRACTICA 3 AWS + KSERVER + KHOSTP + KHOSTLDAP ---- KHOSTREAL (MINIMAL DEBIAN)
ç
### PRACTICA 4 KSERVER + SSH.EDT.ORG (KCLIENT) + KCLIENT

### PRACTICA 5 KSERVER + SSH.EDT.ORG (KCLIENT) + KCLIENT + LDAP CERTIFICADO

### PRACTICA 6 TUNELES

## DEBIAN

DOCKER + CONEXIÓN A AWS (TODO DESDE MI ORDENADOR POR SSH)

INSTALAR KERBEROS USER