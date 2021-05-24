--DROP VIEW OLAP_FACTS_Prescription_AMOUNT;



CREATE OR REPLACE VIEW OLAP_FACTS_Prescription_AMOUNT AS
SELECT p.pet_id, pre.medication, i.invoice_date 
    , SUM(pre.amount * pre.unit_price) as AMOUNT
FROM invoice i 
    INNER JOIN prescription pre ON i.invoice_id =  pre.invoice_invoice_id
    INNER JOIN medical_record md ON pre.medical_record_id = md.record_id
    INNER JOIN pet p ON md.pet_pet_id = p.pet_id
GROUP BY p.pet_id, pre.medication, i.invoice_date;








--------------------------------------------------------------------------------

--------------------------------------------------------------------------------


--DROP VIEW OLAP_DIM_Pet_MRecord_Invoice;


CREATE OR REPLACE VIEW OLAP_DIM_Pet_MRecord_Invoice AS
SELECT 
    p.pet_id as pet_id, p.pet_name as pet_name, -- L1
    md.record_id as record_id, md.record_comments as record_comments, -- L2
    i.invoice_id as invoice_id, i.invoice_amount as invoice_amount -- L3
FROM pet p
    INNER JOIN medical_record md ON p.pet_id = md.pet_pet_id
    INNER JOIN prescription pre ON md.record_id = pre.medical_record_id
    INNER JOIN invoice i ON i.invoice_id = pre.invoice_invoice_id
;



--------------------------------------------------------------------------------
--- D2: CUST_CTG_TO
--------------------------------------------------------------------------------

--DROP VIEW OLAP_DIM_Specie_Pet;


CREATE OR REPLACE VIEW OLAP_DIM_Specie_Pet AS
SELECT 
    p.pet_id as pet_id, p.pet_name as pet_name, -- L1
    s.species_id as species_id, s.species_name as species_name
FROM pet p
    INNER JOIN species s ON s.species_id=p.species_species_id;



--------------------------------------------------------------------------------
-- D3: owner-pet
--------------------------------------------------------------------------------
--DROP VIEW OLAP_DIM_Owner_pet;


CREATE OR REPLACE VIEW OLAP_DIM_Owner_pet AS
SELECT 
    p.pet_id as pet_id, p.pet_name as pet_name, -- L1
    o.owner_id as owner_id, o.owner_name as owner_name
FROM pet p
    INNER JOIN owner o ON o.owner_id=p.owner_owner_id;







--rollup

--DROP VIEW OLAP_VIEW_Amount_Pet_MR_Inv;


CREATE OR REPLACE VIEW OLAP_VIEW_Amount_Pet_MR_Inv AS
SELECT 
CASE
    WHEN GROUPING(p.invoice_id) = 1 THEN '{Total General}'
    ELSE to_char(p.invoice_id) END AS invoice_id,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN 'subtotal invoice ' || p.invoice_id
    ELSE to_char(p.record_comments) END AS record_comments,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN ' '
    WHEN GROUPING(p.pet_name) = 1 THEN 'subtotal m record ' || p.record_comments
    ELSE to_char(p.pet_name) END AS pet_name,    
  SUM(NVL(f.AMOUNT, 0)) as AMOUNT    
FROM OLAP_DIM_Pet_MRecord_Invoice p
    INNER JOIN OLAP_FACTS_Prescription_AMOUNT f ON p.pet_id = F.pet_id
GROUP BY ROLLUP (p.invoice_id, p.record_comments, p.pet_name)
ORDER BY p.invoice_id, p.record_comments, p.pet_name;





----cube

----DROP VIEW OLAP_VIEW_Amo_Pet_MR_Inv_c;


CREATE OR REPLACE VIEW OLAP_VIEW_Amo_Pet_MR_Inv_c AS
SELECT 
CASE
    WHEN GROUPING(p.invoice_id) = 1 THEN '{Total General}'
    ELSE to_char(p.invoice_id) END AS invoice_id,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN 'subtotal invoice ' || p.invoice_id
    ELSE to_char(p.record_comments) END AS record_comments,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN ' '
    WHEN GROUPING(p.pet_name) = 1 THEN 'subtotal m record ' || p.record_comments
    ELSE to_char(p.pet_name) END AS pet_name,    
  SUM(NVL(f.AMOUNT, 0)) as AMOUNT    
FROM OLAP_DIM_Pet_MRecord_Invoice p
    INNER JOIN OLAP_FACTS_Prescription_AMOUNT f ON p.pet_id = F.pet_id
GROUP BY cube (p.invoice_id, p.record_comments, p.pet_name)
ORDER BY p.invoice_id, p.record_comments, p.pet_name;





---- partial cube

----DROP VIEW OLAP_VIEW_Amo_Pet_MR_Inv_cp;


CREATE OR REPLACE VIEW OLAP_VIEW_Amo_Pet_MR_Inv_cp AS
SELECT 
CASE
    WHEN GROUPING(p.invoice_id) = 1 THEN '{Total General}'
    ELSE to_char(p.invoice_id) END AS invoice_id,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN 'subtotal invoice ' || p.invoice_id
    ELSE to_char(p.record_comments) END AS record_comments,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN ' '
    WHEN GROUPING(p.pet_name) = 1 THEN 'subtotal m record ' || p.record_comments
    ELSE to_char(p.pet_name) END AS pet_name,    
  SUM(NVL(f.AMOUNT, 0)) as AMOUNT    
FROM OLAP_DIM_Pet_MRecord_Invoice p
    INNER JOIN OLAP_FACTS_Prescription_AMOUNT f ON p.pet_id = F.pet_id
GROUP BY cube (p.invoice_id, (p.record_comments, p.pet_name))
ORDER BY p.invoice_id, p.record_comments, p.pet_name;




---- GROUPING SETS


----DROP VIEW OLAP_VIEW_Amo_Pet_MR_Inv_gs;


CREATE OR REPLACE VIEW OLAP_VIEW_Amo_Pet_MR_Inv_gs AS
SELECT 
CASE
    WHEN GROUPING(p.invoice_id) = 1 THEN '{Total General}'
    ELSE to_char(p.invoice_id) END AS invoice_id,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN 'subtotal invoice ' || p.invoice_id
    ELSE to_char(p.record_comments) END AS record_comments,
  CASE 
    WHEN GROUPING(p.invoice_id) = 1 THEN ' '
    WHEN GROUPING(p.record_comments) = 1 THEN ' '
    WHEN GROUPING(p.pet_name) = 1 THEN 'subtotal m record ' || p.record_comments
    ELSE to_char(p.pet_name) END AS pet_name,    
  SUM(NVL(f.AMOUNT, 0)) as AMOUNT    
FROM OLAP_DIM_Pet_MRecord_Invoice p
    INNER JOIN OLAP_FACTS_Prescription_AMOUNT f ON p.pet_id = F.pet_id
GROUP BY GROUPING SETS (p.invoice_id, (p.record_comments, p.pet_name), ())
ORDER BY p.invoice_id, p.record_comments, p.pet_name;
