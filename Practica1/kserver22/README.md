# Kerberos server
## Aaron Andal ASIX M11 2021-2022


### Kerberos Containers:

 * **keshikid03/krb22:kserver** 

```
docker run --rm --name kserver.edt.org -h kserver.edt.org --net 2hisx -p 88:88 -p 464:464 -p 749:749 -it keshikid03/krb22:kserver
```
