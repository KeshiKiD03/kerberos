#! /bin/bash
# Kserver
# @edt ASIX M11-SAD Curs 2021-2022

cp /opt/docker/krb5.conf /etc/krb5.conf
cp /opt/docker/kdc.conf  /etc/krb5kdc/kdc.conf
cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl

kdb5_util create -s -P masterkey # Crea la DATABASE # Importante ponerlo porque pide contraseña

# Usuaris que s'utilitzaran amb LDAP de IP
for user in anna pere marta jordi pau user{01..10} 
do
  kadmin.local -q "addprinc -pw k$user $user"
done 

kadmin.local -q "addprinc -pw kmarta marta/admin"
kadmin.local -q "addprinc -pw kpere pere/admin"
kadmin.local -q "addprinc -pw kpau  pau/admin"
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
