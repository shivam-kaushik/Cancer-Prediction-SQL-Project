DROP TABLE CD_Patients CASCADE CONSTRAINTS;
DROP TABLE CD_SkinImages CASCADE CONSTRAINTS;
DROP TABLE CD_LESIONS CASCADE CONSTRAINTS;
DROP TABLE CD_TreatmentPlans CASCADE CONSTRAINTS;
DROP TABLE CD_Complications CASCADE CONSTRAINTS;
DROP TABLE CD_BiopsyResults CASCADE CONSTRAINTS;
DROP TABLE CD_FollowUpVisits CASCADE CONSTRAINTS;
DROP TABLE CD_Medications CASCADE CONSTRAINTS;
DROP TABLE CD_PatientHistory CASCADE CONSTRAINTS;


--TABLES

-- Patients Table
CREATE TABLE CD_Patients (
  PatientID INT NOT NULL PRIMARY KEY ,
  Name VARCHAR2(255),
  Age INT,
  Gender CHAR(10),
  Contact_Information VARCHAR2(255)
);

-- SkinImages Table
CREATE TABLE CD_SkinImages (
  ImageID INT NOT NULL PRIMARY KEY ,
  PatientID INT NOT NULL,
  ImageName VARCHAR2(255),
  ImageDate DATE,
  ImagePath VARCHAR2(255),
  CONSTRAINT fk_SkinImages_Patients FOREIGN KEY (PatientID) REFERENCES CD_Patients(PatientID)
);

-- Lesions Table
CREATE TABLE CD_Lesions (
  LesionID INT NOT NULL PRIMARY KEY ,
  ImageID INT NOT NULL,
  LesionLocation VARCHAR2(255),
  LesionSize VARCHAR2(255),
  LesionDescription VARCHAR2(1000),
  CONSTRAINT fk_Lesions_SkinImages FOREIGN KEY (ImageID) REFERENCES CD_SkinImages(ImageID)
);

-- BiopsyResults Table
CREATE TABLE CD_BiopsyResults (
  BiopsyID INT NOT NULL PRIMARY KEY ,
  LesionID INT NOT NULL,
  BiopsyDate DATE,
  PathologistName VARCHAR2(255),
  BiopsyResult VARCHAR2(1000),
  CONSTRAINT fk_BiopsyResults_Lesions FOREIGN KEY (LesionID) REFERENCES CD_Lesions(LesionID)
);

-- TreatmentPlans Table
CREATE TABLE CD_TreatmentPlans (
  PlanID INT NOT NULL PRIMARY KEY ,
  PatientID INT NOT NULL,
  TreatmentStartDate DATE,
  TreatmentEndDate DATE,
  TreatmentType VARCHAR2(255),
  TreatmentDetails VARCHAR2(1000),
  CONSTRAINT fk_TreatmentPlans_Patients FOREIGN KEY (PatientID) REFERENCES CD_Patients(PatientID)
);

-- Medications Table
CREATE TABLE CD_Medications (
  MedicationID INT NOT NULL PRIMARY KEY ,
  PlanID INT NOT NULL,
  MedicationName VARCHAR2(255),
  Dosage VARCHAR2(255),
  Frequency VARCHAR2(255),
  CONSTRAINT fk_Medications_TreatmentPlans FOREIGN KEY (PlanID) REFERENCES CD_TreatmentPlans(PlanID)
);

-- FollowUpVisits Table
CREATE TABLE CD_FollowUpVisits (
  VisitID INT NOT NULL PRIMARY KEY ,
  PatientID INT NOT NULL,
  VisitDate DATE,
  VisitType VARCHAR2(255),
  VisitDetails VARCHAR2(1000),
  CONSTRAINT fk_FollowUpVisits_Patients FOREIGN KEY (PatientID) REFERENCES CD_Patients(PatientID)
);

-- Complications Table
CREATE TABLE CD_Complications (
  ComplicationID INT NOT NULL PRIMARY KEY ,
  VisitID INT NOT NULL,
  ComplicationDate DATE,
  ComplicationType VARCHAR2(255),
  ComplicationDetails VARCHAR2(255),
  CONSTRAINT fk_Comp_Visits FOREIGN KEY (VisitID) REFERENCES CD_FollowUpVisits(VisitID)
);

