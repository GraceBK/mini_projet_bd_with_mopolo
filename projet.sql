-- 1. Schéma logique de données (1 jour)
---- 1.1 Sujet à choisir
------ TODO: Le sujet et la Description (optionnelle)

---- 1.2 Schéma logique de données
------ Définir ou générer un schéma logique de la base de données avec au moins 7 tables:
------ o Prendre en compte dans cette phase les règles de gestion de type contraintes
------   d'intégrités (de domaine : check/not null, d’entité : primary key/unique key,
------   de référence : foreign key)
-- REPONSE _____________________________________________________________________________--
/*
SALON (NUM_SAL, NOM_SAL, PAYS_SAL, VILLE_SAL, DATE_DEBUT_SAL, DATE_FIN_SAL)
UTILISATEUR (MAILTO_USR, NOM_USR, PRENOM_USR, DATE_NAISS_USR, PAYS_USR, VILLE_USR, NB_AMIS_USR)
AMITIE (MAILTO_USR1, MAILTO_USR2)
JEU (ID_JEU, NOM_JEU, ANNEE_SORTIE_JEU)
FABRICANT (ID_FAB, NOM_FAB)
SERVEUR (ID_SER, NOM_SER)
LOCALITE (ID_LOC, VILLE_LOC)
*/
-- QUESTION ____________________________________________________________________________--
------ o Définir au moins un trigger pour assurer l’intégrité des données ne pouvant être
------   prise en charge par les contraintes d’intégrités du modèle relationnel
-- REPONSE _____________________________________________________________________________--
-- TODO
--______________________________________________________________________________________--




-- 2. Organisation physique de la base sous Oracle 11g (2 jours)
------ En partant du schéma logique définit précédemment, vous procédérez dans cette étape
------ à l’organisation physique de la base de données.

------ Vous devez donc assurerer les tâches suivantes :
------ o Créer les tablespaces suivants et expliquer leur intérêt:
--------  Un ou plusieurs tabespaces pour stocker les données des tables.
-- REPONSE _____________________________________________________________________________--
------------- TableSpaces pour stocker les données de tables:
create tablespace TS_DATA_USER
	datafile 'C:\APP\GB\ORADATA\PROJETJGM\TS_DATA_USER.dbf'
	size 10M
	extent management local autoallocate
	segment space management auto;

--------  Un ou plusieurs tablespaces pour stocker les données d’indexes
-- REPONSE _____________________________________________________________________________--
------------- TableSpaces pour stocker les données d'index:
create tablespace TS_INDEX_DATA
	datafile 'C:\APP\GB\ORADATA\PROJETJGM\TS_INDEX_DATA.dbf'
	size 10M
	extent management local autoallocate
	segment space management auto;

--------  Un tablespace pour stocker les segments temporaires.
-- REPONSE _____________________________________________________________________________--
------------- TableSpaces pour stocker les données d'index:
create temporary tablespace TS_SEG_TEMP
	datafile 'C:\APP\GB\ORADATA\PROJETJGM\TS_SEG_TEMP.dbf'
	size 10M
	extent management local autoallocate
	segment space management auto;

-------- Note: Tous vos tablespaces seront gérés localement. Ils seront en mode AUTOALLOCATE
-------- ou UNIFORM SIZE. Vous devez expliquer l’intérêt et les bénéfices de vos choix.

------ o Créer un utilisateur de votre choix qui sera propriétaire de votre application.
------   Les segments temporaires doivent être localisés dans le tablespace approprié créé
------   précédement. Vous devez lui donner les droits appropriés.
-- REPONSE _____________________________________________________________________________--
------ Je créé l'utilisateur mopolo
create user mopolo identified by admin
	default tablespace users
	temporary tablespace TS_SEG_TEMP;

------ Je donne mopolo tout les priviléges
grant dba to mopolo;

------ On limite pour mopolo les ts
revoke unlimited tablespace from mopolo;

------ On autorise mopolo les droits d'écriture dans users
alter user mopolo quota unlimited on users;

