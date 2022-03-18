# Kerberos SSHD Client
FROM debian:latest
LABEL version="1.0"
LABEL author="Keshi"
LABEL subject="Kerberos SSHD Client"
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install ssh krb5-user vim tree nmap mlocate less man procps ldap-utils iproute2 net-tools
RUN mkdir /opt/docker
COPY . /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
