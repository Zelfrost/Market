Market
======

Marché de l'information en JEE


INSTALLATION
====

Placer ce dossier ainsi que son contenu dans le dossier webapps de tomcat.

Dans WEB-INF/sources/Result.java :
	- Pour activer les mails :
		- Rechercher "Identifiants" dans le texte
		- Modifier les valeurs de username et password par celles d'un compte gmail. Sinon, remplir les paramètres d'un SMTP ( host, port, .. ) dans les lignes qui suivent;
	- Pour désactiver les mails :
		- Supprimer les // sur les lignes qui contiennent "///*".

Faire de même avec WEB-INF/sources/Pass.java.


Dans META-INF/context.xml :
	- La première resource correspond au Pool de connexion. A changer avec les infos de la base;
	- La seconde resource correspond au Realm d'identifications et ne doit pas être changé.


Exécuter dans la base le script createBase.sql qui se trouve à la racine.
/!\ Si la base contient des tables "users", "markets", "transactions" ou "notifications", celle-ci seront supprimées.

Placer l'ensemble du dossier WEB-INF/lib dans le CLASSPATH, ainsi que le dossier WEB-INF/classes.

Recompiler, d'abord le dossier WEB-INF/sources/tools/, puis WEB-INF/sources/ .

Lancer tomcat.

Have Fun.