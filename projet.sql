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
SQL> CREATE TABLESPACE TS_DATA_USER
  2  DATAFILE 'C:\APP\GB\ORADATA\PROJETJGM\TS_DATA_USER.dbf'
  3  SIZE 10M
  4  EXTENT MANAGEMENT LOCAL AUTOALLOCATE
  5  SEGMENT SPACE MANAGEMENT AUTO;
/*Tablespace crÚÚ.*/
--------  Un ou plusieurs tablespaces pour stocker les données d’indexes
-- REPONSE _____________________________________________________________________________--
------------- TableSpaces pour stocker les données d'index:
SQL> CREATE TABLESPACE TS_INDEX_DATA
  2  DATAFILE 'C:\APP\GB\ORADATA\PROJETJGM\TS_INDEX_DATA.dbf'
  3  SIZE 10M
  4  EXTENT MANAGEMENT LOCAL AUTOALLOCATE
  5  SEGMENT SPACE MANAGEMENT AUTO;
/*Tablespace crÚÚ.*/

--------  Un tablespace pour stocker les segments temporaires.
-- REPONSE _____________________________________________________________________________--
------------- TableSpaces pour stocker les données d'index:
SQL> CREATE TEMPORARY TABLESPACE TS_SEG_TEMP
  2  TEMPFILE 'C:\APP\GB\ORADATA\PROJETJGM\TS_SEG_TEMP.dbf'
  3  SIZE 10M;
/*Tablespace crÚÚ.*/
/*
SQL> col tablespace_name format A20
SQL> col file_name format A70
SQL> SET linesize 200
SQL> SELECT tablespace_name, file_name
  2  FROM dba_data_files;

TABLESPACE_NAME      FILE_NAME
-------------------- ----------------------------------------------------------------------
USERS                C:\APP\GB\ORADATA\PROJETJGM\USERS01.DBF
UNDOTBS1             C:\APP\GB\ORADATA\PROJETJGM\UNDOTBS01.DBF
SYSAUX               C:\APP\GB\ORADATA\PROJETJGM\SYSAUX01.DBF
SYSTEM               C:\APP\GB\ORADATA\PROJETJGM\SYSTEM01.DBF
TS_DATA_USER         C:\APP\GB\ORADATA\PROJETJGM\TS_DATA_USER.DBF
TS_INDEX_DATA        C:\APP\GB\ORADATA\PROJETJGM\TS_INDEX_DATA.DBF

6 ligne(s) sÚlectionnÚe(s).

SQL> SELECT TABLESPACE_NAME, BLOCK_SIZE, STATUS, CONTENTS, EXTENT_MANAGEMENT, ALLOCATION_TYPE, SEGMENT_SPACE_MANAGEMENT
  2  FROM DBA_TABLESPACES
  3  ORDER BY TABLESPACE_NAME;

TABLESPACE_NAME      BLOCK_SIZE STATUS    CONTENTS  EXTENT_MAN ALLOCATIO SEGMEN
-------------------- ---------- --------- --------- ---------- --------- ------
SYSAUX                     8192 ONLINE    PERMANENT LOCAL      SYSTEM   AUTO
SYSTEM                     8192 ONLINE    PERMANENT LOCAL      SYSTEM   MANUAL
TEMP                       8192 ONLINE    TEMPORARY LOCAL      UNIFORM  MANUAL
TS_DATA_USER               8192 ONLINE    PERMANENT LOCAL      SYSTEM   AUTO
TS_INDEX_DATA              8192 ONLINE    PERMANENT LOCAL      SYSTEM   AUTO
TS_SEG_TEMP                8192 ONLINE    TEMPORARY LOCAL      UNIFORM  MANUAL
UNDOTBS1                   8192 ONLINE    UNDO      LOCAL      SYSTEM   MANUAL
USERS                      8192 ONLINE    PERMANENT LOCAL      SYSTEM   AUTO

8 ligne(s) sÚlectionnÚe(s).
*/
/*
SQL> DROP TABLESPACE TEMP INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE TEMP INCLUDING CONTENTS AND DATAFILES
*
ERREUR Ó la ligne 1 :
ORA-12906: impossible de supprimer le tablespace temporaire par dÚfaut
*/
SQL> ALTER DATABASE DEFAULT TEMPORARY TABLESPACE TS_SEG_TEMP;

