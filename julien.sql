TO CONNECT ROOT : connect system/Eidi
TO CONNECT capitaine : connect capitaine/admin
TO CONNECT visitor : xXvisitorpasswordXx (on en est a faire les tables avec dbms)
	1.1 SCHEMA Logique avec gestion type de contraintes (de  domaine:  check/not  null,  
			d’entité:  primary key/unique  key,  de référence: foreign key)

	1.2 Definir Triggerpour assurer integritée des données:

	???

	2 Creation TableSpace
	AUTOALLOCATE ou UNIFORME SIZE ? : Autoallocate peut pas etre utilisé pour temporaire(uniforme par default)
	Unif: suivi plus simple de l'allocation des extents + minimise fragmentation + meilleure perf (debat)
	AutoAlloc = plus en plus grand : optimise espace (pas d'offset vide comme unif) - maximise la fragmentation.

	2.1.1	TableSpaces pour stocker les données de tables:
SQL> 	CREATE TABLESPACE DATAx1 DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\DATAx1.DBF' size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

	2.1.2	TableSpaces pour stocker les données d'index:
SQL> 	CREATE TABLESPACE INDEXx1 DATAFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\INDEXx1.DBF' size 10m EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;

	2.1.3	TableSpace pour stocker les segments temporaires:
SQL>	CREATE TEMPORARY TABLESPACE TEMP_PERSO TEMPFILE 'C:\PROGRAM FILES\ORACLE11GR2\BASE\ORCL\TEMP_PERSO.dbf' size 10m;
	+ Suppression.
		drop tablespace TEMP INCLUDING CONTENTS AND DATAFILES;// pas possible pour ts default
	+ Remplacement d'une table default.
		ALTER DATABASE DEFAULT TEMPORARY TABLESPACE TEMP_PERSO;
	+ La suppression de TEMP est maintenant possible.


	2.2 Creation utilisateur
		Creer un utilisateur (propriétaire de notre application, droits appropriés et segment temporaire 
		au bon endroit):

SQL>	create user capitaine identified by admin 
	default tablespace users 
	temporary tablespace TEMP_PERSO;
SQL>	grant dba to capitaine; // donne tout les privilège
SQL>	revoke unlimited tablespace from capitaine; // on limite pour capitaine les ts 
SQL>	connect capitaine/admin 
SQL>	Alter user capitaine quota unlimited on users; // autorise ecriture dans users


2.3.1 Creation des tables PLUS + PLUS volumetrie
	void script "4scripts/demoblb.sql"

	Analyser volumetrie avec dbms_space (voir Tp 4 correction)PAS COMPRIS :
				begin 
				dbms_space.space_usage(...); 
				end;
	Format création base:
				-- Volumétrie de cette table : 2M à la création avec un taux de croissance
				-- de 50% (soient 1M) par an pendant 5 ans.
				-- Le volume de chaque index de cette table sera de 10% de celui de la table
				-- Remplacer XXX par les bonnes valeurs.
				drop table vol CASCADE CONSTRAINTS ;
				create table vol(
					   vol#    number(4)    	constraint pk_vol primary key 
						USING INDEX tablespace TS_IND_AIRBASE_AUTO
						STORAGE(INITIAL 200K NEXT 200K PCTINCREASE 0 MINEXTENTS 1),
					   pilote#	number(4)    	not null
							CONSTRAINT vol_fk_pilote 
							REFERENCES pilote(PL#)
							ON DELETE CASCADE,
					   avion#  	number(4)    	not null,
					   vd		varchar2(20),
					   va		varchar2(20),       
					   hd		number(4) 	not null, 
					   ha		number(4),  
					   dat		date,
					CONSTRAINT vol_chk_ha CHECK (ha>hd),
					FOREIGN KEY (avion#) REFERENCES avion(AV#)
				)
				tablespace TS_TAB_AIRBASE_UNIFORM
				STORAGE(INITIAL 2M NEXT 2M PCTINCREASE 0 MINEXTENTS	1);
2.3.2 remplir les tables
	Format insertion:
			insert into  avion values(1, 'A300', 300, 'Nice', 'En service');   
			insert into  avion values(2, 'A300', 300, 'Nice', 'En service');   
			insert into  avion values(3, 'A320', 320, 'Paris', 'En service');  

3.1 sql loader
	1-> csv file is : "data.csv"
	2-> une table doit correspondre aux champs defini dans le csv
	3-> On creer un fichier de controle ".ctl" tq :
		LOAD DATA
		INFILE 'D:FAR_T_SNSA.csv'
		INSERT INTO TABLE Billing
		FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
		TRAILING NULLCOLS
		(
		iocl_id,
		iocl_consumer_id
		)
	4-> run :
		Sqlldr capitaine/admin Control=ControlFileName.ctl log=LogTestInjectionFromCSV.log

	3.2.1 Visualiser tout les fichiers de la base:
	//fichiers data + temp
SELECT file_name, file_id, tablespace_name FROM DBA_DATA_FILES order by file_id;

	//fichiers redo-log
Select GROUP#, MEMBER from v$logfile order by GROUP#, MEMBER;

	//fichiers de controle
select NAME from v$controlfile order by NAME;

	3.2.2 tablespace et leur fichier
SELECT tablespace_name, bytes, user_bytes, maxbytes  FROM DBA_DATA_FILES order by TABLESPACE_NAME;


	3.2.3  afficher segment + extension
select segment_name, segment_type Type, tablespace_name, bytes, blocks, extents, 
initial_extent init_exts, next_extent next, min_extents min_exts, 
max_extents max_exts, pct_increase increase 
from dba_segments where owner='capitaine';
	// OU
select owner, segment_name, segment_type seg_type, f.file_id, e.tablespace_name, extent_id , e.bytes, e.blocks 
from dba_extents e, dba_data_files f 
where e.tablespace_name=f.tablespace_name and e.owner='capitaine'
order by segment_name;
	//OU (voir tp 4 correction)
select owner, segment_name, segment_type type, f.file_id, e.tablespace_name, extent_id , e.bytes, e.blocks 
from dba_extents e, dba_data_files f 
where e.tablespace_name=f.tablespace_name and e.owner='capitaine';


	3.2.4 pour chaque segment : nombre total de blocs , le nombre de blocs utilisés et libre (du segment).
SELECT tablespace_name, SUM(blocks), MIN(blocks) , MAX(blocks), AVG(blocks) 
FROM dba_free_space GROUP BY tablespace_name;

	3.2.5 compacter et reduire un segment
ALTER TABLE ETUDIANT ENABLE ROW MOVEMENT ;
ALTER TABLE uairbase.etudiant SHRINK SPACE cascade;

	3.2.6 users + droit (le resultat n'est pas bon)
select * from dba_sys_privs; 


	3.3 RMAN
//elargir zone recuperation rapide
sl> alter system set db_recovery_file_dest_size=20M;

Passage mode archive:
sql>shutdown immediate;
sql>startup mount
sql>archive log list;
sql>alter database archivelog;
sql>archive log list;
sql>alter database open;

Se connecter à RMAN
c:\>set ORACLE_SID=ORCL
c:\>rman
rman> connect target sys@ORCL/dbamanager

RMAN> SHUTDOWN IMMEDIATE;
RMAN> STARTUP FORCE DBA;
RMAN> SHUTDOWN IMMEDIATE;
RMAN> STARTUP MOUNT;

RMAN> BACKUP DATABASE INCLUDE CURRENT CONTROLFILE ;
RMAN> BACKUP ARCHIVELOG ALL;