CREATE TABLE CD_PatientHistory (
  PatientHistoryID INT NOT NULL PRIMARY KEY,
  PatientID INT,
  Name VARCHAR2(255),
  Age INT,
  Gender CHAR(10),
  ContactInformation VARCHAR2(255),
  TreatmentStartDate DATE,
  TreatmentEndDate DATE,
  TreatmentType VARCHAR2(255),
  TreatmentDetails VARCHAR2(1000),
  CONSTRAINT fk_PatientHistory_PatientID FOREIGN KEY (PatientID) REFERENCES CD_Patients(PatientID)
);


--INSERT RECORDS

-- Insert data into Patients
INSERT INTO CD_Patients (PatientID, Name, Age, Gender, Contact_Information) VALUES (CD_patient_seq.NEXTVAL, 'Akash Parekh', 23, 'Male', '555-0101');
INSERT INTO CD_Patients (PatientID, Name, Age, Gender, Contact_Information) VALUES (CD_patient_seq.NEXTVAL, 'Shivam Kaushik', 23, 'Male', '555-0202');
INSERT INTO CD_Patients (PatientID, Name, Age, Gender, Contact_Information) VALUES (CD_patient_seq.NEXTVAL, 'Chintan Patel', 27, 'Male', '555-0303');
INSERT INTO CD_Patients (PatientID, Name, Age, Gender, Contact_Information) VALUES (CD_patient_seq.NEXTVAL, 'Ali Reza', 21, 'Male', '555-0404');
INSERT INTO CD_Patients (PatientID, Name, Age, Gender, Contact_Information) VALUES (CD_patient_seq.NEXTVAL, 'Monil Rupawala', 23, 'Male', '555-0505');


