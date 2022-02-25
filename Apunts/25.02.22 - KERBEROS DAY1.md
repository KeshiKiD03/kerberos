# M11-SAD Seguretat i alta disponibilitat
## Escola Del Treball
### 2HISX 2021-2022
### Aaron Andal

https://geekland.eu/aprender-markdown-en-minutos/ 

#### EMOJIS CHEATSHEET

👹 🤬  😍 🥰  🥺  👾  👽  👍  🔥  🌈 ☀️  🌤 ☄️  🚧 ☢️ 

☣️ ⛔️  💮  🆚 ❗️ ❗️ ❗️ ❓ ❓  💯 ❤️‍🔥  💛  🧡  💟 

25.02.22

## KERBEROS

Kerberos is a network authentication protocol created by MIT, and uses symmetric-key cryptography to authenticate users to network services, which means passwords are never actually sent over the network. Consequently, when users authenticate to network services using Kerberos, unauthorized users attempting to gather passwords by monitoring network traffic are effectively thwarted.


¿Que es?

* Autenticació Auth --> Quién es

* Autorització Autz --> Que ha dejado hacer

* AP -- <AuthProvider>

* IP --<InformationProvider>

* ldap está a 2 lugares, tenemos info del usuario en 2 lugares (AP/IP).

* unix (uid, gid, password) ... También.

-----------------------

* Kerberos es un mecanismo de autenticación --> **GESTIONA PASSWORDS**. **No tiene INFORMACIÓN PROVIDER**, sólo "**AUTH PROVIDER**".

    * Es un *third party*, en un proceso de autenticación.

    * Usuario se loguea, podemos usar un **módulo de pam** llamado **Kerberos**.

        * Módulo de Kerberos --> Valida usuario contra la *base de datos* de Kerberos.

    * Usa su propio lenguaje:

        * Usuarios --> **PRINCIPALS**.

    1. El usuario cuando se conecta, obtiene un TICKET.

    * **klist** --> Ticket de Kerberos.

        * La idea es que se puede presentar a diferentes servicios con este ticket. Si se presenta con este ticket, no pedirá **usuario/password**, **avalará** que somos nosotros.

        * Cada vez que queremos accedir por ejemplo a un servidor WEB, LDAP... Si está todo configurado con **Kerberos**, no nos volverá a **pedir autorización**, ya que cuando desde cliente, no volverá a pedir contraseña.

        * Ejemplo **SSH Kerberizado**.

        * **LOS SERVICIOS**, POR LOS CUALES **ENTRAMOS MEDIANTE TICKET**, **ESTÁ COMPILADO/CONFIGURADO** DE TAL FORMA QUE ACEPTA **KERBEROS**.

    * SSH no está configurado por Kerberos por defecto --> **HAY QUE CONFIGURARLO**.

    * Todo lo que comience con **KRB5** es de **Kerberos**.

    * La idea es que cada **SERVICIO** está con **Kerberos**.

        * Por debajo hay más **diálogo**.

        * El **servidor** valida contra el **Kerberos**.

        * Los **TICKETS SIRVEN PARA AVALAR** que eres TÚ, para que no te suplanten la IDENTIDAD.

        * Kerberos por sí mismo **NO FUNCIONA** --> Hay que implementar con un SERVICIO --> **LDAP**.

        * Se usará una **DOCKER de LDAP** incorporar con **Kerberos** para aumentar su sistema de seguridad para acceder. Se usará un PAM LDAP que accederá y avalará mediante **TICKETS de KERBEROS**.

        * KServer --> Se crea una entrada de Password para cada USUARIO.

        * El acceso al **NFS de HOME** de **GANDHI** es a través del **TICKET de KERBEROS**.

        * **AD (LDAP)** incluye **Kerberos**.

        * SAMBA4 = AD --> Incluye Kerberos.

    * **SOFTWARE** equivalente a todo esto es **FRIVA** --> Modelo de Red Hat.

    * 

    * 

**EJERCICIO**

1. El cliente se pueda con el servidor y obtener un **TICKET** --> Si te lo da es **OK**.

2. Los passwords de los usuarios empiecen por "K".

3. Los usuarios tendrán passwords kpere, kmarta, kanna --> Para **ENTENDER** a que **SERVIDOR ATACAMOS**, **Kerberos** o **LDAP**.

**EJERCICIO**

1. docker run --rm --name kserver -h kserver.edt.org --net 2hisx -it debian:11 /bin/bash

2. apt-get install krb5-workstation




* **INSTALLATION SERVER**

1. docker run --rm --name kserver -h kserver.edt.org --net 2hisx -it debian:11 /bin/bash

2. apt-get update

2. apt-get install krb5-admin-server

3. **Kingdom**: EDT.ORG --> Dominio EDT.ORG (nombre de DNS) --> **REALME** van en **MAYÚSCULA**

KDC / KADMIN --> MISMO SERVIDOR QUE EJECUTA LOS 2 SERVIDORES.

