-----------------------------csv


DROP DIRECTORY ext_file_ds;
CREATE OR REPLACE DIRECTORY ext_file_ds AS '/home/oracle/workspace/csv';
GRANT ALL ON DIRECTORY ext_file_ds TO PUBLIC;
---

----------------------------------owner

DROP TABLE owner;
CREATE TABLE owner (
    owner_id      INTEGER,
    owner_name    VARCHAR2(150),
    owner_phone   VARCHAR2(10),
    owner_email   VARCHAR2(50)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY ext_file_ds
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE
    FIELDS TERMINATED BY ','
    MISSING FIELD VALUES ARE NULL
  )
  LOCATION ('owner.csv')
)
REJECT LIMIT UNLIMITED;


---------------------


SELECT * FROM owner;


------------------------pet



 DROP TABLE pet;
 CREATE TABLE pet (
     pet_id                INTEGER,
     pet_birthday          DATE,
     pet_sex               VARCHAR2(10),
     pet_name              VARCHAR2(100),
     comments              VARCHAR2(150),
     species_species_id    INTEGER,
     owner_owner_id        INTEGER
 )
 ORGANIZATION EXTERNAL (
   TYPE ORACLE_LOADER
   DEFAULT DIRECTORY ext_file_ds
   ACCESS PARAMETERS (
     RECORDS DELIMITED BY NEWLINE SKIP 1
     FIELDS TERMINATED BY ','
     MISSING FIELD VALUES ARE NULL
     (   pet_id,
         pet_birthday   CHAR(10) DATE_FORMAT DATE MASK "DD-MM-YYYY",
         pet_sex,
         pet_name,
         comments,
         species_species_id,
         owner_owner_id
     )
   )
   LOCATION ('pet.csv')
 )
 REJECT LIMIT UNLIMITED;


 ------------------------


 SELECT * FROM pet;
