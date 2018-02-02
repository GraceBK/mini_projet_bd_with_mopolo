/*
Membres de l'equipe:
	Grace Boukou
	Julien Boivert
	Mohamed Kadri Mounkaila
*/

-- 1.2 Schéma logique de données
-- Définir ou générer un schéma logique de la base de données avec au moins 7 tables:
-- 	o Prendre en compte dans cette phase les règles de gestion de type contraintes
-- 	  d'intégrités (de domaine : check/not null, d’entité : primary key/unique key, de référence : foreign key)

-- Création de la Table SALON

create table Salon(
	numS number(4) NOT NULL, 
	nomS VARCHAR2(100),
	paysS VARCHAR2(255),
	villeS VARCHAR2(255),
	date_DebutS DATE not null,
	date_FinS DATE,
	PRIMARY KEY(numS) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_SEGMENTTEMP
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie
-- Table SALON créé(e).


-- Création de la Table UTILISATEUR

create table Utilisateur(
	mailtoUsr VARCHAR(255) NOT NULL,
	nomUsr VARCHAR(100),
	prenomUsr VARCHAR(100),
	date_naissanceUsr DATE NOT NULL,
	paysUsr VARCHAR(255),
	villeUsr VARCHAR(255),
	nb_Amis int,
	PRIMARY KEY(mailtoUsr) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATA_USER
STORAGE(INITIAL 4096K NEXT 4096K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie
-- Table UTILISATEUR créé(e).


-- Création de la Table AMITIE

create table AMITIE(
	mailtoUsr1 VARCHAR(255) not null,
	mailtoUsr2 VARCHAR(255) NOT NULL,
	PRIMARY KEY(mailtoUsr1, mailtoUsr2) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1),
  FOREIGN KEY (mailtoUsr2) REFERENCES Utilisateur(mailtoUsr))
tablespace TS_DATA_USER
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie
-- Table AMITIE créé(e).


-- Création de la Table JEU

create table Jeu(
	IdJeu int NOT NULL,
	nomJeu VARCHAR(255),
	annee_sortie DATE,
  PRIMARY KEY (IdJeu) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATAFABNJEU
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie
-- Table JEU créé(e).


-- Création de la Table FABRICANT

create table Fabricant(
	IdF int NOT NULL,
	nomF VARCHAR(255),
  PRIMARY KEY (IdF) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATAFABNJEU
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie
-- Table FABRICANT créé(e).


-- Création de la Table SERVEUR

create table Serveur(
	IdServ int NOT NULL,
	nomServ VARCHAR(255),
  PRIMARY KEY (IdServ)  USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATASERVNLOC
STORAGE(INITIAL 1024K NEXT 512K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie
-- Table SERVEUR créé(e).


-- Création de la Table LOCALITE

create table Localite(
	IdLoc int NOT NULL,
	ville VARCHAR(255) UNIQUE,
  PRIMARY KEY (IdLoc) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_dataServNLoc
STORAGE(INITIAL 1024K NEXT 1024K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie
-- Table LOCALITE créé(e).


-- ON VA MAINTENANT AJOUTER LES CONTRAINTES

ALTER TABLE SALON ADD IdServ int;
------> Sortie
-- Table SALON modifié(e).
ALTER TABLE SALON ADD CONSTRAINT Heberge_Par FOREIGN KEY (IdServ) REFERENCES Serveur(IdServ);
------> Sortie
-- Table SALON modifié(e).
ALTER TABLE SALON ADD IdJeu int;
------> Sortie
-- Table SALON modifié(e).
ALTER TABLE SALON ADD CONSTRAINT Propose FOREIGN KEY (IdJeu) REFERENCES Jeu(IdJeu);
------> Sortie
-- Table SALON modifié(e).
ALTER TABLE UTILISATEUR ADD numS number(4);
------> Sortie
-- Table UTILISATEUR modifié(e).
ALTER TABLE UTILISATEUR ADD CONSTRAINT ParticipeA FOREIGN KEY (numS) REFERENCES Salon(numS);
------> Sortie
-- Table UTILISATEUR modifié(e).
ALTER TABLE JEU ADD IdF int;
------> Sortie
-- Table JEU modifié(e).
ALTER TABLE JEU ADD CONSTRAINT Fabrique_Par FOREIGN KEY (IdF) REFERENCES Fabricant(IdF);
------> Sortie
-- Table JEU modifié(e).
ALTER TABLE SERVEUR ADD IdLoc int;
------> Sortie
-- Table SERVEUR modifié(e).
ALTER TABLE SERVEUR ADD CONSTRAINT Se_trouve FOREIGN KEY (IdLoc) REFERENCES Localite(IdLoc);
------> Sortie
-- Table SERVEUR modifié(e).


-- 	o Définir au moins un trigger pour assurer l’intégrité des données ne pouvant être
--    prise en charge par les contraintes d’intégrités du modèle relationnel

-- On va ajouter un trigger qui marche comme suit:
-- Lorsqu'on supprime une cle Primaire dans la table SALON, la clé étrangère correspondante
-- dans la table UTILISATEUR est mise à NULL

CREATE TRIGGER MAJCLESALON
AFTER DELETE OR UPDATE OF numS ON Salon
FOR EACH ROW
BEGIN
IF UPDATING AND :OLD.numS != :NEW.numS
OR DELETING THEN
UPDATE UTILISATEUR SET UTILISATEUR.numS = NULL
WHERE UTILISATEUR.numS = :OLD.numS ;
END IF ;
END;
------> Sortie
-- Elément Trigger MAJCLESALON compilé


-- On va ajouter un trigger qui marche comme suit:
-- Lorsque dans la table AMITIE un utilisateur a un nouvel ami,
-- le nombre total de ses amis est affecté dans la table UTILISATEUR

create trigger TR_NOUVEL_AMI 
after insert on AMITIE
begin
	update utilisateur
	set nb_Amis = nb_Amis + 1;
end;
------> Sortie
-- Elément Trigger TR_NOUVEL_AMI compilé

















-- 2. Organisation physique de la base sous Oracle 11g (2 jours)
--    En partant du schéma logique définit précédemment, vous procédérez dans cette étape à
--    l’organisation physique de la base de données.
--        Vous devez donc assurerer les tâches suivantes :

--    o Créer les tablespaces suivants et expliquer leur intérêt:

--  Un ou plusieurs tabespaces pour stocker les données des tables.
-- On crée un tablespace pour les données de la table Utilisateur
CREATE TABLESPACE TS_DATA_USER DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_DATA_USER.DBF'
size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace crÚÚ.

-- On crée un tablespace pour les données de la table Fabricant et la table Jeux
CREATE TABLESPACE TS_DATAFABNJEU DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_DATAFABNJEU.DBF'
size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace crÚÚ.

-- On crée un tablespace pour les données de la table Serveur et la table Localité
CREATE TABLESPACE TS_DATASERVNLOC DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_DATASERVNLOC.DBF'
size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace crÚÚ.




--  Un ou plusieurs tablespaces pour stocker les données d’indexes
--    Nous avons décidé de créer un seul tablespace pour stocker tous les indexes 
CREATE TABLESPACE TS_INDEXES DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_INDEXES.DBF'
size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

-- Tablespace crÚÚ.




--  Un tablespace pour stocker les segments temporaires.
--    On va y stocker la table SALON car un SALON est temporaire et n'existe que s'il y a
--    des joueurs qui y sont inscrits
CREATE TEMPORARY TABLESPACE TS_SEGMENTTEMP TEMPFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_SEGMENTTEMP.DBF'
size 10m;

-- Tablespace crÚÚ.
/*
### Autoallocate ne peut pas etre utilisé pour temporaire(uniforme par default)
    Unif: suivi plus simple de l'allocation des extents + minimise fragmentation + meilleure perf (debat)
    AutoAlloc = plus en plus grand : optimise espace (pas d'offset vide comme unif) - maximise la fragmentation.
###

Note : Tous vos tablespaces seront gérés localement. Ils seront en mode AUTOALLOCATE ou UNIFORM SIZE.
		Vous devez expliquer l’intérêt et les bénéfices de vos choix.
*/

-- o Créer un utilisateur de votre choix qui sera propriétaire de votre application. Les
--   segments temporaires doivent être localisés dans le tablespace approprié créé
--   précédement. Vous devez lui donner les droits appropriés.

CREATE USER TheBoss IDENTIFIED BY GraceJulienMohamed
DEFAULT tablespace USERS
TEMPORARY tablespace TS_segmentTemp
QUOTA unlimited on USERS 
QUOTA unlimited on TS_DATA_USER 
QUOTA unlimited on TS_DATAFABNJEU
QUOTA unlimited on TS_DATASERVNLOC
QUOTA unlimited on TS_INDEXES;
------> Sortie
-- User THEBOSS créé(e).

grant create session to THEBOSS; 		--Pour qu'il puisse se connecter
------> Sortie
-- Succès de l'élément Grant.


-- o Créer le schéma de données en séparant les données des tables et les index
--    Vous dimensionnerez de façon pertinente les segments. Pour cela vous devez
--      utiliser le package DBMS_SPACE pour estimer la volumétrie de vos tables et
--      de vos indexes afin de trouver le volume de données nécessaire dès la création 
--      de ces segments. Il est important d’estimer le nombre total de lignes de chacune
--      de vos tables

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
	'TS_SEGMENTTEMP',
	v_type_salon,
	1000,
  5,
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
	1000,
  5,
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
	1000,
  5,
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
	'TS_DATAFABNJEU',
	v_type_jeu,
	1000,
  5,
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
	'TS_DATAFABNJEU',
	v_type_jeu,
	1000,
  5,
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
	'TS_DATASERVNLOC',
	v_type_serveur,
	1000,
  5,
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
	'TS_dataServNLoc',
	v_type_localite,
	1000,
  5,
	v_used_bytes,
	v_allocated_Bytes
);
DBMS_OUTPUT.PUT_LINE(
	'Fabricant: ' || TO_CHAR(v_used_bytes) || ' Allocated Bytes: ' || TO_CHAR(v_allocated_Bytes)
);
END;
/

/*
Salon: 376832 Allocated Bytes: 393216
Utilisateur: 548864 Allocated Bytes: 589824
Amitie: 286720 Allocated Bytes: 327680
Jeu: 286720 Allocated Bytes: 327680
Fabricant: 286720 Allocated Bytes: 327680
Fabricant: 155648 Allocated Bytes: 196608
Fabricant: 155648 Allocated Bytes: 196608


Procédure PL/SQL terminée.
*/

--    Insérer pour l’instant en moyenne une dizaine de lignes de test dans chacune des
-- tables.

-- insertion FABRICANT (ID_FAB, NOM_FAB)
insert into FABRICANT values(1, 'Sega');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(2, 'Sony');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(3, 'Rockstar Games');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(4, 'Microsoft');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(5, 'Koei');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(6, 'Konami');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(7, 'Lego Media');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(8, 'LucasArts');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(9, 'Ubisoft');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(10, 'Vivendi Games');
------> Sortie 			1 ligne inséré.
insert into FABRICANT values(55, 'EA SPORTS');
------> Sortie 			1 ligne inséré.
/*
select * from FABRICANT;

1	Sega
2	Sony
3	Rockstar Games
4	Microsoft
5	Koei
6	Konami
7	Lego Media
8	LucasArts
9	Ubisoft
10	Vivendi Games
55  EA SPORTS
*/
-- insertion LOCALITE (ID_LOC, VILLE_LOC)
insert into LOCALITE values(1, 'Paris');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(2, 'Marseille');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(3, 'Lyon');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(4, 'Toulouse');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(5, 'Nice');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(6, 'Nantes');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(7, 'Montpellier');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(8, 'Strasbourg');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(9, 'Bordeaux');
------> Sortie 			1 ligne inséré.
insert into LOCALITE values(10, 'Lille');
------> Sortie 			1 ligne inséré.
/*
select * from LOCALITE;

1	Paris
2	Marseille
3	Lyon
4	Toulouse
5	Nice
6	Nantes
7	Montpellier
8	Strasbourg
9	Bordeaux
10	Lille
*/
-- insertion SERVEUR (ID_SER, NOM_SER, ID_LOC)
insert into SERVEUR values(1, 'LINUX17', 1);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(2, 'MAC10', 9);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(3, 'WIN10', 3);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(4, 'ACERACER', 6);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(5, 'FEELING2', 7);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(6, 'LWS', 8);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(7, 'LESLASCAR', 5);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(8, 'UNLIMIT', 5);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(9, 'SEGFAULT', 10);
------> Sortie 			1 ligne inséré.
insert into SERVEUR values(10, 'AAA', 6);
------> Sortie 			1 ligne inséré.
/*
select * from SERVEUR;

1	LINUX17		1
2	MAC10		9
3	WIN10		3
4	ACERACER	6
5	FEELING2	7
6	LWS			8
7	LESLASCAR	5
8	UNLIMIT		5
9	SEGFAULT	10
10	AAA			6
*/
-- insertion JEU (ID_JEU, NOM_JEU, ANNEE_SORTIE_JEU)
insert into JEU values(1, 'Watch Dogs 2', '15/11/2016', 9);-- Ubisoft
------> Sortie 			1 ligne inséré.
insert into JEU values(2, 'World of Warcraft', '02/11/2004', 10);-- Vivendi Games
------> Sortie 			1 ligne inséré.
insert into JEU values(3, 'Assassin s Creed', '13/11/2007', 9);-- Ubisoft
------> Sortie 			1 ligne inséré.
insert into JEU values(4, 'Probotector', '08/01/1988', 6);-- Konami
------> Sortie 			1 ligne inséré.
insert into JEU values(5, 'Samurai Warriors 4', '24/03/2014', 5);-- Koei
------> Sortie 			1 ligne inséré.
insert into JEU values(6, 'One Piece: Pirate Warriors', '1/03/2012', 5);-- Koei
------> Sortie 			1 ligne inséré.
insert into JEU values(7, 'Monkey Island', '15/06/2009', 8);-- LucasArts
------> Sortie 			1 ligne inséré.
insert into JEU values(8, 'Grand Theft Auto V', '17/11/13', 3);-- Rockstar Games
------> Sortie 			1 ligne inséré.
insert into JEU values(9, 'Lego Island', '26/11/1997', 7);-- Lego Media
------> Sortie 			1 ligne inséré.
insert into JEU values(10, 'Maze of Shadows', '24/03/2005', 7);-- Lego Media
------> Sortie 			1 ligne inséré.
insert into JEU values(11, 'FIFA 15', '29/09/2014', 55);-- EA SPORTS
------> Sortie 			1 ligne inséré.
insert into JEU values(12, 'FIFA 16', '29/09/2015', 55);-- EA SPORTS
------> Sortie 			1 ligne inséré.
insert into JEU values(13, 'FIFA 17', '29/09/2016', 55);-- EA SPORTS
------> Sortie 			1 ligne inséré.
insert into JEU values(14, 'FIFA 18', '29/09/2017', 55);-- EA SPORTS
------> Sortie 			1 ligne inséré.
/*
select * from JEU;

1	Watch Dogs 2				15/11/16	9
2	World of Warcraft			02/11/04	10
3	Assassin s Creed			13/11/07	9
4	Probotector					08/01/88	6
5	Samurai Warriors 4			24/03/14	5
6	One Piece: Pirate Warriors	01/03/12	5
7	Monkey Island				15/06/09	8
8	Grand Theft Auto V			17/11/13	3
9	Lego Island					26/11/97	7
10	Maze of Shadows				24/03/05	7
11	FIFA 15						29/09/14	55
12	FIFA 16						29/09/15	55
13	FIFA 17						29/09/16	55
14	FIFA 18						29/09/17	55
*/
-- insertion SALON (NUM_SAL, NOM_SAL, PAYS_SAL, VILLE_SAL, DATE_DEBUT_SAL, DATE_FIN_SAL, IDSERV, IDJEU)

-- ATTENTION : A ce niveu ci, on s'est rendu compte que ce n'était pas une bonne idée d'avoir mis
--             la table SALON dans un TS temporaire. On l'a alors déplacée
ALTER TABLE SALON MOVE TABLESPACE TS_DATA_USER;

insert into SALON values(1, 'AWESOME GAMES DONE QUICK', 'France', 'Nice', '20/10/2017', '20/03/2018', 1, 1);
------> Sortie 			1 ligne inséré.
insert into SALON values(2, 'DOJO ESPORT', 'Londre', 'Chelsea', '20/10/1999', '', 2, 9);
------> Sortie 			1 ligne inséré.
insert into SALON values(3, 'GLOBAL GAME JAM 2018', 'Italie', '', '20/03/2018', '', 3, 5);
------> Sortie 			1 ligne inséré.
insert into SALON values(4, 'SALON DES JV', 'Belgique', '', '31/01/2018', '20/02/2018', 7, 7);
------> Sortie 			1 ligne inséré.
insert into SALON values(5, 'ORANGE ELIGUE 1', 'France', '', '31/01/2018', '', 1, 13);
------> Sortie 			1 ligne inséré.
insert into SALON values(6, 'FIWC', 'France', '', '31/01/2018', '02/02/2018', 2, 14);
------> Sortie 			1 ligne inséré.
insert into SALON values(7, 'KONOHAMARU KONTEST', 'Japon', '', '31/01/2018', '10/12/2018', 9, 6);
------> Sortie 			1 ligne inséré.
insert into SALON values(8, 'MR EAZY', 'Italie', '', '31/01/2018', '', 4, 10);
------> Sortie 			1 ligne inséré.
insert into SALON values(9, 'AHOUI', 'Angleterre', '', '31/01/2018', '', 3, 4);
------> Sortie 			1 ligne inséré.
insert into SALON values(10, 'YESNO', 'Angleterre', '', '31/01/2018', '', 8, 5);
------> Sortie 			1 ligne inséré.
/*
select * from SALON;

1	AWESOME GAMES DONE QUICK	France	 	Nice		20/10/17	20/03/18	1	1
2	DOJO ESPORT					Londre	 	Chelsea		20/10/99	(null)		2	9
3	GLOBAL GAME JAM 2018		Italie	 	(null)		20/03/18	(null)		3	5
4	SALON DES JV				Belgique 	(null)		31/01/18	20/02/18	7	7
5	ORANGE ELIGUE 1				France	 	(null)		31/01/18	(null)		1	13
6	FIWC						France	 	(null)		31/01/18	02/02/18	2	14
7	KONOHAMARU KONTEST			Japon	 	(null)		31/01/18	10/12/18	9	6
8	MR EAZY						Italie	 	(null)		31/01/18	(null)		4	10
9	AHOUI						Angleterre	(null)		31/01/18	(null)		3	4
10	YESNO						Angleterre	(null)		31/01/18	(null)		8	5
*/
-- insertion UTILISATEUR (MAILTO_USR, NOM_USR, PRENOM_USR, DATE_NAISS_USR, PAYS_USR, VILLE_USR, NB_AMIS_USR, NUMS)
insert into UTILISATEUR values('uzumaki@gmail.com', 'Uzumaki', 'Naruto', '10/10/1985', 'Japon', 'Konoha', 2, NULL);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('uchiha@hotmail.com', 'Uchiha', 'Sasuke', '23/07/1985', '', 'Konoha', 2, 1);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('haruno@yahoo.com', 'Haruno', 'Sakura', '28/03/1985', '', 'Konoha', 2, 5);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('hitachi@live.fr', 'Uchiha', 'Hitachi', '09/06/1975', '', '', 0, 6);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('martin@yahoo.fr', 'Vernin', 'Martin', '01/04/1995', 'France', 'Lyon', 3, 3);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('jean@etu.nantes.com', 'Hermes', 'Jean', '25/12/1999', 'France', 'Nantes', 3, 2);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('arnold@hotmail.com', 'Drummond', 'Arnold', '03/12/2000', 'France', 'Marseille', 1, 2);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('willy@gmail.com', 'Drummond', 'Willy', '15/05/1996', 'France', 'Toulouse', 2, 2);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('billy@gmail.com', 'The Kid', 'Billy', '14/07/1996', '', '', 11, 4);
------> Sortie 			1 ligne inséré.
insert into UTILISATEUR values('lili@gmail.com', 'Bela', 'Liz', '11/05/1995', 'Italie', 'Rome', 1, 3);
------> Sortie 			1 ligne inséré.
/*
select * from UTILISATEUR;

uzumaki@gmail.com	Uzumaki		Naruto	10/10/85	Japon	Konoha		13	(null)
uchiha@hotmail.com	Uchiha		Sasuke	23/07/85	(null)	Konoha		13	1
haruno@yahoo.com	Haruno		Sakura	28/03/85	(null)	Konoha		13	5
hitachi@live.fr		Uchiha		Hitachi	09/06/75	(null)	(null)		11	6
martin@yahoo.fr		Vernin		Martin	01/04/95	France	Lyon		14	3
jean@etu.nantes.com	Hermes		Jean	25/12/99	France	Nantes		14	2
arnold@hotmail.com	Drummond	Arnold	03/12/00	France	Marseille	12	2
willy@gmail.com		Drummond	Willy	15/05/96	France	Toulouse	13	2
billy@gmail.com		The Kid		Billy	14/07/96	(null)	(null)		22	4
lili@gmail.com		Bela		Liz		11/05/95	Italie	Rome		12	3
*/
-- insertion AMITIE (MAILTO_USR1, MAILTO_USR2)
insert into AMITIE values('uzumaki@gmail.com', 'uchiha@hotmail.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('uzumaki@gmail.com', 'haruno@yahoo.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('martin@yahoo.fr', 'jean@etu.nantes.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('lili@gmail.com', 'martin@yahoo.fr');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('uchiha@hotmail.com', 'haruno@yahoo.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('arnold@hotmail.com', 'willy@gmail.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('jean@etu.nantes.com', 'billy@gmail.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('billy@gmail.com', 'willy@gmail.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('billy@gmail.com', 'jean@etu.nantes.com');
------> Sortie 			1 ligne inséré.
insert into AMITIE values('billy@gmail.com', 'martin@yahoo.fr');
------> Sortie 			1 ligne inséré.
/*
select * from AMITIE;

arnold@hotmail.com	willy@gmail.com
billy@gmail.com		jean@etu.nantes.com
billy@gmail.com		martin@yahoo.fr
billy@gmail.com		willy@gmail.com
jean@etu.nantes.com	billy@gmail.com
lili@gmail.com		martin@yahoo.fr
martin@yahoo.fr		jean@etu.nantes.com
uchiha@hotmail.com	haruno@yahoo.com
uzumaki@gmail.com	haruno@yahoo.com
uzumaki@gmail.com	uchiha@hotmail.com
*/


-- 3. Étape d'Administration (2 jours)
-- 	  3.1 Sqlloader (voir le chap. 7 du cours ADB1)
-- 		  Ecrire un script (fichier de contrôle SQLLOADER) qui permet de charger les lignes contenues
-- 		  dans un fichier CSV (ligne à construire dans EXCEL) vers une ou plusieurs de vos tables. Les
-- 		  données sont à préparer auparavant.
-- <TODO>

PS C:\> sqlldr.exe toto/azerty Control=scriptSQLLoader.ctl log=resultatInjection.log

SQL*Loader: Release 11.2.0.1.0 - Production on Mar. Janv. 30 16:58:40 2018

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.

Point de validation (COMMIT) atteint - nombre d'enregis. logiques 8


-- 3.2 Divers requêtes
-- 	   1) Ecrire une requête SQL qui permet de visualiser l’ensemble des fichiers qui
--        composent votre base

-- Pour afficher les informations sur les fichiers de données de la base
SELECT file_name, file_id, tablespace_name FROM DBA_DATA_FILES order by file_id;
/*
C:\APP\MBDS2\ORADATA\DBCOURS\SYSTEM01.DBF	1	SYSTEM
C:\APP\MBDS2\ORADATA\DBCOURS\SYSAUX01.DBF	2	SYSAUX
C:\APP\MBDS2\ORADATA\DBCOURS\UNDOTBS01.DBF	3	UNDOTBS1
C:\APP\MBDS2\ORADATA\DBCOURS\USERS01.DBF	4	USERS
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS.DBF	5	TS_TAB_IMMO_AUTO
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TSIND.IBF	6	TS_IND_IMMO_AUTO
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\DATASPACE.DBF	7	DATA_SPACE
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\INDEXSPACE.DBF	8	INDEX_SPACE
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\SEGMENTTMPTSPACE.DBF	9	SEGMENTTMPTSPACE
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\RMAN_TS_DATA.DBF	10	RMAN_TS_DATA
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TLDONNEE.DBF	11	TLDONNEE
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TLINDEX.DBF	12	TLINDEX
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TLTEMP.DBF	13	TLTEMP
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\SEGMENTSPACE.DBF	14	SEGMENT_SPACE
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\SEGMENTSTMPTSPACE.DBF	15	SEGMENTSPACE
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\INDEXSPACE2.DBF	16	USERS
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\INDEXSPACEBIS.DBF	17	INDEX_SPACE
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\NEW_SPORT_SAMPLE_AUTO.DBF	18	TS_SPORT_SAMPLE_AUTO
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\NEW_SPORT_COMPLEX_AUTO.DBF	19	TS_SPORT_COMPLEX_AUTO
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\NEW_SEG_TMP_AUTO.DBF	20	TS_SEG_TMP_AUTO
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_DATASERVNLOC.DBF	21	TS_DATASERVNLOC
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_DATA_USER.DBF	22	TS_DATA_USER
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_DATAFABNJEU.DBF	23	TS_DATAFABNJEU
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_INDEXES.DBF	24	TS_INDEXES
*/
-- Pour afficher les informations sur les fichiers temporaires de la base
SELECT file_name, file_id, tablespace_name FROM DBA_TEMP_FILES order by file_id;
/*
C:\APP\MBDS2\ORADATA\DBCOURS\TEMP01.DBF	1	TEMP
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TSIMMOTMP.DBF	2	TS_IMMO_TMP
C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_SEGMENTTEMP.DBF	3	TS_SEGMENTTEMP
*/
-- Pour afficher les informations sur les fichiers redo log de la base
SELECT GROUP#, STATUS, MEMBER from v$logfile order by GROUP#;
/*
1		C:\APP\MBDS2\ORADATA\DBCOURS\REDO01.LOG
1		C:\APP\MBDS2\ORADATA\DBTEST\REDO11.LOG
2		C:\APP\MBDS2\ORADATA\DBCOURS\REDO02.LOG
2		C:\APP\MBDS2\ORADATA\DBTEST\REDO12.LOG
3		C:\APP\MBDS2\ORADATA\DBCOURS\REDO03.LOG
3		C:\APP\MBDS2\ORADATA\DBTEST\REDO13.LOG
*/
-- Pour afficher les informations sur les fichiers de controles de la base 
SELECT name, status from v$controlfile;
/*
C:\APP\MBDS2\ORADATA\DBCOURS\CONTROL01.CTL	
C:\APP\MBDS2\FLASH_RECOVERY_AREA\DBCOURS\CONTROL02.CTL	
*/

-- 	   2) Ecrire une requête SQL qui permet de lister en une requête l’ensembles des
--        tablespaces avec leur fichiers. La taille de chaque fichier doit apparaître, le volume
--        total de l’espace occupé par fichier ainsi que le volume total de l’espace libre par
--        fichier

SELECT TABLESPACE_NAME, FILE_NAME, BYTES, MAXBYTES, USER_BYTES 
FROM DBA_DATA_FILES
ORDER BY TABLESPACE_NAME;
/*
DATA_SPACE				C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\DATASPACE.DBF					104857600	0			103809024
INDEX_SPACE				C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\INDEXSPACEBIS.DBF				24117248	262144000	23068672
INDEX_SPACE				C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\INDEXSPACE.DBF				10485760	0			9437184
RMAN_TS_DATA			C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\RMAN_TS_DATA.DBF				52428800	0			51380224
SEGMENT_SPACE			C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\SEGMENTSPACE.DBF				104857600	0			103809024
SEGMENTSPACE			C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\SEGMENTSTMPTSPACE.DBF			104857600	0			103809024
SEGMENTTMPTSPACE		C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\SEGMENTTMPTSPACE.DBF			104857600	0			103809024
SYSAUX					C:\APP\MBDS2\ORADATA\DBCOURS\SYSAUX01.DBF									639631360	34359721984	638582784
SYSTEM					C:\APP\MBDS2\ORADATA\DBCOURS\SYSTEM01.DBF									723517440	34359721984	722468864
TLDONNEE				C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TLDONNEE.DBF					1048576		0			983040
TLINDEX					C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TLINDEX.DBF					1048576		0			983040
TLTEMP					C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TLTEMP.DBF					1048576		0			983040
TS_DATAFABNJEU			C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_DATAFABNJEU.DBF			10485760	0			9437184
TS_DATASERVNLOC			C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_DATASERVNLOC.DBF			10485760	0			9437184
TS_DATA_USER			C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_DATA_USER.DBF				10485760	0			9437184
TS_INDEXES				C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS_INDEXES.DBF				10485760	0			9437184
TS_IND_IMMO_AUTO		C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TSIND.IBF						1048576		0			983040
TS_SEG_TMP_AUTO			C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\NEW_SEG_TMP_AUTO.DBF			5242880		0			4194304
TS_SPORT_COMPLEX_AUTO	C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\NEW_SPORT_COMPLEX_AUTO.DBF	5242880		0			4194304
TS_SPORT_SAMPLE_AUTO	C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\NEW_SPORT_SAMPLE_AUTO.DBF		5242880		0			4194304
TS_TAB_IMMO_AUTO		C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\TS.DBF						1048576		0			983040
UNDOTBS1				C:\APP\MBDS2\ORADATA\DBCOURS\UNDOTBS01.DBF									36700160	34359721984	35651584
USERS					C:\APP\MBDS2\ORADATA\DBCOURS\USERS01.DBF									22282240	34359721984	21233664
USERS					C:\APP\MBDS2\PRODUCT\11.2.0\DBHOME_1\DATABASE\INDEXSPACE2.DBF				10485760	262144000	9437184
*/

-- 	   3) Ecrire une requête SQL qui permet de lister les segments et leurs extensions de
--        chacun des segments (tables ou indexes) de votre utilisateur

SELECT SEGMENT_NAME, EXTENTS, SEGMENT_TYPE FROM DBA_SEGMENTS WHERE OWNER='ET214088261I18';
/*
SALON			2	TABLE
UTILISATEUR		4	TABLE
JEU				2	TABLE
FABRICANT		2	TABLE
SERVEUR			1	TABLE
LOCALITE		1	TABLE
AMITIE			2	TABLE
SYS_C0012283	1	INDEX
SYS_C0012286	1	INDEX
SYS_C0012291	1	INDEX
SYS_C0012293	1	INDEX
SYS_C0012295	1	INDEX
SYS_C0012297	1	INDEX
SYS_C0012298	1	INDEX
SYS_C0012340	1	INDEX
*/

-- 	   4) Ecrire une requête qui permet pour chacun de vos segments de donner le nombre
--        total de blocs du segment, le nombre de blocs utilisés et le nombre de blocs libres

SELECT OWNER, SEGMENT_NAME, blocks FROM DBA_SEGMENTS


-- 	   5) Ecrire une requête SQL qui permet de compacter et réduire un segment

-- Etant donné que les lignes doivent être déplacés (ROWID change) on autorise d'abord cela
ALTER TABLE UTILISATEUR ENABLE ROW MOVEMENT;
------> Sortie 			Table UTILISATEUR modifié(e).
ALTER TABLE UTILISATEUR SHRINK SPACE COMPACT CASCADE;
------> Sortie 			Table UTILISATEUR modifié(e).

-- 	   6) Ecrire une requête qui permet d’afficher l’ensemble des utilisateurs de votre base
--        et leurs droits

SELECT USERNAME, PRIVILEGE
FROM
	(DBA_SYS_PRIVS)A,
	(SELECT USERNAME
		FROM DBA_USERS)B
WHERE A.GRANTEE = B.USERNAME;
/*
SYS	DROP ANY ASSEMBLY
SYS	DROP ANY EDITION
SYS	MANAGE SCHEDULER
SYS	ALTER ANY CLUSTER
ET217129221I18	UNLIMITED TABLESPACE
HAB	ALTER ANY CUBE DIMENSION
HAB	DROP ANY ASSEMBLY
JUNIOR	DROP ANY SQL PROFILE
JUNIOR	DROP ANY OPERATOR
SYS	CREATE EXTERNAL JOB
SYS	ALTER ANY ROLE
SYS	CREATE DATABASE LINK
XDB	CREATE PUBLIC SYNONYM
...
*/

-- 	   7) Proposer trois requêtes libres au choix de recherche d’objets dans le dictionnaire Oracle

--		  Lister tous les privilège système accordés à l'utilisateur actuel.
select * from user_sys_privs;
/*
THEBOSS	UNLIMITED TABLESPACE	NO
THEBOSS	CREATE SESSION			NO
*/
--		  Lister les privilège actuellement disponibles pour l'utilisateur
select * from SESSION_PRIVS;
/*
ALTER SYSTEM
AUDIT SYSTEM
CREATE SESSION
ALTER SESSION
CREATE TABLESPACE
ALTER TABLESPACE
MANAGE TABLESPACE
DROP TABLESPACE
UNLIMITED TABLESPACE
CREATE USER
BECOME USER
...	
*/
--		  Lister toutes les tables de l'utilisateur THEBOSS avec leur status
SELECT TABLE_NAME, STATUS FROM ALL_TABLES WHERE OWNER = 'THEBOSS';
/*
PILOTEMOHAMED	VALID
*/










-- 3.3 Mise en place d'une stratégie de sauvegarde et restauration (voir le chap. 6 du cours ADB1)
--     Mettez en place une stratégie de sauvegarde et restauration, basée sur le mode avec
--     archives. Votre stratégie doit décrire la politique de sauvegarde et restauration des fichiers
--     suivant leur type(périodicité des backups des fichiers de données / du spfile / des fichiers
--     d’archives / du fichier de contrôle, duplications des fichiers de contrôles ou rédo, etc).
--     Utililser l’outil Oracle Recovery Manager pour la mettre en œuvre.
--     Ecrirte pour cela un script de sauvegarde qui permet sous RMAN :
-- - D’arrêter la base
-- - De sauvegarder les fichiers de données
-- - De sauvergarder les fichiers d’archives
-- - De sauvegarder le SPFILE
-- - De sauvegarder les fichiers de contrôle
<réponses et trace ici>


-- 3.4 Provoquer deux pannes au moins 
--     Provoquer deux pannes au moins et y remedier grâce à votre stratégie de sauvegarde. Les
--     pannes peuvent être :
-- - La perte de fichiers de données

- La perte de fichiers de contrôles.
<TODO>











-- 3.5 Export / import (voir le chap. 7 du cours ADB1)
--     Vous devez transporter les données d’un de vos utilisateurs d’une base vers une autre. Les
--     deux bases peuvent être la même. Faire le nécessaire en utilisant export et import afin que cela
--     fonctionne.

-- La commande pour EXPORTER la base
exp

/*
Export: Release 11.2.0.1.0 - Production on Mar. Janv. 30 23:36:50 2018

Copyright (c) 1982, 2009, Oracle and/or its affiliates.  All rights reserved.


Nom utilisateur : toto
Mot de passe :azerty

ConnectÚ Ó : Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production
With the Partitioning, OLAP, Data Mining and Real Application Testing options
Entrer taille mÚmoire tampon extract. par tableau : 4096

Fichier d'export : EXPDAT.DMP > BACKUPTOTO.DMP

(1)B(dD EntiÞre), (2)U(tilisat.) ou (3)T(ables): (2)U > 2

Export des privilÞges (oui/non): oui > oui

Export des tables de donnÚes (oui/non): oui > oui

Comprimer les extents (oui/non): oui > oui

Export fait dans le jeu de car WE8MSWIN1252 et jeu de car NCHAR AL16UTF16
PrÛt Ó exporter les utilisateurs spÚcifiÚs ...
Utilisateur Ó exporter : (RETOUR pour quitter) > toto

Utilisateur Ó exporter : (RETOUR pour quitter) >

. export des actions et objets procÚduraux de prÚ-schÚma
. export des noms de bibliothÞque de fonctions ÚtrangÞres pour l'utilisateur TOTO
. export des synonymes de type PUBLIC
. export des synonymes de type PRIVATE
. export des dÚfinitions de type d'objet pour l'utilisateur TOTO
PrÛt Ó exporter les objets TOTO...
. export des liens de base de donnÚes (DATABASE LINKS)
. export des numÚros de sÚquence
. export des dÚfinitions de cluster
. PrÛt Ó exporter les tables  TOTO ... via le chemin classique...
. . export de la table                     UTILISATEUR          64 lignes exportÚes         <
. . export de la table                     SALON                      30 lignes exportÚes         <
. . export de la table                     SERVEUR                  9 lignes exportÚes         <
. . export de la table                     JEU                              29 lignes exportÚes         <
. . export de la table                     FABRICANT             23 lignes exportÚes         <
. . export de la table                     LOCALITE                 9 lignes exportÚes         <
. export des synonymes
. export des vues
. export des procÚdures stockÚes
. export des opÚrateurs
. export des contraintes d'intÚgritÚ rÚfÚrentielle
. export des dÚclencheurs
. export des types d'index
. export des index bitmap, fonctionnels et extensibles
. export des actions post-tables
. export des vues matÚrialisÚes
. export des journaux de clichÚs
. export  des files d'attente de travaux
. export des groupes de rÚgÚnÚration et fils
. export des dimensions
. export des actions et objets procÚduraux de post-schÚma
. export des statistiques
ProcÚdure d'export terminÚe avec succÞs sans avertissements.
*/


-- La commande pour IMPORTER la base
imp newtoto/azerty file='C:\BACKUPTOTO.DMP' commit=y ignore=y full=y
/*
Import: Release 11.2.0.1.0 - Production on Mar. Janv. 30 23:57:41 2018 

Copyright (c) 1982, 2009, Oracle and/or its affiliates. All rights reserved. 

ConnectÚ Ó : Oracle Database 11g Enterprise Edition Release 11.2.0.1.0 - 64bit Production 
With the Partitioning, OLAP, Data Mining and Real Application Testing options 

Fichier d'export crÚÚ par EXPORT:V11.02.00 via le chemin classique 

Attention : les objets ont ÚtÚ exportÚs par TOTO, et non par vous 
import effectuÚ dans le jeu de caractÞres WE8MSWIN1252 et le jeu NCHAR AL16UTF16 . 
Import d'objets TOTO dans NEWTOTO ...
... 
Fin de l'import rÚussie sans avertissements.
*/
