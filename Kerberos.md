# kerberos21

Tenim **pràctica1+2** on hi tenim 1 docker en el nostre host, un amb el kerberos server (kserver21) i un client ( khost21 --> en un altre host) MiniLinux Fedora 32 amb kerberos client. El client s'instalarà tot a 'manija'.  

El servidor té un script on és crearàn els usuaris normals UNIX i alhora de kerberos (i 1 kerberos admin ?), executar els dimonis (krb5-admin-server i starkrb5-kdc).   

També farem que el client alhora tingui configurat PAM (concretament posant dins de '/etc/pam.d/...' els fitxers --> common-auth  common-password  common-session) perquè utilitzi el servidor de kerberos per autentificar (buscar a servidor el password que comença per 'k' al host kerberos (això ho fa el mòdul 'pam_krb5')), els usuaris locals que no tinguin PASSWORD i alhora es crearà un tiket validant que tenims drets com l'usuari connectat amb kerberos. 
 
389 --> LDAP (NO ESTÀ PERQUÈ EL SERVIDOR ESTÀ EN UN ALTRE DOCKER)
2200 --> SSH

*Cal l' EXPOSE del Dockerfile?* Sí. 
  
**SERVIDOR:**    

docker build -t rubeeenrg/kerberos21:kserver21 .  

docker push rubeeenrg/kerberos21:kserver21  

docker run --rm --name kserver.edt.org -h kserver.edt.org -p 749:749 -p 88:88 -p 464:464 -it rubeeenrg/kerberos21:kserver21  
(no cal --net 2hisix per AWS) 
 
docker run --rm --name kserver.edt.org --net 2hisix -h kserver.edt.org -p 749:749 -p 88:88 -p 464:464 -d rubeeenrg/kerberos21:kserver21  

**CLIENT (MINILINUX):**  

(li hem afeigt client ssh configurat per propagar tiquets keberos)
  
docker build -t rubeeenrg/kerberos21:khost21 . 
 
docker push rubeeenrg/kerberos21:khost21

docker run --rm --name khost.edt.org -h khost.edt.org -it rubeeenrg/kerberos21:khost21  

docker run --rm --name khost.edt.org -h khost.edt.org --net 2hisix -it rubeeenrg/kerberos21:khost21

    1  apt update
    2  apt install vim nmap procps -y
    3  nmap localhost
    4  apt install krb5-user
    5  cat /etc/krb5.conf
    6  kinit pere # ens logguejem com a pere
    7  klist   #mirem que veiem
    8  kadmin.local  #--> entrem a la linea de comandes kerberos-admin
    9  kadmin -p marta
    10 nmap kserver.edt.org

**RECORDAR POSAR EN EL '/etc/hosts' DEL HOST CLIENT ELS 'FQDN (Fully Qualified Domain Name)' AMB LES IP's CORRESPONENTS D'AMAZON PERQUÈQ SÀPIGA
RESOLDRE EL NOM 'kserver.edt.org'!!!!!!**  

ARA PROVES AL HOST CLIENT (MINI LINIUX SENSE 'khost_sshedtorg') (CLIENT FINAL):

guest@i24: kinit pere    (ens logguejem com a pere (passwd kerberos) i es generarà un tíquet)

klist --> veiem ticket generat.

(ara, essent 'local01' un usuari local UNIX sense password)
su local01 --> I si demana el password kerberos "klocal01" i entra --> OK !!!

---------------------------------------------------------------------------------------------------------------------------------------------
**NOVA PRACTICA 3 CONTAINERS: khost (client ssh client kerberos) + khost_sshedtorg (servidor ssh, client kerb, pam) + kserver(serv kerb)**  
---------------------------------------------------------------------------------------------------------------------------------------------

Aquesta pràctica consiteix en que si creem un tiquet per a un usuari kerberos en un host client kerberos (khost), i fem un ssh cap  a un altre client kerberos amb servidor ssh, el ticket ha de validar-se per al ssh com autentificació i així no demanar-nos password (encara que en 'sshd_conf' estigui habilitat).

RECORDAR que per autentificar-nos per ssh ho podem fer de 3 maneres: usuari-passwd, clau publica-privada, i per kerberos (ticket). 

**CLIENT khost21:**

Igual que abans pero afegim el client ssh (configurat 'ssh_config' perquè propagui els tickets kerberos generats en conexions ssh a altres equips)

**CLIENT khost_sshedtorg:**

docker build -t rubeeenrg/kerberos21:khost_sshedtorg . 
 
docker push rubeeenrg/kerberos21:khost_sshedtorg

