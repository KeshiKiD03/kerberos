# Pràctiques Kerberos

### Exercici 1:
* Construcció de servidor i client Kerberos.

  Farem que el client és consegueixi communicar amb el ticket

  Els passwords dels usuaris començin per 'k'

### Documentació:
#### Servidor:
* docker run --rm --name kserver -h kserver.edt.org --net 2hisix --it debian:11 /bin/bash
* @kserver: apt update
* @kserver: apt install krb5-admin-server
* @kserver: version 5 realm (kingdom): EDT.ORG (sempre en majúscula)
* @kserver: kerberos servers for you realm (nom del servidor): kserver.edt.org
* @kserver: Administrative server for your Kerberos realm: kserver.edt.org
* @kserver: apt install mlocate tree nmap less vim man procps
* @kserver: updatedb
* @kserver: dpkg -L krb5-admin-server | less

**/etc/init.d/krb5-admin-server --> Nom del server**

* @kserver: locate krb5 --> Per veure on estàn les coses
* @kserver: cp /etc/krb5.conf /etc/krb5.conf.bk --> Fitxer de configuració principal.
* @kserver: vim /etc/krb5.conf --> Ens carreguem tots els 'realms' menys el nostre, també ens carreguem tots els domain_realm i afegim el nostre

.edt.org=EDT.ORG

edt.org=EDT.ORG

* @kserver: locate kdc.conf
* @kserver: vim /etc/krb5kdc/kdc.conf --> Ports que utiltiza el kerberos (no cal modificar res), ens dona informació sobre el temps de vida dels 'tickets', cada quan és renoven, etc (Fitxer de configuració del 'kdc')
* @kserver: kdb5_util create -s --> (-s --> stash_file (fitxer on queda guardada la 'master key') --> Creem la base de dades de kerberos --> master key --> master key
* @kserver: tree /var/lib/krb5kdc --> Aquí trobem la base de dades principal
* @kserver: locate kadm5.acl
* @kserver: vim /etc/krb5kdc/kadm5.acl --> Ens fabriquem el fitxer 'acl' (Quines coses pot fer o no l'usuari)

\*/admin@EDT.ORG *

alpaca@EDT.ORG *

marta@EDT.ORG *

**L'asterisc vol dir que poden fer tot**

* @kserver: kadmin.local -q "addprinc [alpaca/pere/marta/anna]" --> '-q query' --> Si funciona vol dir que està tot correcte (només es pot executar al servidor, està accedint fisicament a les dades)

**password: [kalpaca/kpere/kmarta/kanna]**

* @kserver: kadmin.local --> Anirem a parar a un 'subshell'
* @kadmin.local: addprinc superuser

**password: ksuperuser**

* @kserver: kadmin.local -q "listprincs" --> Llistem els principals (krbtgt --> genera tickets)
* @kserver: kadmin.local -q "getprinc anna" --> Informació de l'usuari principal "anna"
* @kserver: ls /etc/init.d/krb5- --> Prenem 'tab' i veiem els noms dels servidors

**krb5kdc --> utilitza KDC (Key Distribution Center), servei que s'encarrega de generar les claus i distrubir-les**

**kadmin --> permert administrar kerberos**

* @kserver: dpkg -L krb5-admin-server | grep service
* @kserver: /etc/init.d/krb5-admin-server start
* @kserver: /etc/init.d/krb5-admin-server status
* @kserver:/etc/init.d/krb5-kdc start

Starting Kerberos KDC: krb5kdcStash file /etc/krb5kdc/stash uses DEPRECATED enctype des3-cbc-sha1!

* @kserver: /etc/init.d/krb5-kdc status

**Ja estàn en funcionament els serveis**

* @kserver: nmap localhost --> Comprovem (88 i 749 --> Identifiquen (administracií), 464 assignació password)
* @kadmin: kinit pere --> Ens logueguem com a 'pere' (ens demanarà el password de kerberos de pere (kpere)), si afeguim altra ticket, sobreescriurà el que ja teniem.
* @kadmin: klist --> Tenim el ticket que ens avala com a pere (suplantació d'identitat)
* @kadmin: kdestroy --> Ens carreguem el ticket
* @kserver: klist --> Comprovem que ja no hi ha ticket
* @kserver: kadmin.local --> Només podem si som 'root'
* @kserver: kadmin --> Error perquè 'root' no existeix
* @kserver: kadmin -p pere --> -p "principal" 
* @kadmin: listprincs --> No pot ja que no te permisos
* @kadmin: getprinc pere --> S'està mostrant a sí mateix, llavorns si que pot
* @kadmin: getprinc marta --> No té permisos d'adminsitració
* @kserver: kadmin -p marta
* @kadmin: listprincs --> Marta si que pot perquè a les ACL hem definit que si que pot
* @kadmin: addprinc pere/admin --> Com només estem treballant amb el domini 'EDT.ORG', no cal posar-lo (pere serà admin quan tingui aquest rol)
* @kserver: kadmin -p pere
* @kadmin: listprincs --> No pot ja que s'ha loguegat com a pere, no com a pere amb rol d'admin
* @kserver: kadmin -p pere/admin
* @kadmin: listprincs --> Ara sí que pot
* @kadmin: ? --> help d'ordres

#### Client:
* docker run --rm --name kclient -h kclient.edt.org --net 2hisix -it debian:11 /bin/bash
* @kclient: apt install vim nmap procps krb5-user
* @kclient: version 5 realm: EDT.ORG
* @kclient: servers for your realm: kserver.edt.org
* @kclient: administrative server for your ... : kserver.edt.org
* @kclient: cat /etc/krb5.conf
* @kclient: kinit pere --> Demostrem que tenim un server kerberos, i que ens connectem i ens dona el ticket
* @kclient: klist --> Comprovem que tenim el ticket
* @kclient: kadmin.local --> No podem ja que som clients
* @kclient: kadmin -p marta --> Des de qualsevol client podem administrar un usuari 'admin' del sistema sense necessitat d'anar al servidor
* @kadmin: listprincs
* @kclient: nmap kserver.edt.org --> Comprovem que hi ha connectivitat
