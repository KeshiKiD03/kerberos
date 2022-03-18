#! /bin/bash

cp /opt/docker/krb5.conf /etc/krb5.conf 	# Sobreescrivim els fitxers per els nostres.
#cp /opt/docker/sshd_config /etc/ssh/sshd_config
cp /opt/docker/ssh_config /etc/ssh/ssh_config

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

mkdir /run/sshd
/usr/sbin/sshd && echo "SSH Activado"

# Detach
/usr/sbin/sshd -D && echo "SSH Activado"

# Comentar esto if detach
/bin/bash
