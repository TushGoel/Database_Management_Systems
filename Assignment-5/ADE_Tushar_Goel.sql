-- HW5: Identifying Adverse Drug Events (ADEs) with Stored Programs
-- Prof. Rachlin
-- CS 3200 / CS5200: Databases

-- We've already setup the ade database by running ade_setup.sql
-- First, make ade the active database.  Note, this database is actually based on 
-- the emr_sp schema used in the lab, but it included some extra tables.

USE ade;

-- A stored procedure to process and validate prescriptions
-- Four things we need to check
-- a) Is patient a child and is medication suitable for children?
-- b) Is patient pregnant and is medication suitable for pregnant women?
-- c) Is dosage reasonable?
-- d) Are there any adverse drug reactions

DROP PROCEDURE IF EXISTS prescribe;

delimiter //
CREATE PROCEDURE prescribe
(
	IN patient_name_param VARCHAR(255),
    IN doctor_name_param VARCHAR(255),
    IN medication_name_param VARCHAR(255),
    IN ppd_param INT
)
BEGIN
	-- variable declarations
    DECLARE patient_id_var INT;
    DECLARE age_var FLOAT;
    DECLARE is_pregnant_var BOOLEAN;
    DECLARE weight_var INT;
    DECLARE doctor_id_var INT;
    DECLARE medication_id_var INT;
    DECLARE take_under_12_var BOOLEAN;
    DECLARE take_if_pregnant_var BOOLEAN;
    DECLARE mg_per_pill_var DOUBLE;
    DECLARE max_mg_per_10kg_var DOUBLE;    
	DECLARE message VARCHAR(255); -- The error message
    DECLARE ddi_medication VARCHAR(255); -- The name of a medication involved in a drug-drug interaction
    DECLARE ppd DOUBLE; -- For calculating maximum allowable dosage i.e. max. pills per day
    -- For the conditional counting of medicine that shouldn't be taken as it can intereact with earlier prescribed medication.
    DECLARE med INT;     
    
   -- select relevant values into variables
SELECT 
	patient_id, is_pregnant, DATEDIFF(CURDATE(),dob)/365.25, (weight* 0.4536) AS 'weight_kgs' 
INTO 
    @patient_id_var, @is_pregnant_var, @age_var, @weight_var
FROM 
	patient
WHERE 
	patient_name LIKE patient_name_param;

SELECT 
	doctor_id 
INTO 
	@doctor_id_var
FROM 
	doctor
WHERE 
	doctor_name LIKE doctor_name_param;

SELECT
	medication_id, take_under_12, take_if_pregnant, mg_per_pill,  max_mg_per_10kg  
INTO 
    @medication_id_var, @take_under_12_var, @take_if_pregnant_var, @mg_per_pill_var, @max_mg_per_10kg_var 
FROM 
	medication  
WHERE 
	medication_name LIKE medication_name_param; 

SELECT 
    medication_name, COUNT(medication_2) 
INTO 
    @ddi_medication, @med
FROM 
	interaction i JOIN prescription p ON (i.medication_1=p.medication_id)
    JOIN medication m ON (p.medication_id=m.medication_id)
WHERE 
    patient_id = @patient_id_var 
    AND 
    medication_2 = @medication_id_var;

 
    -- check age of patient
    -- I did one for you! This shows how to throw an exception and set an error message.
IF (@age_var < 12 AND @take_under_12_var = FALSE) 
	THEN 
	SELECT CONCAT(medication_name_param, ' cannot be prescribed to children under 12') INTO message;
	SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = message;	
END IF;
    
    -- check if patient is pregnant or not
IF (@is_pregnant_var = TRUE AND @take_if_pregnant_var = FALSE) 
	THEN 
	SELECT CONCAT(medication_name_param, ' cannot be prescribed to pregnant women') INTO message;
	SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = message;
END IF;

    -- calculating maximum allowable dosage
    SET ppd = FLOOR((((@weight_var/10)*@max_mg_per_10kg_var)/@mg_per_pill_var));
    
    --  check dosage
