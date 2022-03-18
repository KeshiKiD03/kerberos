# Kerberos LDAP HOST
## Aaron Andal ASIX M011 2021-2022


### Kerberos Containers:

 * **keshikid03/krb22:khostldap** 

#### Documentació:
Executarem l'startup amb bash:

```
docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -p 389:389 -d keshikid03/ldap21:group

docker run --rm --name khostldap.edt.org --hostname khostldap.edt.org --net 2hisx --privileged -it keshikid03/krb22:khostldap
```
