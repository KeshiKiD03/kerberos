# Rubén Rodríguez García
# Kerberos (Protocol d'autenticació)

### Apunts generals:
Autenticació --> Auth

Autorització --> Autz

AP (Auth Provider) --> ldap, unix (fitxers classics (uid, gid, passwd...)), **kerberos**

IP (Information Provider) --> ldap, unix (fitxers classics (uid, gid, passwd...))

Kerberos no ens proporciona informació dels usuaris, per això només és un auth provider.

Kerberos --> Third party (tercer interlocutor en el procés d'autenticació)

Hi ha un mòdul de PAM anomenat kerberos, valida el password de l'usuari contra la base de dades de kerberos.

Usuaris en kerberos --> principals

L'usuari quan és connecta i és valida obté un 'ticket' (klist (veiem ticket))

Amb aquest ticket tenim la oportunitat de presentar-nos en diversos serveis, amb el ticket no ens demanarà el password.

Els serveis han d'estar 'kerberitzats' per poder entrar amb el 'ticket'.

kclient --> client de kerberos

kserver --> servidor de kerberos
