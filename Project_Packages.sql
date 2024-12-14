-- PACKAGE SPECIFICATION
CREATE OR REPLACE PACKAGE CD_Medical_Info_Pkg IS
  -- Declaration of the procedure to retrieve patient information
  PROCEDURE GetPatientInfo(p_PatientID IN CD_Patients.PatientID%TYPE);
  -- Function for calculating follow-up visits for patients
  FUNCTION CD_CountFollowUpVisits(p_PatientID IN CD_Patients.PatientID%TYPE) RETURN NUMBER;
  
  FUNCTION GetLatestBiopsyResult (p_PatientID IN CD_Patients.PatientID%TYPE) RETURN VARCHAR2;
  -- Procedure for Managing the medications on the basis of operation provided
  PROCEDURE CD_ManageMedications (
    p_PlanID IN CD_Medications.PlanID%TYPE,
    p_MedicationName IN CD_Medications.MedicationName%TYPE,
    p_Dosage IN CD_Medications.Dosage%TYPE,
    p_Frequency IN CD_Medications.Frequency%TYPE,
    p_Action IN VARCHAR2
    );
    
    PROCEDURE ListPatientLatestTreatment (p_PatientID IN CD_Patients.PatientID%TYPE);
    
END CD_Medical_Info_Pkg;
/

