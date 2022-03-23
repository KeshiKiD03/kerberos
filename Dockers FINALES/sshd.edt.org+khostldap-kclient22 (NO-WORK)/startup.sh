#! /bin/bash

# SSHD.edt.org + KhostLdap
# @Keshi ASIX M11-SAD Curs 2021-2022

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
cp /opt/docker/sshd_config /etc/ssh/sshd_config
cp /opt/docker/ssh_config /etc/ssh/ssh_config

# Copiamos archivos de PAM LDAP

cp /opt/docker/ldap.conf /etc/ldap/ldap.conf
cp /opt/docker/login.defs /etc/login.defs
cp /opt/docker/nsswitch.conf /etc/nsswitch.conf
cp /opt/docker/nslcd.conf /etc/nslcd.conf

# Copiamos Archivos de PAM

cp /opt/docker/common-auth /etc/pam.d/common-auth
cp /opt/docker/common-account /etc/pam.d/common-account
cp /opt/docker/common-password /etc/pam.d/common-password
cp /opt/docker/common-session /etc/pam.d/common-session

# Generem la CLAU de HOST - Iniciem amb marta - kmarta i fem el kadmin: ktadd -k ....

kadmin -p admin -w kadmin -q "ktadd -k /etc/krb5.keytab host/sshd.edt.org"

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

# Encender los servicios de PAM LDAP

/usr/sbin/nscd
/usr/sbin/nslcd

# Asegurar que funcione 
# (Estará en Detach por lo que será desde fuera "docker exec sshd.edt.org getent passwd")
# getent passwd
# getent group

mkdir /run/sshd
#/usr/sbin/sshd && echo "SSH Activado"

# Detach
/usr/sbin/sshd -D && echo "SSH Activado"

#/bin/bash