/*Base de donnÚes modifiÚe.*/



-------- Note: Tous vos tablespaces seront gérés localement. Ils seront en mode AUTOALLOCATE
-------- ou UNIFORM SIZE. Vous devez expliquer l’intérêt et les bénéfices de vos choix.

--______________________________________________________________________________________--

-- SALON (NUM_SAL, NOM_SAL, PAYS_SAL, VILLE_SAL, DATE_DEBUT_SAL, DATE_FIN_SAL)
create table SALON (
	NUM_SAL 		int not null using index tablespace TS_INDEX_DATA storage(
		initial 
	),
	NOM_SAL 		varchar(100),
	PAYS_SAL 		varchar(255),
	VILLE_SAL 		varchar(255),
	DATE_DEBUT_SAL 	date,
	DATE_FIN_SAL	date,
	primary key	(NUM_SAL)
)
tablespace TS_SEG_TEMP
storage(
	initial ...,
	next ...,
	minextents 1
);

-- UTILISATEUR (MAILTO_USR, NOM_USR, PRENOM_USR, DATE_NAISS_USR, PAYS_USR, VILLE_USR, NB_AMIS_USR)
create table UTILISATEUR (
	MAILTO_USR 		varchar(255) not null,
	NOM_USR 		varchar(100),
	PRENOM_USR 		varchar(100),
	DATE_NAISS_USR 	varchar(255) not null,
	PAYS_USR 		varchar(255),
	VILLE_USR		varchar(255),
	NB_AMIS_USR 	int,
	primary key	(MAILTO_USR)
);
-- AMITIE (MAILTO_USR1, MAILTO_USR2)
create table AMITIE (
	MAILTO_USR1 	varchar(255) not null,
	MAILTO_USR2		varchar(255) not null,
	primary key	(MAILTO_USR1, MAILTO_USR2),
);
-- JEU (ID_JEU, NOM_JEU, ANNEE_SORTIE_JEU)
create table JEU (
	ID_JEU 				int not null,
	NOM_JEU				varchar(255),
	ANNEE_SORTIE_JEU	date,
	primary key	(MAILTO_USR1, MAILTO_USR2),
);
-- FABRICANT (ID_FAB, NOM_FAB)
create table FABRICANT (
	ID_FAB		 	int not null,
	NOM_FAB			varchar(255),
	primary key	(MAILTO_USR1, MAILTO_USR2),
);
-- SERVEUR (ID_SER, NOM_SER)
create table SERVEUR (
	ID_SER		 	int not null,
	NOM_SER			varchar(255),
);
-- LOCALITE (ID_LOC, VILLE_LOC)
create table LOCALITE (
	ID_LOC			int not null,
	VILLE_LOC		varchar(255) unique
);




alter table SALON add constraint fk_heberge_par foreign key (ID_SER)
references SERVEUR(ID_SER)

alter table SALON add constraint fk_heberge_par foreign key (ID_SER)
references SERVEUR(ID_SER)


















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
-------- reTODO : Demande de l'aide (Chap4 - Page 20)

SET SERVEROUTPUT ON
DECLARE
v_used_bytes NUMBER(10);
v_allocated_Bytes NUMBER(10);
v_type_salon sys.create_table_cost_columns;
v_type_utilisateur sys.create_table_cost_columns;
v_type_amitie sys.create_table_cost_columns;
v_type_jeu sys.create_table_cost_columns;
v_type_fabricant sys.create_table_cost_columns;
v_type_serveur sys.create_table_cost_columns;
v_type_localite sys.create_table_cost_columns;

