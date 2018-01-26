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

-- insertion FABRICANT (ID_FAB, NOM_FAB)
insert into FABRICANT values(1, 'Sega');
insert into FABRICANT values(2, 'Sony');
insert into FABRICANT values(3, 'Rockstar Games');
insert into FABRICANT values(4, 'Microsoft');
insert into FABRICANT values(5, 'Koei');
insert into FABRICANT values(6, 'Konami');
insert into FABRICANT values(7, 'Lego Media');
insert into FABRICANT values(8, 'LucasArts');
insert into FABRICANT values(9, 'Ubisoft');
insert into FABRICANT values(10, 'Vivendi Games');

-- insertion LOCALITE (ID_LOC, VILLE_LOC)
insert into LOCALITE values(1, 'Paris');
insert into LOCALITE values(2, 'Marseille');
insert into LOCALITE values(3, 'Lyon');
insert into LOCALITE values(4, 'Toulouse');
insert into LOCALITE values(5, 'Nice');
insert into LOCALITE values(6, 'Nantes');
insert into LOCALITE values(7, 'Montpellier');
insert into LOCALITE values(8, 'Strasbourg');
insert into LOCALITE values(9, 'Bordeaux');
insert into LOCALITE values(10, 'Lille');

-- insertion SERVEUR (ID_SER, NOM_SER)
insert into SERVEUR values(1, 'LINUX17');
insert into SERVEUR values(2, 'MAC10');
insert into SERVEUR values(3, 'WIN10');
insert into SERVEUR values(4, 'ACERACER');
insert into SERVEUR values(5, 'FEELING2');
insert into SERVEUR values(6, 'LWS');
insert into SERVEUR values(7, 'LESLASCAR');
insert into SERVEUR values(8, 'UNLIMIT');
insert into SERVEUR values(9, 'SEGFAULT');
insert into SERVEUR values(10, 'AAA');

-- insertion JEU (ID_JEU, NOM_JEU, ANNEE_SORTIE_JEU)
insert into JEU values(1, 'Watch Dogs 2', '15/11/2016');-- Ubisoft
insert into JEU values(2, 'World of Warcraft', '02/11/2004');-- Vivendi Games
insert into JEU values(3, 'Assassin s Creed', '13/11/2007');-- Ubisoft
insert into JEU values(4, 'Probotector', '08/01/1988');-- Konami
insert into JEU values(5, 'Samurai Warriors 4', '24/03/2014');-- Koei
insert into JEU values(6, 'One Piece: Pirate Warriors', '1/03/2012');-- Koei
insert into JEU values(7, 'Monkey Island', '15/06/2009');-- LucasArts
insert into JEU values(8, 'Grand Theft Auto V', '17/11/13');-- Rockstar Games
insert into JEU values(9, 'Lego Island', '26/11/1997');-- Lego Media
insert into JEU values(10, 'Maze of Shadows', '24/03/2005');-- Lego Media

-- insertion UTILISATEUR (MAILTO_USR, NOM_USR, PRENOM_USR, DATE_NAISS_USR, PAYS_USR, VILLE_USR, NB_AMIS_USR)
insert into UTILISATEUR values('uzumaki@gmail.com', 'Uzumaki', 'Naruto', '10/10/1985', '', 'Konoha', 2);
insert into UTILISATEUR values('uchiha@hotmail.com', 'Uchiha', 'Sasuke', '23/07/1985', '', 'Konoha', 2);
insert into UTILISATEUR values('haruno@yahoo.com', 'Haruno', 'Sakura', '28/03/1985', '', 'Konoha', 2);
insert into UTILISATEUR values('hitachi@live.fr', 'Uchiha', 'Hitachi', '09/06/1975', '', '', 0);
insert into UTILISATEUR values('martin@yahoo.fr', 'Vernin', 'Martin', '01/04/1995', 'France', 'Lyon', 3);
insert into UTILISATEUR values('jean@etu.nantes.com', 'Hermes', 'Jean', '25/12/1999', 'France', 'Nantes', 3);
insert into UTILISATEUR values('arnold@hotmail.com', '', 'Arnold', '//2000', 'France', 'Marseille', 1);
insert into UTILISATEUR values('willy@gmail.com', '', 'Willy', '//1996', 'France', 'Toulouse', 2);
insert into UTILISATEUR values('billy@gmail.com', 'The Kid', 'Billy', '14/07/1996', '', '', 11);
insert into UTILISATEUR values('lili@gmail.com', 'Bela', 'Liz', '11/05/1995', 'Italie', 'Rome', 1);

-- insertion SALON (NUM_SAL, NOM_SAL, PAYS_SAL, VILLE_SAL, DATE_DEBUT_SAL, DATE_FIN_SAL)
insert into SALON values(1, 'MASTER', 'France', '', '20/10/2017', '20/03/2018');
insert into SALON values(2, 'LICENCE', 'Angleterre', 'Londre', '', '');
insert into SALON values(3, 'DOCTORAT', 'Italie', '', '//', '20/03/2018');
insert into SALON values(4, 'LYCEE', 'Belgique', '', '//', '20/02/2018');
insert into SALON values(5, 'COLLEGE', 'France', '', '//', '');
insert into SALON values(6, 'AHHHH', 'France', '', '//', '02/02/2018');
insert into SALON values(7, 'HARD', 'France', '', '//', '10/12/2018');
insert into SALON values(8, 'EASE', 'Italie', '', '//', '');
insert into SALON values(9, 'AHOUI', 'Angleterre', '', '//', '');
insert into SALON values(10, 'YESNO', 'Angleterre', '', '//', '');

-- insertion AMITIE (MAILTO_USR1, MAILTO_USR2)
insert into AMITIE values('uzumaki@gmail.com', 'uchiha@hotmail.com');
insert into AMITIE values('uzumaki@gmail.com', 'haruno@yahoo.com');
insert into AMITIE values('martin@yahoo.fr', 'jean@etu.nantes.com');
insert into AMITIE values('lili@gmail.com', 'martin@yahoo.fr');
insert into AMITIE values('uchiha@hotmail.com', 'haruno@yahoo.com');
insert into AMITIE values('arnold@hotmail.com', 'willy@gmail.com');
insert into AMITIE values('jean@etu.nantes.com', 'billy@gmail.com');
insert into AMITIE values('billy@gmail.com', 'willy@gmail.com');
insert into AMITIE values('billy@gmail.com', 'jean@etu.nantes.com');
insert into AMITIE values('billy@gmail.com', 'martin@yahoo.fr');