------ o Créer le schéma de données en séparant les données des tables et les index
--------  Vous dimensionnerez de façon pertinente les segments. Pour cela vous devez
--------    utiliser le package DBMS_SPACE pour estimer la volumétrie de vos tables et de vos
--------    indexes afin de trouver le volume de données nécessaire dès la création de ces segments.
--------    Il est important d’estimer le nombre total de lignes de chacune de vos tables
-- REPONSE _____________________________________________________________________________--
-------- TODO : Demande de l'aide


--------  Insérer pour l’instant en moyenne une dizaine de lignes de test dans chacune des tables.
-- REPONSE _____________________________________________________________________________--
------  
------ 
------ 
------ 
------ 
------ 
------ 

-- insertion SALON (NUM_SAL, NOM_SAL, PAYS_SAL, VILLE_SAL, DATE_DEBUT_SAL, DATE_FIN_SAL)
insert into SALON values(1, );
insert into SALON values(2, );
insert into SALON values(3, );
insert into SALON values(4, );
insert into SALON values(5, );
insert into SALON values(6, );
insert into SALON values(7, );
insert into SALON values(8, );
insert into SALON values(9, );
insert into SALON values(10, '', '');

-- insertion UTILISATEUR (MAILTO_USR, NOM_USR, PRENOM_USR, DATE_NAISS_USR, PAYS_USR, VILLE_USR, NB_AMIS_USR)
insert into UTILISATEUR values(1, );
insert into UTILISATEUR values(2, );
insert into UTILISATEUR values(3, );
insert into UTILISATEUR values(4, );
insert into UTILISATEUR values(5, );
insert into UTILISATEUR values(6, );
insert into UTILISATEUR values(7, );
insert into UTILISATEUR values(8, );
insert into UTILISATEUR values(9, );
insert into UTILISATEUR values(10, );

-- insertion AMITIE (MAILTO_USR1, MAILTO_USR2)
insert into AMITIE values(1, );
insert into AMITIE values(2, );
insert into AMITIE values(3, );
insert into AMITIE values(4, );
insert into AMITIE values(5, );
insert into AMITIE values(6, );
insert into AMITIE values(7, );
insert into AMITIE values(8, );
insert into AMITIE values(9, );
insert into AMITIE values(10, );

-- insertion JEU (ID_JEU, NOM_JEU, ANNEE_SORTIE_JEU)
insert into JEU values(1, );
insert into JEU values(2, );
insert into JEU values(3, );
insert into JEU values(4, );
insert into JEU values(5, );
insert into JEU values(6, );
insert into JEU values(7, );
insert into JEU values(8, );
insert into JEU values(9, );
insert into JEU values(10, );

-- insertion FABRICANT (ID_FAB, NOM_FAB)
insert into FABRICANT values(1, );
insert into FABRICANT values(2, );
insert into FABRICANT values(3, );
insert into FABRICANT values(4, );
insert into FABRICANT values(5, );
insert into FABRICANT values(6, );
insert into FABRICANT values(7, );
insert into FABRICANT values(8, );
insert into FABRICANT values(9, );
insert into FABRICANT values(10, );

-- insertion SERVEUR (ID_SER, NOM_SER)
insert into SERVEUR values(1, );
insert into SERVEUR values(2, );
insert into SERVEUR values(3, );
insert into SERVEUR values(4, );
insert into SERVEUR values(5, );
insert into SERVEUR values(6, );
insert into SERVEUR values(7, );
insert into SERVEUR values(8, );
insert into SERVEUR values(9, );
insert into SERVEUR values(10, );

-- insertion LOCALITE (ID_LOC, VILLE_LOC)
insert into LOCALITE values(1, );
insert into LOCALITE values(2, );
insert into LOCALITE values(3, );
insert into LOCALITE values(4, );
insert into LOCALITE values(5, );
insert into LOCALITE values(6, );
insert into LOCALITE values(7, );
insert into LOCALITE values(8, );
insert into LOCALITE values(9, );
insert into LOCALITE values(10, );