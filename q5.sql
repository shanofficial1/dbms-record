-- Create DB & Tables
CREATE DATABASE HospitalDB; USE HospitalDB;
CREATE TABLE Patient (PatientID INT PRIMARY KEY, Name VARCHAR(50), Age INT, Gender VARCHAR(10), Phone VARCHAR(15));
CREATE TABLE Doctor (DoctorID INT PRIMARY KEY, Name VARCHAR(50), Specialization VARCHAR(50));
CREATE TABLE Appointment (AppID INT PRIMARY KEY, PatientID INT, DoctorID INT, Date DATE, FOREIGN KEY (PatientID) REFERENCES Patient(PatientID), FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID));
CREATE TABLE Treatment (TreatmentID INT PRIMARY KEY, AppID INT, Diagnosis VARCHAR(100), Cost DECIMAL(10,2), FOREIGN KEY (AppID) REFERENCES Appointment(AppID));

-- Insert Data
INSERT INTO Patient VALUES (1,'Arun',22,'M','9999'),(2,'Anu',21,'F','8888'),(3,'Rahul',23,'M','7777');
INSERT INTO Doctor VALUES (1,'Dr.A','Cardio'),(2,'Dr.B','Ortho');
INSERT INTO Appointment VALUES (101,1,1,'2026-04-01'),(102,2,2,'2026-04-02'),(103,1,2,'2026-04-03');
INSERT INTO Treatment VALUES (1,101,'Heart',3000),(2,102,'Bone',2000),(3,103,'Checkup',1500);

-- 1
SELECT * FROM Patient;

-- 2
SELECT p.Name,d.Name,t.Diagnosis,t.Cost FROM Patient p JOIN Appointment a ON p.PatientID=a.PatientID JOIN Doctor d ON a.DoctorID=d.DoctorID JOIN Treatment t ON a.AppID=t.AppID;

-- 3
SELECT SUM(Cost) AS TotalRevenue FROM Treatment;

-- 4
SELECT DISTINCT p.Name FROM Patient p JOIN Appointment a ON p.PatientID=a.PatientID WHERE a.DoctorID=1;

-- 5
SELECT MAX(Cost) FROM Treatment;

-- 6 VIEW
CREATE VIEW HighCostTreatment AS SELECT * FROM Treatment WHERE Cost>2500;
SELECT * FROM HighCostTreatment;

-- 7 TRIGGER
DELIMITER //
CREATE TRIGGER check_cost BEFORE INSERT ON Treatment FOR EACH ROW BEGIN IF NEW.Cost<0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Negative cost not allowed'; END IF; END //
DELIMITER ;

-- 8
CREATE INDEX idx_patient_name ON Patient(Name);

-- 9
SELECT DoctorID,COUNT(*) AS PatientCount FROM Appointment GROUP BY DoctorID ORDER BY PatientCount DESC LIMIT 3;

-- 10
SELECT p.Name,SUM(t.Cost) AS TotalCost FROM Patient p JOIN Appointment a ON p.PatientID=a.PatientID JOIN Treatment t ON a.AppID=t.AppID GROUP BY p.Name;

-- 11
SELECT p.Name,MAX(t.Cost) FROM Patient p JOIN Appointment a ON p.PatientID=a.PatientID JOIN Treatment t ON a.AppID=t.AppID GROUP BY p.Name;

-- 12
SELECT p.Name,t.Cost FROM Patient p JOIN Appointment a ON p.PatientID=a.PatientID JOIN Treatment t ON a.AppID=t.AppID WHERE t.Cost>(SELECT AVG(Cost) FROM Treatment);

-- 13
SELECT d.Name,AVG(t.Cost) FROM Doctor d JOIN Appointment a ON d.DoctorID=a.DoctorID JOIN Treatment t ON a.AppID=t.AppID GROUP BY d.Name;

-- 14
SELECT t1.AppID,t1.Cost,LAG(t1.Cost) OVER (ORDER BY t1.AppID) AS PrevCost FROM Treatment t1;

-- 15
SELECT Date,COUNT(*) FROM Appointment GROUP BY Date;

-- 16
SELECT * FROM Doctor WHERE DoctorID NOT IN (SELECT DoctorID FROM Appointment);

-- 17
SELECT p.Name,SUM(t.Cost) AS Total,RANK() OVER (ORDER BY SUM(t.Cost) DESC) FROM Patient p JOIN Appointment a ON p.PatientID=a.PatientID JOIN Treatment t ON a.AppID=t.AppID GROUP BY p.Name;

-- 18
SELECT PatientID,COUNT(*) FROM Appointment GROUP BY PatientID HAVING COUNT(*)>1;

-- 19
SELECT * FROM Appointment a1 WHERE Date=(SELECT MAX(Date) FROM Appointment a2 WHERE a1.PatientID=a2.PatientID);

-- 20
SELECT d.Name,(COUNT(a.AppID)/(SELECT COUNT(*) FROM Appointment))*100 AS Contribution FROM Doctor d LEFT JOIN Appointment a ON d.DoctorID=a.DoctorID GROUP BY d.Name;