[REALMS]
EDT.ORG = {
    kdc = krb.edt.org
    admin_server = krb.edt.org

}

[domain_realm]

.edt.org = EDT.ORG --> Todos los hosts que acaben en .EDT.ORG
edt.org = 


4. kserver.edt.org **x2**.

    1 para KDC --> (?)

    1 para ADMIN --> Administración de TICKETS (?)

5. apt-get install mlocate tree nmap

6. **mlocate** --> **updatedb** --> **Localizar los ficheros fácil**

7. apt-get install less ||||| dpkg -L (krb5-admin-server) | less

`/etc/init.d/krb5-admin-server`

`/lib/systemd`

`kadmin.local | kadmind | kprob | krb5_newrealm ...`

8. locate krb5.

`/var/lib/krb5kdc`

9. apt-get install vim | apt-get install nano

10. vim /etc/krb5.conf --> Ver EDT.ORG

11. cp /etc/krb5.conf /etc/krb5.conf.backup

```sql
[realms]
	EDT.ORG = {
		kdc = kserver.edt.org
		admin_server = kserver.edt.org
	}

[domain_realm]
	.edt.org = EDT.ORG
	edt.org = EDT.ORG

```

* locate kdc.conf

* tree /etc/krb5kdc

* vim /etc/krb5kdc/kdc.conf --> **FICHERO DE CONFIGURACIÓN DEL KDC**

CREAR BASE DE DATOS DE KERBEROS

1. kdb5_util create -s # --> CREAR BD -S DE STASH

2. **MASTERKEY** --> KDC Database Masterkey --> **masterkey** 

```sql
Initializing database '/var/lib/krb5kdc/principal' for realm 'EDT.ORG',
master key name 'K/M@EDT.ORG'
You will be prompted for the database Master Password.
It is important that you NOT FORGET this password.
Enter KDC database master key: 
Re-enter KDC database master key to verify: 

```

3. tree /var/lib/krb5kdc/ --> **Base de datos de PRINCIPALES**

```
/var/lib/krb5kdc/
|-- principal
|-- principal.kadm5
|-- principal.kadm5.lock
`-- principal.ok

```

    * HAY LAS ENTRADAS

4. locate kadm5.acl

5. man kadm5.acl

6. vim /etc/krb5kdc/kadm5.acl
```
*/admin@EDT.ORG *
alpaca@EDT.ORG *
marta@EDT.ORG *  
```


* Se comunica a través del **PROTOCOLO** --> Puerto // FUNCIONA LA COMUNICACIÓN

* Solo se ejecuta en el *SERVIDOR*, accede físicamente a los datos. Ldap usa ldapsearch - slapcat

# kadmin.local -q "addprinc alpaca" # --> MANUAL

# password --> kalpaca

* kadmin.local --> addprinc superuser --> ksuperuser --> # CREA USUARIO # INTERACTIVO

# kadmin.local -q "listprincs" --> Mostra usuarios de Kerberos

* TGT --> Ticket Grant Ticket --> Usuarios que hace **Expedir tickets**.

# kadmin.local --> ? --> Mostra HELP

```sql
add_principal, addprinc, ank
                         Add principal
delete_principal, delprinc
                         Delete principal
modify_principal, modprinc
                         Modify principal
rename_principal, renprinc
                         Rename principal
change_password, cpw     Change password
get_principal, getprinc  Get principal
list_principals, listprincs, get_principals, getprincs
                         List principals
add_policy, addpol       Add policy
modify_policy, modpol    Modify policy
delete_policy, delpol    Delete policy
get_policy, getpol       Get policy
list_policies, listpols, get_policies, getpols
                         List policies
get_privs, getprivs      Get privileges

```

* kadmin.local -q "getprinc anna"

```
kadmin.local:  getprinc anna
Principal: anna@EDT.ORG
Expiration date: [never]
Last password change: Fri Feb 25 10:24:46 UTC 2022
Password expiration date: [never]
....
```

`Policy: [none]`

* **Kerberos funciona con tema de claves**.

    * AES125 / AES256 --> Tipo de CLAVE.

    * Con la contraseña que le damos --> **GENERA UNAS CLAVES** --> Sirve para **VALIDARSE**, para acceder a los **SERVICIOS**.



# SERVICIOS  

* **KDC** = **Key Distribution Center** --> Servicio que se encarga de generar las **CLAVES** y Distribuirlas.

* **KADMIN** = Permite comunicarse y administració del **SERVICIO DE KERBEROS**.

* Hay que encender los dos serviciso.



_-------------------------------------------------------------------


* dpkg -L krb5-admin-server | grep service

* En un container **NO HAY SYSTEMD**.

* **krb5_newrealm**

## INICIAR SERVICIO (SERVIDOR)

* **/etc/init.d/krb5-admin-server start** --> INICIAR KADMIN

*  **/etc/init.d/krb5-admin-server status**

* **/etc/init.d/krb5-kdc start** --> INICIAR KDC

`ERROR DA DES3` --> *DEPRECATED*

* **/etc/init.d/krb5-kdc status**

* apt-get install procps --> Para poder hacer PS AX.

* nmap localhost --> Abierto el 88 , 749, 464

```sql
root@kserver:/# nmap localhost
Starting Nmap 7.80 ( https://nmap.org ) at 2022-02-25 10:35 UTC
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000010s latency).
Other addresses for localhost (not scanned): ::1
Not shown: 997 closed ports
PORT    STATE SERVICE
88/tcp  open  kerberos-sec
464/tcp open  kpasswd5
749/tcp open  kerberos-adm

