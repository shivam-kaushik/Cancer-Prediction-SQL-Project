--Triggers

CREATE OR REPLACE TRIGGER trg_check_duplicate_medication
BEFORE INSERT ON CD_Medications
FOR EACH ROW
DECLARE
  medication_count INT;
BEGIN
  SELECT COUNT(*)
  INTO medication_count
  FROM CD_Medications
  WHERE UPPER(MedicationName) = UPPER(:new.MedicationName)
  AND PlanID = :new.PlanID;

  IF medication_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Duplicate medication for the same treatment plan is not allowed.');
  END IF;
END;
/

select * from CD_Medications;

INSERT INTO CD_Medications (MedicationID, PlanID, MedicationName, Dosage, Frequency) VALUES (CD_Medications_seq.NEXTVAL, 1, 'Acetaminophen', '500mg', 'Every 6 hours');



CREATE OR REPLACE TRIGGER TRG_CD_PatientHistoryLog
AFTER INSERT OR UPDATE ON CD_Patients
FOR EACH ROW
DECLARE
  v_TreatmentStartDate DATE;
  v_TreatmentEndDate DATE;
  v_TreatmentType VARCHAR2(255);
  v_TreatmentDetails VARCHAR2(1000);
BEGIN
  SELECT TreatmentStartDate, TreatmentEndDate, TreatmentType, TreatmentDetails
  INTO v_TreatmentStartDate, v_TreatmentEndDate, v_TreatmentType, v_TreatmentDetails
  FROM CD_TreatmentPlans
  WHERE PatientID = :NEW.PatientID
  ORDER BY TreatmentStartDate DESC
  FETCH FIRST 1 ROW ONLY;
  
  -- Insert a record into CD_PatientHistory
  INSERT INTO CD_PatientHistory (
    PatientHistoryID,
    PatientID,
    Name,
    Age,
    Gender,
    ContactInformation,
    TreatmentStartDate,
    TreatmentEndDate,
    TreatmentType,
    TreatmentDetails
  ) VALUES (
    CD_PatientHistory_seq.NEXTVAL,
    :NEW.PatientID,
    :NEW.Name,
    :NEW.Age,
    :NEW.Gender,
    :NEW.Contact_Information,
    v_TreatmentStartDate,
    v_TreatmentEndDate,
    v_TreatmentType,
    v_TreatmentDetails
  );

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    -- Handle case where no treatment plan is found; possibly insert a partial record or raise an error
    DBMS_OUTPUT.PUT_LINE('No treatment plan found for patient with ID: ' || :NEW.PatientID);
  WHEN OTHERS THEN
    -- Handle any other exceptions
    DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END TRG_CD_PatientHistoryLog;
/

UPDATE CD_Patients
SET Age = 32
WHERE PatientID = 1;

Select * from CD_PatientHistory;

CREATE OR REPLACE TRIGGER trg_check_patient_age
BEFORE INSERT OR UPDATE ON CD_Patients
FOR EACH ROW
BEGIN
  IF :NEW.Age > 90 THEN
    RAISE_APPLICATION_ERROR(-20000, 'Unusually high age specified for patient. Operation aborted.');
  END IF;
END;
/

UPDATE CD_Patients
SET Age = 100
WHERE PatientID = 1;

