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

* USUARIOS pere (kpere) / pau (kpau, rol: admin) / jordi (kjordi) / anna (kanna) / marta (kmarta) / marta/admin (kmarta rol:admin), julia (kjulia), admin (kadmin rol:admin).
    
* USUARIOS kuser01 ... kuser06 - PASSWD (kuser01....kuser06)

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

kdb5_util create -s -P masterkey # Crea la DATABASE # Importante ponerlo porque pide contraseña

# Usuaris que s'utilitzaran amb LDAP de IP
for user in anna pere marta jordi pau user{01..06} 
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

/bin/bash

```

3. Modificar el kadm5.acl

```bash
*/admin@EDT.ORG *
admin@EDT.ORG *
# marta@EDT.ORG *
super@EDT.ORG *
pau@EDT.ORG *
```

4. Modificar el krb5.conf

```
[realms]
	EDT.ORG = {
		kdc = kserver.edt.org
		admin_server = kserver.edt.org
	}

[domain_realm]
	.edt.org = EDT.ORG
	edt.org = EDT.ORG
```

5. Modificar el kdc.conf

```
[kdcdefaults]
    kdc_ports = 750,88

[realms]
    EDT.ORG = {
        database_name = /var/lib/krb5kdc/principal
        admin_keytab = FILE:/etc/krb5kdc/kadm5.keytab
        acl_file = /etc/krb5kdc/kadm5.acl
        key_stash_file = /etc/krb5kdc/stash
        kdc_ports = 750,88
        max_life = 10h 0m 0s
        max_renewable_life = 7d 0h 0m 0s
        master_key_type = des3-hmac-sha1
        #supported_enctypes = aes256-cts:normal aes128-cts:normal
        default_principal_flags = +preauth
    }
```

6. Generar el DOCKERFILE

7. 

8. 