docker run --rm --name ssh.edt.org -h ssh.edt.org -p 2200:22 --net 2hisix -d rubeeenrg/kerberos21:khost_sshedtorg

docker exec -it ssh.edt.org /bin/bash
 
**CREEM UN ALTRE DOCKER CLIENT AMB KERBEROS ACCESSIBLE VIA SSH (TINDRÀ SERVIDOR SSH):**

(El client final (khost) es connectarà via ssh amb aquest utilitzant un usuari kerberos, i el ssh no demanarà cap autentificació si s'ha fet tot bé, ja que el client khost propagarà el tíquet cap a 'khost_sshedtorg')
      
Desde khost fariem:

guest@i24: kinit user02 

guest@i24: ssh user02@ssh.edt.org     (on 'user0'2 ha d'exisistir a 'khost_sshedtorg' i alhora ha de ser un usuari kerberos)
	
*També tindrà validació PAM* (al fitxer 'system-auth') per indicar que ha de buscar a kserver21 els PASSWORDS dels usuaris.

**Servidor SSH**: Hem modificat el 'sshd_conf' perquè accepti autentificació via kerberos.

**HEM DE FER MANUALMENT (de moment l'script no ho fa):**

- Modificació del '/etc/hosts' del 'khost21' i del 'khost_sshedtorg' (mirar guia pràctica: 1er sempre el host 'ssh.edt.org')
 
(recordar que els usuaris 'user01, user02 i user03' han d'exsistir a 'khost_sshedtorg' i alhora ha de ser usuaris kerberos dins de 'kserver21')

- Alhora cal que el servidor SSH (o més aviat el servei 'sshd') estigui kerberitzat per tal d'acceptar tíquet per tal d'autentificar, per tant importem la clau.
      
kadmin -p user01/admin -w kuser01 -q "ktadd -k /etc/krb5.keytab  host/ssh.edt.org"

(recordar que ha d'estar afegit 'host/ssh.edt.org' com a principal abans en el servidor) (aquí sota ho veiem)

**SERVIDOR kserver21:**

**PROVEM:**

kadmin.local -q "listprincs" --> llistem usuaris kerberos

kadmin -p user01/admin --> entrar com a admin

kadmin -p user02 --> entrar com a usuari

*A l'script hem de tenir la següent ordre:*

kadmin.local -q "addprinc -randkey host/ssh.edt.org"   

# SERVEIX PER CREAR UNA CLAU QUE SI UN HOST L'IMPORTA EL SERVEI XXX (p.e ssh) PODRA  KERBERITZARSE (QUE PUGUI UTILTIZAR KERBEROS)

----------------------------------------------------------------------
**PROVES: ssh.edt.org**

Si el principal de host que s'ha creat al servidor kerberos és 'host/sshd.edt.org' es podrà realitzar l'accés kerberitzat només si es connecta al servidor usant aquest 'hostname', és a dir, amb les ordres:

ssh user02@ssh.edt.org  (OK) 

ssh user02@localhost     (NO!) --> PERÒ ENS VA BÉ PER VEURE SI SSH VA BÉ!

**ALTRE PROVA:**

L'usuari local01 sol·licita un ticket de 'user02' amb l'ordre 'kinit user02'.

Un cop obtingui ticket l'usuari 'local01' realitza l'ordre 'ssh user02@ssh.edt.org' i no li ha demanar passwd, i si fem..

[user02@sshd ~]$ klist 
Ticket cache: FILE:/tmp/krb5cc_1003_h55yoBfeGG
Default principal: user02@EDT.ORG
Valid starting     Expires            Service principal
02/22/19 16:49:35  02/23/19 16:49:35  krbtgt/EDT.ORG@EDT.ORG
02/22/19 16:49:56  02/23/19 16:49:35  host/sshd.edt.org@EDT.ORG

A més del seu tíquet té el tíquet del servidor 'sshd', que li permet iniciar sessió 'ssh' de manera desatesa.

**PROVES EN EL khost:**

/etc/hosts:

172.19.0.1 ssh.edt.org kserver.edt.org  (la IP es la del host, no es cap docker)

+

Idem que adalt.

----------------------------------------------------------------------
**A RECORDAR:**

nmap localhost  == nmap i24 --> Veiem els ports dels nostres serveis que es comuniquen entre si

nmap <nostreIPpublica> --> Veiem els ports dels nostres serveis i els ports que publiquem (inclosos els ports dels docker)

DINS DEL DOCKERFILE EXPOSE 22--> El docker compartira/donara visibilitat al port del servei en el host on es desplegat

QUAN FEM 'docker run -p 2200:22' el que estem fent es agafar el port del servei del docker (ex ssh) fem que les peticions del host s'escoltin per el 2200.
