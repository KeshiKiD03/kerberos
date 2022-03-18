#! /bin/bash

# KhostP
# @edt ASIX M11-SAD Curs 2021-2022

# Copiar arxius necesaris

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/kdc.conf /etc/krb5kdc/kdc.conf
cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl

cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/login.defs /etc/login.defs
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf
cp /opt/docker/pam_mount.conf.xml /etc/security/pam_mount.conf.xml
cp /opt/docker/common-auth /etc/pam.d/common-auth
cp /opt/docker/common-account /etc/pam.d/common-account
cp /opt/docker/common-password /etc/pam.d/common-password
cp /opt/docker/common-session /etc/pam.d/common-session

kdb5_util create -s -P masterkey # Crea la BD con Masterkey

# Añade grupo local

groupadd localU

# Añade un grupo kusers

groupadd kusers

# Añadir usuarios

useradd -g users -G localU local01
useradd -g users -G localU local02
useradd -g users -G localU local03
useradd -g users -G kusers kuser01
useradd -g users -G kusers kuser02
useradd -g users -G kusers kuser03

# Añade password

echo -e "local01\nlocal01" | passwd local01
echo -e "local02\nlocal02" | passwd local02
echo -e "local03\nlocal03" | passwd local03

/usr/sbin/nscd
/usr/sbin/nslcd

/etc/init.d/krb5-admin-server start
/etc/init.d/krb5-kdc start

# Asegurar que funcione
getent passwd
getent group

/bin/bash
