LOAD DATA
INFILE 'C:\data.csv'
TRUNCATE
INTO TABLE UTILISATEUR
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(
mailtoUsr,
nomUsr,
prenomUsr,
date_naissanceUsr,
paysUsr,
villeUsr,
nb_Amis,
numS
)