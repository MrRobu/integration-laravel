---  Integration Model: JSON



--- Preparing ------------------------------------------------------------------------------------------------------------------
DROP DIRECTORY ext_file_ds;
CREATE OR REPLACE DIRECTORY ext_file_ds AS '/home/oracle/workspace/json';
--- Files: species.json
GRANT ALL ON DIRECTORY ext_file_ds TO PUBLIC;

------- RAW JSON Local Table ---------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
-- Strategy 1: load data using anonymous PL/SQL block



--drop view species;
drop table breed_species;
create table breed_species(doc_json clob, constraint chk check ( doc_json is json ));



-- load JSON into raw table
declare
    json_file bfile := bfilename('EXT_FILE_DS','bs.json');
    json_clob clob;
begin
    dbms_lob.open(json_file);
    dbms_lob.createtemporary(json_clob,true);
    dbms_lob.loadfromfile(json_clob,json_file,dbms_lob.getlength(json_file));
    insert into breed_species values (json_clob);
    commit;
    dbms_lob.freetemporary(json_clob);
end;
/




----------------------------------

/* WITH constraint chk check ( doc_json is json ) clause in table */
-- Query JSON document using column-path-like syntax: return json-sub-documents


select bs.* from breed_species bs;
select bs.doc_json from breed_species bs;
select bs.doc_json.breed_species from breed_species bs;


-- Query JSON document using column-path-like syntax: return json-arrays


SELECT
    bs.doc_json.breed_species.species_id as species_id,
    bs.doc_json.breed_species.species_name as species_name,
    bs.doc_json.breed_species.species_description as species_description
from breed_species bs;



-- Query with JSON_QUERY: JSONPath

SELECT
    JSON_QUERY(bs.doc_json.breed_species.breeds, '$[0]') as breeds,
    bs.doc_json.breed_species.breeds breed_json
from breed_species bs;


-- Query with JSON_EXISTS filter: json_expression to select documents ----

SELECT
    bs.doc_json.breed_species b_json
from breed_species bs
WHERE json_exists(bs.doc_json.breed_species, '$[*].species_id');




SELECT
    bs.doc_json.breed_species.breeds b_json
from breed_species bs
WHERE json_exists(bs.doc_json.breed_species.breeds.breed, '$[*].breed_id');






SELECT
    JSON_VALUE(JSON_QUERY(bs.doc_json.breed_species, '$[0]'), '$.species_id') as species_id,
    JSON_VALUE(JSON_QUERY(bs.doc_json.breed_species, '$[0]'), '$.species_name') as species_name,
    JSON_VALUE(JSON_QUERY(bs.doc_json.breed_species, '$[0]'), '$.species_description') as species_description,
    JSON_QUERY(bs.doc_json.breed_species.breeds.breed, '$[0]') as breed
from breed_species bs;










-------------------------------------------------------------------------------------------------------------------------------
-- REFACTOR JSON_TABLE Query: use with-subquery instead of from-subquery
with json as
   (select bs.doc_json.breed_species doc from breed_species bs )
SELECT species_id , species_name,  species_description
FROM  JSON_TABLE( (select doc from json) , '$[*]'
           COLUMNS ( species_id   PATH '$.species_id'
                   , species_name PATH '$.species_name'
                   , species_description PATH '$.species_description'
                   )
);



with json as
   (select bs.doc_json.breed_species doc from breed_species bs )
SELECT json_result_doc
FROM  JSON_TABLE( (select doc from json) , '$[*].breeds.breed[*]'
           COLUMNS ( json_result_doc PATH '$.breed_name' )
);



-- Local Views on Local Table --------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW breed_species_view AS
with json as
( select bs.doc_json.breed_species doc from breed_species bs )
SELECT species_id , species_name, species_description
FROM  JSON_TABLE( (select doc from json) , '$[*]'
            COLUMNS ( species_id   PATH '$.species_id'
                    , species_name PATH '$.species_name'
                    , species_description PATH '$.species_description'
                    )
);

SELECT * FROM breed_species_view;
