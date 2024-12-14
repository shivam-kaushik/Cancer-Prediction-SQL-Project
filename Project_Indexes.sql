--Indexes

CREATE INDEX idx_patient_name ON CD_Patients(Name);

--SELECT * FROM CD_Patients WHERE Name = 'Alice Smith';


CREATE INDEX idx_treatment_type ON CD_TreatmentPlans(TreatmentType);

--SELECT * FROM CD_TreatmentPlans WHERE TreatmentType = 'Chemotherapy';