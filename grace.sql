-- pour afficher le path des DBFs
col tablespace_name format A20
col file_name format A70
SET linesize 200
SELECT tablespace_name, file_name
FROM dba_data_files
WHERE tablespace_name IN ('SYSTEM', 'SYSAUX', 'TEMP', 'USERS', 'TABLE%')
ORDER BY tablespace_name;
/*
TABLESPACE_NAME      FILE_NAME
-------------------- ----------------------------------------------------------------------
SYSAUX               C:\APP\GB\ORADATA\PROJETJGM\SYSAUX01.DBF
SYSTEM               C:\APP\GB\ORADATA\PROJETJGM\SYSTEM01.DBF
USERS                C:\APP\GB\ORADATA\PROJETJGM\USERS01.DBF
*/

