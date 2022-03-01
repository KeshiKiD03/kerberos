# M11-SAD Seguretat i alta disponibilitat
## Escola Del Treball
### 2HISX 2021-2022
### Aaron Andal

https://geekland.eu/aprender-markdown-en-minutos/ 

#### EMOJIS CHEATSHEET

👹 🤬  😍 🥰  🥺  👾  👽  👍  🔥  🌈 ☀️  🌤 ☄️  🚧 ☢️ 

☣️ ⛔️  💮  🆚 ❗️ ❗️ ❗️ ❓ ❓  💯 ❤️‍🔥  💛  🧡  💟 

#### TABLA ELEVACIONES Y MÁSCARA

## PRÁCTICA 1

### Imatges Docker

**keshikid03/k22:kserver**

* Servidores en detach

* adduser pere / pau / jordi / anna / marta / admin
    
* adduser kuser01 ... kuser06

* nomHost: `kserver.edt.org`

**keshikid03/k22:khost**

* `kinit` y `kdestroy`

* Contacta con `kserver.edt.org`.

## PROCEDIMIENTO

1. Modificar el DOCKERFILE para **kserver.edt.org**

```dockerfile
FROM debian:11
LABEL version="1.0"
LABEL author="@edt ASIX-M06"
LABEL subject="KERBEROS server"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install krb5-admin-server mlocate procps iproute2 tree nmap nano vim less finger passwd libpam-pwquality libpam-mount libpam-mkhomedir libpam-ldapd libnss-ldapd nslcd nslcd-utils ldap-utils openssh-client openssh-server 
# samba samba-client
RUN mkdir /opt/docker
COPY . /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
EXPOSE 88 464 749
```

2. Modificar el startup.sh (Observando el History)

```bash
#! /bin/bash
# Kserver
# @edt ASIX M11-SAD Curs 2021-2022

cp /opt/docker/krb5.conf /etc/krb5.conf
cp /opt/docker/kdc.conf  /var/kerberos/krb5kdc/kdc.conf
cp /opt/docker/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl

kdb5_util create -s -P masterkey

# Usuaris que s'utilitzaran amb LDAP de IP
for user in anna pere marta jordi pau user{01..10} 
do
  kadmin.local -q "addprinc -pw k$user $user"
done 

kadmin.local -q "addprinc -pw kmarta marta/admin"
kadmin.local -q "addprinc -pw kpere pere/admin"
kadmin.local -q "addprinc -pw kpau  pau/admin"
kadmin.local -q "addprinc -pw ksuper super"
kadmin.local -q "addprinc -pw kadmin admin "

# Usuaris que s'utilitzaran amb /etc/passwd de IP
for user in kuser{01..06}
do
  kadmin.local -q "addprinc -pw $user $user"
done

kadmin.local -q "addprinc -randkey host/sshd.edt.org"

/etc/init.d/krb5-admin-server start
/etc/init.d/krb5-kdc start
/etc/init.d/krb5-admin-server status
/etc/init.d/krb5-kdc status

```

3. Modificar el kadm5.acl

4.

5.

6.