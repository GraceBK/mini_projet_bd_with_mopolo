-- requete pour afficher la liste des USER;
SQL> SELECT TABLESPACE_NAME FROM USER_TABLESPACES;

-- select value from v$parameter;

SQL> SET SERVEROUTPUT ON;
SQL> DECLARE v_estimation NUMBER;
	v_alloue NUMBER;
	v_sql VARCHAR2(255) :='CREATE INDEX idx_1 ON societe(soc_code,soc_nom)';
	BEGIN DBMS_SPACE.CREATE_INDEX_COST(v_sql, used_bytes => v_estimation, alloc_bytes => v_alloue);
	DBMS_OUTPUT.PUT_LINE ('Estimation Index = '|| v_estimation); DBMS_OUTPUT.PUT_LINE ('Segment alloue = '|| v_alloue);
	END;

/ Estimation Index = 2886 Segment alloue = 65536 Procédure PL/SQL terminée avec succès.
SQL>  

SQL> REPHEADER PAGE CENTER 'NOM INDEX ET TAILLE ALLOUEE SEGMENT'
SQL> SELECT idx.index_name, SUM(seg.bytes) FROM dba_segments seg, dba_indexes idx WHERE idx.table_owner = 'SYSADM' AND idx.table_name like '%' AND idx.owner = seg.owner AND idx.index_name = seg.segment_name GROUP BY idx.index_name ORDER BY 2 ASC; 