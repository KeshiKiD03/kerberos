#! /bin/bash

# Khostldap + SSH.EDT.ORG
# @edt ASIX M11-SAD Curs 2021-2022

# Copiar arxius necesaris

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.

cp /opt/docker/ssh_config /etc/ssh/ssh_config

#cp /opt/docker/kdc.conf /etc/krb5kdc/kdc.conf
#cp /opt/docker/kadm5.acl /etc/krb5kdc/kadm5.acl

# Copiamos archivos de PAM LDAP

cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/login.defs /etc/login.defs
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf

# cp /opt/docker/pam_mount.conf.xml /etc/security/pam_mount.conf.xml

# Lo activaremos más tarde lo arriba

# Copiamos Archivos de PAM


cp /opt/docker/common-auth /etc/pam.d/common-auth
cp /opt/docker/common-account /etc/pam.d/common-account
cp /opt/docker/common-password /etc/pam.d/common-password
cp /opt/docker/common-session /etc/pam.d/common-session

#kdb5_util create -s -P masterkey # Crea la BD con Masterkey


## NEW

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


# Añade grupo local

#groupadd localU

# Añade un grupo kusers

#groupadd kusers

# Añadir usuarios

#useradd -g users -G localU local01
#useradd -g users -G localU local02
#useradd -g users -G localU local03
#useradd -g users -G kusers kuser01
#useradd -g users -G kusers kuser02
#useradd -g users -G kusers kuser03

# Añade password

#echo -e "local01\nlocal01" | passwd local01
#echo -e "local02\nlocal02" | passwd local02
#echo -e "local03\nlocal03" | passwd local03

#/etc/init.d/krb5-admin-server start
#/etc/init.d/krb5-kdc start

# Encender los servicios de PAM LDAP

/usr/sbin/nscd
/usr/sbin/nslcd

# Asegurar que funcione
getent passwd
getent group

/bin/bash
