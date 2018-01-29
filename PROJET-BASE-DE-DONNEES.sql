1.2 Schéma logique de données
Définir ou générer un schéma logique de la base de données avec au moins 7 tables:
o Prendre en compte dans cette phase les règles de gestion de type contraintes
d'intégrités (de domaine : check/not null, d’entité : primary key/unique key, de
référence : foreign key)

create table Salon(
	numS number(4) NOT NULL, 
	nomS VARCHAR2(100),
	paysS VARCHAR2(255),
	villeS VARCHAR2(255),
	date_DebutS DATE not null,
	date_FinS DATE,
	PRIMARY KEY(numS) USING INDEX tablespace TS_INDEX_DATA
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_SEG_TEMP
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

/*
CONSTRAINT Heberge_Par FOREIGN KEY (IdServ)
	REFERENCES Serveur(IdServ),
	CONSTRAINT Propose FOREIGN KEY (IdJeu)
	REFERENCES Jeu(IdJeu)
*/

create table Utilisateur(
	mailtoUsr VARCHAR(255) NOT NULL,
	nomUsr VARCHAR(100),
	prenomUsr VARCHAR(100),
	date_naissanceUsr DATE NOT NULL,
	paysUsr VARCHAR(255),
	villeUsr VARCHAR(255),
	nb_Amis int,
	PRIMARY KEY(mailtoUsr) USING INDEX tablespace TS_INDEX_DATA
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATA_USER
STORAGE(INITIAL 4096K NEXT 4096K PCTINCREASE 0 MINEXTENTS 1);

/*
CONSTRAINT ParticipeA FOREIGN KEY (numS)
	REFERENCES Salon(numS)
*/

create table AMITIE(
	mailtoUsr1 VARCHAR(255) not null,
	mailtoUsr2 VARCHAR(255) NOT NULL,
	PRIMARY KEY(mailtoUsr1, mailtoUsr2) USING INDEX tablespace TS_INDEX_DATA
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATA_USER
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

/*
FOREIGN KEY(mailtoUsr2) REFERENCES utilisateur
*/

create table Jeu(
	IdJeu int NOT NULL,
	nomJeu VARCHAR(255),
	annee_sortie DATE,
	PRIMARY KEY (IdJeu) USING INDEX tablespace TS_INDEX_DATA
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATA_FAB_JEU
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

/*
CONSTRAINT Fabrique_Par FOREIGN KEY (IdF)
	REFERENCES Fabricant(IdF)
*/

create table Fabricant(
	IdF int NOT NULL,
	nomF VARCHAR(255)
	PRIMARY KEY (IdF) USING INDEX tablespace TS_INDEX_DATA
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATA_FAB_JEU
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

create table Serveur(
	IdServ int NOT NULL,
	nomServ VARCHAR(255),
	PRIMARY KEY (IdServ) USING INDEX tablespace TS_INDEX_DATA
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATA_SERV_LOCALITE
STORAGE(INITIAL 1024K NEXT 512K PCTINCREASE 0 MINEXTENTS 1);

/*
CONSTRAINT Se_trouve FOREIGN KEY (IdLoc)
	REFERENCES Localite(IdLoc)
*/

create table Localite(
	IdLoc int NOT NULL,
	ville VARCHAR(255) UNIQUE
	PRIMARY KEY (IdLoc) USING INDEX tablespace TS_INDEX_DATA
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_dataServNLoc
STORAGE(INITIAL 1024K NEXT 1024K PCTINCREASE 0 MINEXTENTS 1);

o Définir au moins un trigger pour assurer l’intégrité des données ne pouvant être
prise en charge par les contraintes d’intégrités du modèle relationnel

Ici on peut créer un trigger de suppression. On aura dans la table utilisateur un attribut avec le total de son nombre d'amis. Si un de ses amis est supprimé, alors ce total est affecté.

create trigger triggerOfInsert on amitié
after insert 
as
update utilisateur
set nb_Amis = nb_Amis 

2. Organisation physique de la base sous Oracle 11g (2
jours)
En partant du schéma logique définit précédemment, vous procédérez dans cette étape à
l’organisation physique de la base de données.
Vous devez donc assurerer les tâches suivantes :
o Créer les tablespaces suivants et expliquer leur intérêt:
 Un ou plusieurs tabespaces pour stocker les données des tables.
---------->	Contient les segments de Utilisateur
CREATE TABLESPACE TS_dataUsr
DATAFILE 'C:\APP\GB\ORADATA\PROJETJGM\'
SIZE ...
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

---------->	Contient les segments Serveur et Localité
CREATE TABLESPACE TS_dataServNloc
DATAFILE 'C:\APP\GB\ORADATA\PROJETJGM\'
SIZE ...
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

---------->	Contient les segments Fabricant et Jeu
CREATE TABLESPACE TS_dataFabNjeu
DATAFILE 'C:\APP\GB\ORADATA\PROJETJGM\'
SIZE ...
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;


 Un ou plusieurs tablespaces pour stocker les données d’indexes
CREATE TABLESPACE TS_indexes
DATAFILE 'C:\APP\GB\ORADATA\PROJETJGM\'
SIZE ...
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

 Un tablespace pour stocker les segments temporaires.
---------->	On va y stocker les segments Salon car un Salon est temporaire, il a une date de début et de fin, il n'existe que si des joueurs y sont inscrits

CREATE TEMPORARY TABLESPACE TS_segmentTemp
TEMPFILE 'C:\APP\GB\ORADATA\PROJETJGM\'
SIZE ... 
EXTENT MANAGEMENT LOCAL AUTOALLOCATE;
Note : Tous vos tablespaces seront gérés localement. Ils seront en mode
AUTOALLOCATE ou UNIFORM SIZE. Vous devez expliquer l’intérêt et les
bénéfices de vos choix.

Créer un utilisateur de votre choix qui sera propriétaire de votre application. Les segments temporaires doivent être localisés dans le tablespace approprié créé précédement. Vous devez lui donner les droits appropriés.

CREATE USER TheBoss IDENTIFIED BY GraceJulienMohamed
DEFAULT tablespace USERS
TEMPORARY TS_segmentTemp
QUOTA unlimited on USERS, TS_dataUsr, TS_dataFabNJeu, TS_data_ServNloc, TS_indexes, TS_segmentTemp;

GRANT DBA TO TheBoss;


