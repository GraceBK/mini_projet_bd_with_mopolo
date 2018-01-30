--1.2 Schéma logique de données
Définir ou générer un schéma logique de la base de données avec au moins 7 tables:
----o Prendre en compte dans cette phase les règles de gestion de type contraintes d'intégrités (de domaine : check/not null, d’entité : primary key/unique key, de référence : foreign key)

Création de la Table SALON

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

------> Sortie 				Table SALON créé(e).

Création de la Table UTILISATEUR

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

------> Sortie 			Table UTILISATEUR créé(e).

Création de la Table AMITIE

create table AMITIE(
	mailtoUsr1 VARCHAR(255) not null,
	mailtoUsr2 VARCHAR(255) NOT NULL,
	PRIMARY KEY(mailtoUsr1, mailtoUsr2) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1),
  FOREIGN KEY (mailtoUsr2) REFERENCES Utilisateur(mailtoUsr))
tablespace TS_DATA_USER
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie 			Table AMITIE créé(e).

Création de la Table JEU

create table Jeu(
	IdJeu int NOT NULL,
	nomJeu VARCHAR(255),
	annee_sortie DATE,
  PRIMARY KEY (IdJeu) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATAFABNJEU
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie 			Table JEU créé(e).

Création de la Table FABRICANT

create table Fabricant(
	IdF int NOT NULL,
	nomF VARCHAR(255),
  PRIMARY KEY (IdF) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATAFABNJEU
STORAGE(INITIAL 2048K NEXT 2048K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie 			Table FABRICANT créé(e).

Création de la Table SERVEUR

create table Serveur(
	IdServ int NOT NULL,
	nomServ VARCHAR(255),
  PRIMARY KEY (IdServ)  USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_DATASERVNLOC
STORAGE(INITIAL 1024K NEXT 512K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie 			Table SERVEUR créé(e).

Création de la Table LOCALITE

create table Localite(
	IdLoc int NOT NULL,
	ville VARCHAR(255) UNIQUE,
  PRIMARY KEY (IdLoc) USING INDEX tablespace TS_INDEXES
	STORAGE(INITIAL 64K NEXT 64K PCTINCREASE 0 MINEXTENTS 1))
tablespace TS_dataServNLoc
STORAGE(INITIAL 1024K NEXT 1024K PCTINCREASE 0 MINEXTENTS 1);

------> Sortie 			Table LOCALITE créé(e).

ON VA MAINTENANT AJOUTER LES CONTRAINTES

ALTER TABLE SALON ADD IdServ int;
------> Sortie 			Table SALON modifié(e).
ALTER TABLE SALON ADD CONSTRAINT Heberge_Par FOREIGN KEY (IdServ) REFERENCES Serveur(IdServ);
------> Sortie 			Table SALON modifié(e).

ALTER TABLE SALON ADD IdJeu int;
------> Sortie 			Table SALON modifié(e).
ALTER TABLE SALON ADD CONSTRAINT Propose FOREIGN KEY (IdJeu) REFERENCES Jeu(IdJeu);
------> Sortie 			Table SALON modifié(e).

ALTER TABLE UTILISATEUR ADD numS number(4);
------> Sortie 			Table UTILISATEUR modifié(e).
ALTER TABLE UTILISATEUR ADD CONSTRAINT ParticipeA FOREIGN KEY (numS) REFERENCES Salon(numS);
------> Sortie 			Table UTILISATEUR modifié(e).

ALTER TABLE JEU ADD IdF int;
------> Sortie 			Table JEU modifié(e).
ALTER TABLE JEU ADD CONSTRAINT Fabrique_Par FOREIGN KEY (IdF) REFERENCES Fabricant(IdF);
------> Sortie 			Table JEU modifié(e).

ALTER TABLE SERVEUR ADD IdLoc int;
------> Sortie 			Table SERVEUR modifié(e).
ALTER TABLE SERVEUR ADD CONSTRAINT Se_trouve FOREIGN KEY (IdLoc) REFERENCES Localite(IdLoc);
------> Sortie 			Table SERVEUR modifié(e).


----o Définir au moins un trigger pour assurer l’intégrité des données ne pouvant être prise en charge par les contraintes d’intégrités du modèle relationnel

On va ajouter un trigger qui marche comme suit:
--Lorsqu'on supprime une cle Primaire dans la table SALON, la clé étrangère correspondante dans la table UTILISATEUR est mise à NULL

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
------> Sortie 			Elément Trigger MAJCLESALON compilé

On va ajouter un trigger qui marche comme suit:
--Lorsque dans la table AMITIE un utilisateur a un nouvel ami, le nombre total de ses amis est affecté dans la table UTILISATEUR

create trigger TR_NOUVEL_AMI 
after insert on AMITIE
begin
	update utilisateur
	set nb_Amis = nb_Amis + 1;
end;
------> Sortie 			Elément Trigger TR_NOUVEL_AMI compilé


--2. Organisation physique de la base sous Oracle 11g (2 jours)
En partant du schéma logique définit précédemment, vous procédérez dans cette étape à
l’organisation physique de la base de données.
Vous devez donc assurerer les tâches suivantes :

o Créer les tablespaces suivants et expliquer leur intérêt:

 Un ou plusieurs tabespaces pour stocker les données des tables.

-- On crée un tablespace pour les données de la table Utilisateur
SQL> CREATE TABLESPACE TS_DATA_USER DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_DATA_USER.DBF' size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

Tablespace crÚÚ.

-- On crée un tablespace pour les données de la table Fabricant et la table Jeux
SQL> CREATE TABLESPACE TS_DATAFABNJEU DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_DATAFABNJEU.DBF' size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

Tablespace crÚÚ.

-- On crée un tablespace pour les données de la table Serveur et la table Localité
SQL> CREATE TABLESPACE TS_DATASERVNLOC DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_DATASERVNLOC.DBF' size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

Tablespace crÚÚ.


 Un ou plusieurs tablespaces pour stocker les données d’indexes
--Nous avons décidé de créer un seul tablespace pour stocker tous les indexes 
SQL> CREATE TABLESPACE TS_INDEXES DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_INDEXES.DBF' size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

Tablespace crÚÚ.


 Un tablespace pour stocker les segments temporaires.
-- On va y stocker la table SALON car un SALON est temporaire et n'existe que s'il y a des joueurs qui y sont inscrits
SQL> CREATE TEMPORARY TABLESPACE TS_SEGMENTTEMP TEMPFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TS_SEGMENTTEMP.DBF' size 10m;

Tablespace crÚÚ.

###Autoallocate ne peut pas etre utilisé pour temporaire(uniforme par default)
    Unif: suivi plus simple de l'allocation des extents + minimise fragmentation + meilleure perf (debat)
    AutoAlloc = plus en plus grand : optimise espace (pas d'offset vide comme unif) - maximise la fragmentation.
###

Note : Tous vos tablespaces seront gérés localement. Ils seront en mode AUTOALLOCATE ou UNIFORM SIZE. Vous devez expliquer l’intérêt et les bénéfices de vos choix.


o Créer un utilisateur de votre choix qui sera propriétaire de votre application. Les
segments temporaires doivent être localisés dans le tablespace approprié créé
précédement. Vous devez lui donner les droits appropriés.

CREATE USER TheBoss IDENTIFIED BY GraceJulienMohamed
DEFAULT tablespace USERS
TEMPORARY tablespace TS_segmentTemp
QUOTA unlimited on USERS 
QUOTA unlimited on TS_DATA_USER 
QUOTA unlimited on TS_DATAFABNJEU
QUOTA unlimited on TS_DATASERVNLOC
QUOTA unlimited on TS_INDEXES;
------> Sortie 			User THEBOSS créé(e).

grant create session to THEBOSS; 		--Pour qu'il puisse se connecter
------> Sortie 			Succès de l'élément Grant.


o Créer le schéma de données en séparant les données des tables et les index
 Vous dimensionnerez de façon pertinente les segments. Pour cela vous devez
utiliser le package DBMS_SPACE pour estimer la volumétrie de vos tables et
de vos indexes afin de trouver le volume de données nécessaire dès la création 
de ces segments. Il est important d’estimer le nombre total de lignes de chacune
de vos tables
<réponses et trace ici>


 Insérer pour l’instant en moyenne une dizaine de lignes de test dans chacune des
tables.

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

-- insertion SALON (NUM_SAL, NOM_SAL, PAYS_SAL, VILLE_SAL, DATE_DEBUT_SAL, DATE_FIN_SAL, IDSERV, IDJEU)

--A ce niveu ci, on s'est rendu compte que ce n'était pas une bonne idée d'avoir mis la table SALON dans un TS temporaire. On l'a alors déplacée
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



3. Étape d'Administration (2 jours)
3.1 Sqlloader (voir le chap. 7 du cours ADB1)
Ecrire un script (fichier de contrôle SQLLOADER) qui permet de charger les lignes contenues
dans un fichier CSV (ligne à construire dans EXCEL) vers une ou plusieurs de vos tables. Les
données sont à préparer auparavant.
<réponses et trace ici>
3.2 Divers requêtes
1) Ecrire une requête SQL qui permet de visualiser l’ensemble des fichiers qui
composent votre base
<réponses et trace ici>
2) Ecrire une requête SQL qui permet de lister en une requête l’ensembles des
tablespaces avec leur fichiers. La taille de chaque fichier doit apparaître, le volume
total de l’espace occupé par fichier ainsi que le volume total de l’espace libre par
fichier
<réponses et trace ici>
3) Ecrire une requête SQL qui permet de lister les segments et leurs extensions de
chacun des segments (tables ou indexes) de votre utilisateur
<réponses et trace ici>
Étape d'Administration (2 jours)
Gabriel MOPOLO-MOKE page 4/5
4) Ecrire une requête qui permet pour chacun de vos segments de donner le nombre
total de blocs du segment, le nombre de blocs utilisés et le nombre de blocs libres
<réponses et trace ici>
5) Ecrire une requête SQL qui permet de compacter et réduire un segment
<réponses et trace ici>
6) Ecrire une requête qui permet d’afficher l’ensemble des utilisateurs de votre base et
leurs droits
<réponses et trace ici>
7) Proposer trois requêtes libres au choix de recherche d’objets dans le dictionnaire
Oracle
<réponses et trace ici>
3.3 Mise en place d'une stratégie de sauvegarde et restauration
(voir le chap. 6 du cours ADB1)
Mettez en place une stratégie de sauvegarde et restauration, basée sur le mode avec
archives. Votre stratégie doit décrire la politique de sauvegarde et restauration des fichiers
suivant leur type(périodicité des backups des fichiers de données / du spfile / des fichiers
d’archives / du fichier de contrôle, duplications des fichiers de contrôles ou rédo, etc).
Utililser l’outil Oracle Recovery Manager pour la mettre en œuvre.
Ecrirte pour cela un script de sauvegarde qui permet sous RMAN :
- D’arrêter la base
- De sauvegarder les fichiers de données
- De sauvergarder les fichiers d’archives
- De sauvegarder le SPFILE
- De sauvegarder les fichiers de contrôle
<réponses et trace ici>
3.4 Provoquer deux pannes au moins 
Notes importantes
Gabriel MOPOLO-MOKE page 5/5
Provoquer deux pannes au moins et y remedier grâce à votre stratégie de sauvegarde. Les
pannes peuvent être :
- La perte de fichiers de données
- La perte de fichiers de contrôles.
<réponses et trace ici>
3.5 Export / import (voir le chap. 7 du cours ADB1)
Vous devez transporter les données d’un de vos utilisateurs d’une base vers une autre. Les
deux bases peuvent être la même. Faire le nécessaire en utilisant export et import afin que cela
fonctionne.
<réponses et trace ici>