-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY CD_Medical_Info_Pkg IS

    PROCEDURE GetPatientInfo(p_PatientID IN CD_Patients.PatientID%TYPE) IS
    v_PatientInfo CD_Patients%ROWTYPE;
    BEGIN
    SELECT *
    INTO v_PatientInfo
    FROM CD_Patients
    WHERE PatientID = p_PatientID;
    
    DBMS_OUTPUT.PUT_LINE('Patient ID: ' || v_PatientInfo.PatientID);
    DBMS_OUTPUT.PUT_LINE('Name: ' || v_PatientInfo.Name);
    DBMS_OUTPUT.PUT_LINE('Age: ' || v_PatientInfo.Age);
    DBMS_OUTPUT.PUT_LINE('Gender: ' || v_PatientInfo.Gender);
    DBMS_OUTPUT.PUT_LINE('Contact Information: ' || v_PatientInfo.Contact_Information);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No patient found with ID ' || p_PatientID);
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END GetPatientInfo;
    
    
    PROCEDURE CD_ManageMedications (
        p_PlanID IN CD_Medications.PlanID%TYPE,
        p_MedicationName IN CD_Medications.MedicationName%TYPE,
        p_Dosage IN CD_Medications.Dosage%TYPE,
        p_Frequency IN CD_Medications.Frequency%TYPE,
        p_Action IN VARCHAR2
    )
    IS
    BEGIN
        IF p_Action = 'ADD' THEN
            INSERT INTO CD_Medications (MedicationID, PlanID, MedicationName, Dosage, Frequency)
            VALUES (CD_Medications_seq.NEXTVAL, p_PlanID, p_MedicationName, p_Dosage, p_Frequency);
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Medication added successfully.');
        ELSIF p_Action = 'UPDATE' THEN
            UPDATE CD_Medications
            SET Dosage = p_Dosage,
                Frequency = p_Frequency
            WHERE PlanID = p_PlanID
            AND MedicationName = p_MedicationName;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Medication updated successfully.');
        ELSIF p_Action = 'DELETE' THEN
            DELETE FROM CD_Medications
            WHERE PlanID = p_PlanID;
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Medication deleted successfully.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Invalid action specified.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END CD_ManageMedications;
  
    
    FUNCTION CD_CountFollowUpVisits 
    (p_PatientID IN CD_Patients.PatientID%TYPE)
    RETURN NUMBER
    IS
        v_FollowUpCount NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_FollowUpCount
        FROM CD_FollowUpVisits
        WHERE PatientID = p_PatientID;
    
        RETURN v_FollowUpCount;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error: ' || SQLERRM);
    END CD_CountFollowUpVisits;
    
    FUNCTION GetLatestBiopsyResult (
      p_PatientID IN CD_Patients.PatientID%TYPE
    ) RETURN VARCHAR2
    IS
      v_biopsy_result CD_BiopsyResults.BiopsyResult%TYPE;
    BEGIN
      SELECT b.BiopsyResult INTO v_biopsy_result
      FROM CD_BiopsyResults b
      JOIN CD_Lesions l ON b.LesionID = l.LesionID
      JOIN CD_SkinImages si ON l.ImageID = si.ImageID
      WHERE si.PatientID = p_PatientID
      ORDER BY b.BiopsyDate DESC
      FETCH FIRST 1 ROW ONLY;
    
      RETURN v_biopsy_result;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN NULL;
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'An unexpected error occurred: ' || SQLERRM);
    END GetLatestBiopsyResult;

    PROCEDURE ListPatientLatestTreatment (
      p_PatientID IN CD_Patients.PatientID%TYPE
    ) IS
      -- Cursor to select a specific patient and their latest treatment plan details
      CURSOR patient_treatment_cursor IS
        SELECT p.PatientID, p.Name, p.Age, p.Gender, 
               t.TreatmentStartDate, t.TreatmentEndDate, t.TreatmentType, t.TreatmentDetails
        FROM CD_Patients p
        LEFT JOIN (
          SELECT PatientID, TreatmentStartDate, TreatmentEndDate, TreatmentType, TreatmentDetails,
                 ROW_NUMBER() OVER (PARTITION BY PatientID ORDER BY TreatmentStartDate DESC) AS rn
          FROM CD_TreatmentPlans
          WHERE PatientID = p_PatientID
        ) t ON p.PatientID = t.PatientID AND t.rn = 1
        WHERE p.PatientID = p_PatientID;
      
      patient_treatment_record patient_treatment_cursor%ROWTYPE;
    BEGIN
      OPEN patient_treatment_cursor;
      FETCH patient_treatment_cursor INTO patient_treatment_record;
      
      IF patient_treatment_cursor%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Patient ID: ' || patient_treatment_record.PatientID || 
                             ', Name: ' || patient_treatment_record.Name ||
                             ', Age: ' || patient_treatment_record.Age ||
                             ', Gender: ' || patient_treatment_record.Gender ||
                             ', Latest Treatment Start: ' || patient_treatment_record.TreatmentStartDate ||
                             ', End: ' || patient_treatment_record.TreatmentEndDate ||
                             ', Type: ' || patient_treatment_record.TreatmentType ||
                             ', Details: ' || patient_treatment_record.TreatmentDetails);
      ELSE
        DBMS_OUTPUT.PUT_LINE('No records found for PatientID: ' || p_PatientID);
      END IF;
      
      CLOSE patient_treatment_cursor;
    EXCEPTION
      WHEN OTHERS THEN
        IF patient_treatment_cursor%ISOPEN THEN
          CLOSE patient_treatment_cursor;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
    END ListPatientLatestTreatment;


END CD_Medical_Info_Pkg;
/

BEGIN
  CD_Medical_Info_Pkg.GetPatientInfo(1);
END;
/


DECLARE
    v_NumFollowUpVisits NUMBER;
BEGIN
    v_NumFollowUpVisits := CD_CountFollowUpVisits(1); 
    DBMS_OUTPUT.PUT_LINE('Number of follow-up visits: ' || v_NumFollowUpVisits);
END;
/

BEGIN
    CD_ManageMedications(2, 'Aspirin', '100mg', 'Once daily', 'UPDATE');
END;
/

DECLARE
  v_biopsy_result VARCHAR2(4000);
BEGIN
  v_biopsy_result := GetLatestBiopsyResult(1);
  DBMS_OUTPUT.PUT_LINE('Latest Biopsy Result: ' || NVL(v_biopsy_result, 'No result found.'));
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

BEGIN
  ListPatientLatestTreatment(p_PatientID => 1);
END;
/