BEGIN
-- SALON (NUM_SAL, NOM_SAL, PAYS_SAL, VILLE_SAL, DATE_DEBUT_SAL, DATE_FIN_SAL)
v_type_salon := sys.create_table_cost_columns (
	sys.create_table_cost_colinfo('int', 3),
	sys.create_table_cost_colinfo('varchar2', 100),
	sys.create_table_cost_colinfo('varchar2', 255),
	sys.create_table_cost_colinfo('varchar2', 255),
	sys.create_table_cost_colinfo('date', null),
	sys.create_table_cost_colinfo('date', null));
DBMS_SPACE.CREATE_TABLE_COST(
	-- TODO pourquoi ne pas utiliser TS_SEG_TEMP au lieu de TS_DATA_USER
	'TS_DATA_USER',
	v_type_salon,
	...ROW_COUNT...,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Salon: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);

-- UTILISATEUR (MAILTO_USR, NOM_USR, PRENOM_USR, DATE_NAISS_USR, PAYS_USR, VILLE_USR, NB_AMIS_USR)
v_type_utilisateur := sys.create_table_cost_columns (
	sys.create_table_cost_colinfo('varchar2', 255),
	sys.create_table_cost_colinfo('varchar2', 100),
	sys.create_table_cost_colinfo('varchar2', 100),
	sys.create_table_cost_colinfo('date', null),
	sys.create_table_cost_colinfo('varchar2', 255),
	sys.create_table_cost_colinfo('varchar2', 255),
	sys.create_table_cost_colinfo('int', 2));
DBMS_SPACE.CREATE_TABLE_COST(
	'TS_DATA_USER',
	v_type_utilisateur,
	...ROW_COUNT...,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Utilisateur: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);

-- AMITIE (MAILTO_USR1, MAILTO_USR2)
v_type_amitie := sys.create_table_cost_columns (
	sys.create_table_cost_colinfo('varchar2', 255),
	sys.create_table_cost_colinfo('varchar2', 255));
DBMS_SPACE.CREATE_TABLE_COST(
	'TS_DATA_USER',
	v_type_amitie,
	...ROW_COUNT...,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Amitie: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);

-- JEU (ID_JEU, NOM_JEU, ANNEE_SORTIE_JEU)
v_type_jeu := sys.create_table_cost_columns (
	sys.create_table_cost_colinfo('varchar2', 255),
	sys.create_table_cost_colinfo('varchar2', 255));
DBMS_SPACE.CREATE_TABLE_COST(
	'TS_DATA_USER',
	v_type_jeu,
	...ROW_COUNT...,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Jeu: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);

-- FABRICANT (ID_FAB, NOM_FAB)
v_type_fabricant := sys.create_table_cost_columns (
	sys.create_table_cost_colinfo('int', 2),
	sys.create_table_cost_colinfo('varchar2', 255));
DBMS_SPACE.CREATE_TABLE_COST(
	'TS_DATA_USER',
	v_type_jeu,
	...ROW_COUNT...,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Fabricant: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);

-- SERVEUR (ID_SER, NOM_SER)
v_type_serveur := sys.create_table_cost_columns (
	sys.create_table_cost_colinfo('int', 2),
	sys.create_table_cost_colinfo('varchar2', 255));
DBMS_SPACE.CREATE_TABLE_COST(
	'TS_DATA_USER',
	v_type_serveur,
	...ROW_COUNT...,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Fabricant: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);

-- LOCALITE (ID_LOC, VILLE_LOC)
v_type_localite := sys.create_table_cost_columns (
	sys.create_table_cost_colinfo('int', 2),
	sys.create_table_cost_colinfo('varchar2', 255));
DBMS_SPACE.CREATE_TABLE_COST(
	'TS_DATA_USER',
	v_type_localite,
	...ROW_COUNT...,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Fabricant: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);
