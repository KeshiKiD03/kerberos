# Kerberos SSHD Client + Khostldap
FROM debian:latest
LABEL version="1.0"
LABEL author="Keshi"
LABEL subject="Kerberos SSHD Client + LDAP"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install ssh krb5-user vim tree nmap mlocate less man procps ldap-utils iproute2 net-tools finger nano libpam-krb5 passwd libpam-pwquality libpam-mount libpam-mkhomedir libpam-ldapd libnss-ldapd nslcd nslcd-utils
RUN mkdir /opt/docker
COPY . /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
EXPOSE 88 464 749