-- Insert data into TreatmentPlans
INSERT INTO CD_TreatmentPlans (PlanID, PatientID, TreatmentStartDate, TreatmentEndDate, TreatmentType, TreatmentDetails) VALUES (CD_plan_seq.NEXTVAL, 1, TO_DATE('2024-04-03', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Surgical', 'Excision of lesion');
INSERT INTO CD_TreatmentPlans (PlanID, PatientID, TreatmentStartDate, TreatmentEndDate, TreatmentType, TreatmentDetails) VALUES (CD_plan_seq.NEXTVAL, 2, TO_DATE('2024-04-12', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Chemotherapy', 'Administer chemotherapy drug X at a dosage of Y mg every Z days.');
INSERT INTO CD_TreatmentPlans (PlanID, PatientID, TreatmentStartDate, TreatmentEndDate, TreatmentType, TreatmentDetails) VALUES (CD_plan_seq.NEXTVAL, 3, TO_DATE('2024-04-03', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Radiation Therapy', 'High-energy beams are used to kill cancer cells');
INSERT INTO CD_TreatmentPlans (PlanID, PatientID, TreatmentStartDate, TreatmentEndDate, TreatmentType, TreatmentDetails) VALUES (CD_plan_seq.NEXTVAL, 4, TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Cryotherapy', 'Liquid nitrogen or a cold probe is used to freeze and destroy cancer cells');
INSERT INTO CD_TreatmentPlans (PlanID, PatientID, TreatmentStartDate, TreatmentEndDate, TreatmentType, TreatmentDetails) VALUES (CD_plan_seq.NEXTVAL, 5, TO_DATE('2024-04-22', 'YYYY-MM-DD'), TO_DATE('2024-05-01', 'YYYY-MM-DD'), 'Photodynamic Therapy', 'A light-sensitive drug and a light source are used to kill cancer cells');

-- Insert data into FollowUpVisits
INSERT INTO CD_FollowUpVisits (VisitID, PatientID, VisitDate, VisitType, VisitDetails) VALUES (CD_FollowUpVisits_seq.NEXTVAL, 1, TO_DATE('2024-06-21', 'YYYY-MM-DD'), 'Post-op', 'Check sutures and healing');
INSERT INTO CD_FollowUpVisits (VisitID, PatientID, VisitDate, VisitType, VisitDetails) VALUES (CD_FollowUpVisits_seq.NEXTVAL, 2, TO_DATE('2024-06-22', 'YYYY-MM-DD'), 'Routine Check-Up', 'Patient presented with no new symptoms, wound healing progressing well.');
INSERT INTO CD_FollowUpVisits (VisitID, PatientID, VisitDate, VisitType, VisitDetails) VALUES (CD_FollowUpVisits_seq.NEXTVAL, 3, TO_DATE('2024-06-03', 'YYYY-MM-DD'), 'Symptom Evaluation', 'specific symptoms or concerns related to their skin cancer diagnosis or treatment');
INSERT INTO CD_FollowUpVisits (VisitID, PatientID, VisitDate, VisitType, VisitDetails) VALUES (CD_FollowUpVisits_seq.NEXTVAL, 4, TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'Biopsy Consultation', 'discuss the need for a skin biopsy to evaluate a suspicious lesion');
INSERT INTO CD_FollowUpVisits (VisitID, PatientID, VisitDate, VisitType, VisitDetails) VALUES (CD_FollowUpVisits_seq.NEXTVAL, 5, TO_DATE('2024-06-07', 'YYYY-MM-DD'), 'Psychosocial Support', 'to address emotional and psychological challenges associated with a skin cancer diagnosis and treatment');

-- Insert data into Medications
INSERT INTO CD_Medications (MedicationID, PlanID, MedicationName, Dosage, Frequency) VALUES (CD_Medications_seq.NEXTVAL, 1, 'Acetaminophen', '500mg', 'Every 6 hours');
INSERT INTO CD_Medications (MedicationID, PlanID, MedicationName, Dosage, Frequency) VALUES (CD_Medications_seq.NEXTVAL, 2, 'Dacarbazine', '500mg', 'Every week');
INSERT INTO CD_Medications (MedicationID, PlanID, MedicationName, Dosage, Frequency) VALUES (CD_Medications_seq.NEXTVAL, 3, 'Radiation therapy creams', '500mg', 'Daily');
INSERT INTO CD_Medications (MedicationID, PlanID, MedicationName, Dosage, Frequency) VALUES (CD_Medications_seq.NEXTVAL, 4, 'Pembrolizumab', '500mg', 'Every 10 hours');
INSERT INTO CD_Medications (MedicationID, PlanID, MedicationName, Dosage, Frequency) VALUES (CD_Medications_seq.NEXTVAL, 5, 'Vismodegib', '500mg', 'Every 6 hours');

-- Insert data into Complications
INSERT INTO CD_Complications (ComplicationID, VisitID, ComplicationDate, ComplicationType, ComplicationDetails) VALUES (CD_Complications_seq.NEXTVAL, 1, TO_DATE('2024-06-12', 'YYYY-MM-DD'), 'Infection', 'Surgical site infection, prescribed antibiotics');
INSERT INTO CD_Complications (ComplicationID, VisitID, ComplicationDate, ComplicationType, ComplicationDetails) VALUES (CD_Complications_seq.NEXTVAL, 2, TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'Wound Healing Issues', 'Surgical procedures for skin cancer removal can lead to delayed wound healing or wound complications');
INSERT INTO CD_Complications (ComplicationID, VisitID, ComplicationDate, ComplicationType, ComplicationDetails) VALUES (CD_Complications_seq.NEXTVAL, 3, TO_DATE('2024-06-21', 'YYYY-MM-DD'), 'Lymphedema', 'Lymphedema is a condition characterized by swelling due to lymph fluid buildup');
INSERT INTO CD_Complications (ComplicationID, VisitID, ComplicationDate, ComplicationType, ComplicationDetails) VALUES (CD_Complications_seq.NEXTVAL, 4, TO_DATE('2024-06-22', 'YYYY-MM-DD'), 'Nerve Damage', 'Skin cancer surgeries or radiation therapy may damage nerves in the treatment area');
INSERT INTO CD_Complications (ComplicationID, VisitID, ComplicationDate, ComplicationType, ComplicationDetails) VALUES (CD_Complications_seq.NEXTVAL, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'Scarring', 'Surgical removal of skin cancer lesions can result in scarring');

-- Insert data into SkinImages
INSERT INTO CD_SkinImages (ImageID, PatientID, ImageName, ImageDate, ImagePath) VALUES (CD_SkinImages_seq.NEXTVAL, 1, 'image1.jpg', TO_DATE('2024-03-25', 'YYYY-MM-DD'), '/images/image1.jpg');
INSERT INTO CD_SkinImages (ImageID, PatientID, ImageName, ImageDate, ImagePath) VALUES (CD_SkinImages_seq.NEXTVAL, 2, 'image2.jpg', TO_DATE('2024-03-26', 'YYYY-MM-DD'), '/images/image2.jpg');
INSERT INTO CD_SkinImages (ImageID, PatientID, ImageName, ImageDate, ImagePath) VALUES (CD_SkinImages_seq.NEXTVAL, 3, 'image3.jpg', TO_DATE('2024-03-24', 'YYYY-MM-DD'), '/images/image3.jpg');
INSERT INTO CD_SkinImages (ImageID, PatientID, ImageName, ImageDate, ImagePath) VALUES (CD_SkinImages_seq.NEXTVAL, 4, 'image4.jpg', TO_DATE('2024-03-13', 'YYYY-MM-DD'), '/images/image4.jpg');
INSERT INTO CD_SkinImages (ImageID, PatientID, ImageName, ImageDate, ImagePath) VALUES (CD_SkinImages_seq.NEXTVAL, 5, 'image5.jpg', TO_DATE('2024-03-14', 'YYYY-MM-DD'), '/images/image5.jpg');

-- Insert data into Lesions
INSERT INTO CD_Lesions (LesionID, ImageID, LesionLocation, LesionSize, LesionDescription) VALUES (CD_Lesions_seq.NEXTVAL, 1, 'scalp', '2cm', 'Basal Cell Carcinoma often appear as shiny, pearly nodules or pinkish patches with rolled edges');
INSERT INTO CD_Lesions (LesionID, ImageID, LesionLocation, LesionSize, LesionDescription) VALUES (CD_Lesions_seq.NEXTVAL, 2, 'forearms', '4cm', 'red nodules or rough, scaly patches');
INSERT INTO CD_Lesions (LesionID, ImageID, LesionLocation, LesionSize, LesionDescription) VALUES (CD_Lesions_seq.NEXTVAL, 3, 'legs', '5cm', 'Melanomas often have irregular borders, asymmetrical shape, and varied colors');
INSERT INTO CD_Lesions (LesionID, ImageID, LesionLocation, LesionSize, LesionDescription) VALUES (CD_Lesions_seq.NEXTVAL, 4, 'face', '6cm', 'Actinic keratoses appear as rough, scaly, or crusty patches on the skin.');
INSERT INTO CD_Lesions (LesionID, ImageID, LesionLocation, LesionSize, LesionDescription) VALUES (CD_Lesions_seq.NEXTVAL, 5, 'Left Arm', '2cm', 'Raised, red patch');

-- Insert data into BiopsyResults
INSERT INTO CD_BiopsyResults (BiopsyID, LesionID, BiopsyDate, PathologistName, BiopsyResult) VALUES (CD_BiopsyResults_seq.NEXTVAL, 1, TO_DATE('2024-03-25', 'YYYY-MM-DD'), 'Dr. Wilson', 'Benign melanocytic nevus');
INSERT INTO CD_BiopsyResults (BiopsyID, LesionID, BiopsyDate, PathologistName, BiopsyResult) VALUES (CD_BiopsyResults_seq.NEXTVAL, 2, TO_DATE('2024-03-26', 'YYYY-MM-DD'), 'Dr. Garcia', 'Basal Cell Carcinoma');
INSERT INTO CD_BiopsyResults (BiopsyID, LesionID, BiopsyDate, PathologistName, BiopsyResult) VALUES (CD_BiopsyResults_seq.NEXTVAL, 3, TO_DATE('2024-03-24', 'YYYY-MM-DD'), 'Dr. Patel', 'Melanoma');
INSERT INTO CD_BiopsyResults (BiopsyID, LesionID, BiopsyDate, PathologistName, BiopsyResult) VALUES (CD_BiopsyResults_seq.NEXTVAL, 4, TO_DATE('2024-03-13', 'YYYY-MM-DD'), 'Dr. Nguyen', 'Dysplastic Nevi');
INSERT INTO CD_BiopsyResults (BiopsyID, LesionID, BiopsyDate, PathologistName, BiopsyResult) VALUES (CD_BiopsyResults_seq.NEXTVAL, 5, TO_DATE('2024-03-14', 'YYYY-MM-DD'), 'Dr. Johnson', 'Squamous Cell Carcinoma');
