FROM debian:11
LABEL version="1.0"
LABEL author="@edt ASIX-M06"
LABEL subject="KERBEROS Client SSH + Ldap"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install ssh net-tools krb5-user libpam-krb5 mlocate procps iproute2 tree nmap nano vim less finger passwd libpam-pwquality libpam-mount libpam-mkhomedir libpam-ldapd libnss-ldapd nslcd nslcd-utils ldap-utils 
# samba samba-client
RUN mkdir /opt/docker
COPY . /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
EXPOSE 88 464 749