IF (ppd_param > ppd) 
	THEN 
	SELECT CONCAT('Maximum dosage for ',medication_name_param,' is ', ppd, ' pills per day for patient ',patient_name_param)INTO message;
	SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = message;
END IF;

    -- Check for reactions involving medications already prescribed to patient
IF (@med <> 0) 
	THEN 
	SELECT CONCAT(medication_name_param,' interacts with ', @ddi_medication,' currently prescribed to ', patient_name_param) INTO message;
	SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = message;
END IF;
     
-- No exceptions thrown, so insert the prescription record
INSERT 
	INTO prescription 
VALUES
	(@medication_id_var, @patient_id_var, @doctor_id_var, NOW(), ppd);

END //
delimiter ;

-- Trigger

DROP TRIGGER IF EXISTS patient_after_update_pregnant;

DELIMITER //

   CREATE TRIGGER patient_after_update_pregnant 
    AFTER UPDATE ON patient
	FOR EACH ROW

BEGIN
	-- Patient became pregnant
IF (new.is_pregnant=TRUE AND old.sex='M') 
	THEN
    SIGNAL SQLSTATE 'HY000'
	SET MESSAGE_TEXT = 'Male patient cannot be pregnant!';
END IF;
    
IF (new.is_pregnant=TRUE AND old.is_pregnant=FALSE AND old.sex='F') 
	THEN
-- Add pre-natal recommenation
	INSERT 
		INTO recommendation
    VALUES
    (new.patient_id, 'Take pre-natal vitamins');
	-- Delete any prescriptions that shouldn't be taken if pregnant
	DELETE 
		FROM prescription
		WHERE 
        medication_id IN (SELECT medication_id FROM medication WHERE take_if_pregnant=FALSE) 
        AND 
		old.patient_id=prescription.patient_id;
END IF;
    
    -- Patient is no longer pregnant
IF (new.is_pregnant=FALSE AND old.is_pregnant=TRUE AND old.sex='F') 
	THEN
-- Remove pre-natal recommendation
	DELETE 
		FROM recommendation
        WHERE 
        new.patient_id= recommendation.patient_id;

END IF;
    
END //

DELIMITER ;


-- --------------------------                  TEST CASES                     -----------------------
-- -------------------------- DONT CHANGE BELOW THIS LINE! -----------------------
-- Test cases
TRUNCATE prescription;

-- These prescriptions should succeed
CALL prescribe('Jones', 'Dr.Marcus', 'Happyza', 2);
CALL prescribe('Johnson', 'Dr.Marcus', 'Forgeta', 1);
CALL prescribe('Williams', 'Dr.Marcus', 'Happyza', 1);
CALL prescribe('Phillips', 'Dr.McCoy', 'Forgeta', 1);

-- These prescriptions should fail
-- Pregnancy violation
CALL prescribe('Jones', 'Dr.Marcus', 'Forgeta', 2);

-- Age restriction
CALL prescribe('BillyTheKid', 'Dr.Marcus', 'Muscula', 1);

-- Excessive Dosage
CALL prescribe('Lee', 'Dr.Marcus', 'Foobaral', 3);

-- Drug interaction
CALL prescribe('Williams', 'Dr.Marcus', 'Sadza', 1);



-- Testing trigger
-- Phillips (patient_id=4) becomes pregnant
-- Verify that a recommendation for pre-natal vitamins is added
-- and that her prescription for 
UPDATE patient
SET is_pregnant = TRUE
WHERE patient_id = 4;

SELECT * FROM recommendation;
SELECT * FROM prescription;


-- Phillips (patient_id=4) is no longer pregnant
-- Verify that the prenatal vitamin recommendation is gone
-- Her old prescription does not need to be added back

UPDATE patient
SET is_pregnant = FALSE
WHERE patient_id = 4;

SELECT * FROM recommendation;
