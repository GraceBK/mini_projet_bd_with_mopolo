# bd_mopolo
Projet de Base de Donnée avec MOPOLO
## 1-) Creation de la base de données qui sera utilisée par Provisioning Manager
### Mot de passe.

	Objectif20

Archivage Activé


# Première connexion avec SQL\*Plus 

	sqlplus system/mot_de_passe@service
	system = un nom d'utilisateur

	sys/Objectif20 as sysdba

pour ne plus avoir a ecrire tout cela on peut modifier le fichier
	tnsnames.ora
qui se trouve dans mon cas :
	C:/app/Gb/product/11.2.0/dbhome_1/NETWORK/ADMIN

## 2-) Creation d'un espace table à l'aide de la commande suivante dans SQL\*Plus.
#### Dans l'exemple, remplacez le répertoire indiqué par celui dans lequel réside la base de données. Le répertoire doit exister pour que la commande aboutisse.

	create tablespace ts_nom_table
	datafile 'path/ts_nom_table.dbf'
	size 1000M ...

## 3-) Creation d'un espace table temporaire à l'aide de la commande suivante dans SQL\*Plus.

	create temporary tablespace ts_nom_table
	tempfile 'path/ts_nom_table.dbf'
	size 1000M ...

## 4-) Creation des utilisateurs et accord des droits à l'aide de la commande suivante dans SQL\*Plus.

	create user gracebk identified by <mot_de_passe> default tablespace ts_nom_table temporary
	



# 2. Organisation physique de la base sous Oracle 11g (2 jours)

-- Créer les tablespaces suivants et expliquer leur intérêt:


# ETAPE 
## Etape 1) Création de la base de données
## Etape 2) Création des tablespaces