Nmap done: 1 IP address (1 host up) scanned in 0.13 seconds

```

* **IMPORTANTE PUERTO 88 , 464 , 789**

**PROBARLO** --> LLAMA AL SERVIDOR POR EL PUERTO 88 464 Y 789 Y LE HA PEDIDO UN TICKET, **DA OK**

* **kinit pere** --> kpere

* **klist** --> Mostra ticket de Pere

```sql
root@kserver:/# klist
Ticket cache: FILE:/tmp/krb5cc_0
Default principal: pere@EDT.ORG

Valid starting     Expires            Service principal
02/25/22 10:37:05  02/25/22 20:37:05  krbtgt/EDT.ORG@EDT.ORG
	renew until 02/26/22 10:37:03


```

* **kdestroy** --> Destruye el **TICKET**.

* klist --> Mostra ticket destruido de PERE

* kinit pere

    * TICKET CACHE: FILE /TMP/KRBCC_0 --> # --> NO FOUND TICKET

* **kinit anna** --> Inicia ANNA , TODO OK

* klist --> Muestra ticket de ANNa

* kdestroy --> BORRA TICKET

* klist --> No tiene tickets ya



* **kadmin.local**.


* **kadmin** --> Se hace desde cualquier **cliente**, se comunica a través del **PROTOCOLO**.

    * Da error --> Intenta entrar como **ROOT/ADMIN@EDT**.

    * **kadmin -p pere** # --> (-p principal)

    * kpere --> `password`

    *   kadmin: **list princs** --> No puede porque no tiene permisos de listar.

    *   kadmin: **getprinc marta** --> No puede


* **kadmin -p marta**

    * kmarta --> `password`

    *   kadmin: **listprincs** --> Marta SI PUEDE PORQUE TENEMOS DEFINIDA LA `ACL` PARA MARTA `ALL PRIVILEGES GRANT`.

    *   kadmin: **addprinc pere/admin** --> No hace falta EDT.ORG porque lo rellena. Tendrá el **ROL** de **ADMIN**. Se tiene que crear como **PRINCIPAL** como cualquier otro.


* **kadmin -p pere**.

    * kpere

    * NO PUEDE PORQUE SE ESTÁ AUTENTICANDO COMO **PERE** PERO NO COMO **PERE/ADMIN**.


* **kadmin -p pere/admin**

    * kpere

    * **AHORA YA ESTÁ EN MODO ADMINISTRADOR.**



-------------------------------

**EJEMPLOS**

LLISTAR Y CREAR // VER ACL

listprinc --> LLISTAR Y CREAR

DELEGAR PERMISOS


-----------------------------



## INICIAR CLIENTE KERBEROS (CLIENTE)

* docker run --rm --name kclient -h kclient.edt.org --net 2hisx -it debian:11 /bin/bash

* apt-get update

* **apt-get install vim nmap procps mlocate krb5-user**

<PÁGINA 20>

* **CLIENTE** --> krb.conf --> TENER CONECTIVIDAD. 

* REALME: EDT.ORG --> # Default REALME 

* kserver.edt.org **x2** --> # --> Kerberos Servers REALME - Administrative Server

* **kinit pere**

    * kpere --> `PASSWORD`

    * **klist**.

* kinit --> TENEMOS UN SERVIDOR KERBEROS --> LAS ESTACIONES CLIENTE DE CONECTARSE Y OBTENER UN TICKET --> INSTALAR EL PAQUETE CLIENTE (krb5-user) --> KINGDOM (EDT.ORG) - REALME Y 2 SERVIDORES (kserver.edt.org).

* **kadmin.local --> NO SE PUEDE PORQUE NO HAY SERVIDOR LOCAL** **SÓLO CLIENTE**

* **kadmin -p marta** --> **listprincs** --> Desde cualquier cliente, puede conectarse a algún **usuario admin del sistema**. Se **conecta y autentica bien** y obtiene bien los **TICKETS**.

* nmap **kserver.edt.org**. --> Identificar el nombre de **kserver.edt.org** --> En el **/etc/hosts**. --> `kserver` y `kadmin` la **MISMA IP**. `PROHIBIDO USAR IP. SOLO IP`.





- `GENERAR UN DOCKERFILE` --> KSERVER Y KCLIENT.

    * PROCESO NO INTERACTIVO.

    * COPIAR LOS FICHEROS.

    * KACL

    * KADMIN