END



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
insert into UTILISATEUR values('arnold@hotmail.com', 'Drummond', 'Arnold', '03/12/2000', 'France', 'Marseille', 1);
insert into UTILISATEUR values('willy@gmail.com', 'Drummond', 'Willy', '15/05/1996', 'France', 'Toulouse', 2);
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



-- 3. Étape d'Administration (2 jours)
---- 3.1 Sqlloader (voir le chap. 7 du cours ADB1)
-------- Ecrire un script (fichier de contrôle SQLLOADER) qui permet de charger les lignes contenues
-------- dans un fichier CSV (ligne à construire dans EXCEL) vers une ou plusieurs de vos tables.
-------- Les données sont à préparer auparavant.
-- REPONSE _____________________________________________________________________________--
LOAD DATA
INFILE '....csv'
INTO TABLE UTILISATEUR
FIELDS TERMINATED BY ','
(
MAILTO_USR,
NOM_USR,
PRENOM_USR,
DATE_NAISS_USR,
PAYS_USR,
VILLE_USR,
NB_AMIS_USR
)

---- 3.2 Divers requêtes
------ 1) Ecrire une requête SQL qui permet de visualiser l’ensemble des fichiers qui composent votre base
-- REPONSE _____________________________________________________________________________--
select DBA_DATA_FILES.TABLESPACE_NAME, DBA_DATA_FILES.FILE_NAME, DBA_TEMP_FILES.TABLESPACE_NAME, DBA_TEMP_FILES.FILE_NAME,
		v$logfile.GROUP#, v$logfile.MEMBER,
		v$controlfile.NAME, v$controlfile.STATUS
from DBA_DATA_FILES, DBA_TEMP_FILES, v$logfile, v$controlfile
order DBA_TEMP_FILES.TABLESPACE_NAME,v$logfile.GROUP#, v$logfile.MEMBER, v$controlfile.NAME;


------ 2) Ecrire une requête SQL qui permet de lister en une requête l’ensembles des tablespaces avec
------    leur fichiers. La taille de chaque fichier doit apparaître, le volume total de l’espace occupé
------    par fichier ainsi que le volume total de l’espace libre par fichier
-- REPONSE _____________________________________________________________________________--

select a.TABLESPACE_NAME, a.FILE_NAME, a.BYTES, b.free_bytes, nvl(a.bytes, 0)-nvl(b.free_bytes,0) " espace occupe"
from (
	select TABLESPACE_NAME, bytes, FILE_NAME
	from DBA_DATA_FILES
) a, (
	select TABLESPACE_NAME, BYTES free_bytes
	from DBA_FREE_SPACE
) b
where a.TABLESPACE_NAME = b.TABLESPACE_NAME;

------ 3) Ecrire une requête SQL qui permet de lister les segments et leurs extensions
--------- de chacun des segments (tables ou indexes) de votre utilisateur
select segment_name, extents, segment_type from user dba_segments where owner='mopolo';

------ 4) Ecrire une requête qui permet pour chacun de vos segments de donner le nombre
--------- total de blocs du segment, le nombre de blocs utilisés et le nombre de blocs libres
--- TODO

------ 5) Ecrire une requête SQL qui permet de compacter et réduire un segment
alter table UTILISATEUR enable row movement;
alter table UTILISATEUR shrink space;

------ 6) Ecrire une requête qui permet d’afficher l’ensemble des utilisateurs de votre base et leurs droits
select username, privilege
from
	(dba_sys_privs)a,
	(select username
		from dba_users)b
where a.grantee = b.username;

------ 7) Proposer trois requêtes libres au choix de recherche d’objets dans le dictionnaire Oracle
-- TODO Trop EASY ;)

-- 3.3 Mise en place d'une stratégie de sauvegarde et restauration (voir le chap. 6 du cours ADB1)

