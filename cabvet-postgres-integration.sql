
----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------
-- PostgreSQL --- username: postgres     ---- password: postgres
-- database: cabvet
-- tables: invoice and prescription

-----------------------------------



DROP DATABASE LINK PG;
CREATE DATABASE LINK PG
   CONNECT TO postgres IDENTIFIED BY secret
   USING '(DESCRIPTION =
    (ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))
    (CONNECT_DATA=(SID=PG))
    (HS=OK)
    )';

select * from invoice@PG;






 DROP DATABASE LINK PG;
 CREATE DATABASE LINK PG
    CONNECT TO postgres IDENTIFIED BY postgres
    USING 'PG';

 --- Check DB Link

 --select * from invoice@PG;
 select * from "potgres"@PG;


 --- Create views on remote tables
 CREATE OR REPLACE VIEW invoice_view AS
 select
     "invoice_id" as invoice_id,
     "invoice_date" as invoice_date,
     "invoice_amount" as invoice_amount
 from "postgres"@PG; --invoice

 SELECT * FROM invoice_view;


 CREATE OR REPLACE VIEW prescription_view AS
 select
     "prescription_id" as prescription_id,
     "medication" as medication,
     "amount" as amount,
     "dosage" as dosage,
     "unit_price" as unit_price,
     "prescription_details" as prescription_details,
     "medical_record_id" as medical_record_id,
     "invoice_invoice_id" as invoice_invoice_id
 from "postgres"."prescription"@PG;     -- "invoice"."prescription"@PG;

 SELECT * FROM prescription_view;




 DROP TABLE invoice;
 CREATE TABLE invoice AS
 select
     i."invoice_id" as invoice_id,
     i."invoice_date" as invoice_date,
     i."invoice_amount" as invoice_amount,
     -- prescription
     p."prescription_id" as prescription_id,
     p."medication" as medication,
     p."amount" as amount,
     p."dosage" as dosage,
     p."unit_price" as unit_price,
     p."prescription_details" as prescription_details,
     p."medical_record_id" as medical_record_id
 from "postgres"."invoice"@PG I
     INNER JOIN "postgres"."prescription"@PG P
         ON I."invoice_id" = P."invoice_invoice_id";

 SELECT * FROM invoice;



 -------------------------------------
 DROP DATABASE LINK PG;
 CREATE DATABASE LINK PG
    CONNECT TO "postgres" IDENTIFIED BY postgres
    USING 'PG';

 SELECT * FROM "postgres"."invoice"@PG;
