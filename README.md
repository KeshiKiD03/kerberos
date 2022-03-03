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