CREATE TABLE Student (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Department VARCHAR(50),
    Marks INT
);


INSERT INTO Student VALUES
(1, 'SHAN', 20, 'CSE', 85),
(2, 'AMITH', 21, 'ECE', 78),
(3, 'SHARUN', 22, 'CSE', 92),
(4, 'ABHINA', 20, 'EEE', 67),
(5, 'VARSHA', 23, 'MECH', 55);


-- 1
SELECT * FROM Student;

-- 2
SELECT Name, Marks FROM Student;

-- 3
SELECT * FROM Student WHERE Marks > 80;

-- 4
SELECT * FROM Student WHERE Department = 'CSE';

-- 5
SELECT DISTINCT Department FROM Student;

-- 6
SELECT * FROM Student WHERE Marks BETWEEN 60 AND 90;

-- 7
SELECT * FROM Student WHERE Name LIKE 'A%';

-- 8
SELECT * FROM Student WHERE Age <> 20;

-- 9
SELECT * FROM Student WHERE Department IN ('CSE', 'ECE');

-- 10
SELECT * FROM Student WHERE Marks BETWEEN 70 AND 90;

-- 11
SELECT COUNT(*) FROM Student;

-- 12
SELECT AVG(Marks) FROM Student;

-- 13
SELECT MAX(Marks), MIN(Marks) FROM Student;

-- 14
SELECT Department, SUM(Marks) FROM Student GROUP BY Department;

-- 15
SELECT Department, AVG(Marks) FROM Student GROUP BY Department;

-- 16
SELECT Department, AVG(Marks)
FROM Student
GROUP BY Department
HAVING AVG(Marks) > 75;

-- 17
SELECT Department, COUNT(*)
FROM Student
GROUP BY Department
HAVING COUNT(*) > 2;

-- 18
SELECT Department, COUNT(*) FROM Student GROUP BY Department;

-- 19
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50),
    StudentID INT,
    FOREIGN KEY (StudentID) REFERENCES Student(ID)
);

INSERT INTO Course VALUES
(101, 'DBMS', 1),
(102, 'OS', 2),
(103, 'Java', 1),
(104, 'Networks', 3);

-- 20. INNER JOIN
SELECT * FROM Student s
INNER JOIN Course c ON s.ID = c.StudentID;

-- 21. LEFT JOIN
SELECT * FROM Student s
LEFT JOIN Course c ON s.ID = c.StudentID;

-- 22. RIGHT JOIN
SELECT * FROM Student s
RIGHT JOIN Course c ON s.ID = c.StudentID;

-- 23. Students not enrolled
SELECT * FROM Student
WHERE ID NOT IN (SELECT StudentID FROM Course);

-- 24. Student name with course
SELECT s.Name, c.CourseName
FROM Student s
JOIN Course c ON s.ID = c.StudentID;

-- 25. Above average marks
SELECT * FROM Student
WHERE Marks > (SELECT AVG(Marks) FROM Student);

-- 26. Second highest marks
SELECT MAX(Marks) FROM Student
WHERE Marks < (SELECT MAX(Marks) FROM Student);

-- 27. Marks = maximum
SELECT * FROM Student
WHERE Marks = (SELECT MAX(Marks) FROM Student);

-- 28. Subquery in FROM
SELECT avg_marks
FROM (SELECT AVG(Marks) AS avg_marks FROM Student) AS temp;

-- 29. Create table with PRIMARY KEY
CREATE TABLE Student_PK (ID INT PRIMARY KEY,Name VARCHAR(50));

-- 30. Add FOREIGN KEY
CREATE TABLE Department (DeptID INT PRIMARY KEY,DeptName VARCHAR(50));

CREATE TABLE Student_FK (ID INT PRIMARY KEY,Name VARCHAR(50),DeptID INT,FOREIGN KEY (DeptID) REFERENCES Department(DeptID));

-- 31. NOT NULL, UNIQUE, CHECK
CREATE TABLE ConstraintDemo (ID INT PRIMARY KEY,Name VARCHAR(50) NOT NULL,Email VARCHAR(100) UNIQUE,Age INT CHECK (Age >= 18));

-- 32. DEFAULT constraint
CREATE TABLE Student_Default (ID INT PRIMARY KEY,Name VARCHAR(50),Marks INT DEFAULT 50);

-- 33. EXISTS
SELECT Name FROM Student s
WHERE EXISTS (
    SELECT * FROM Course c WHERE s.ID = c.StudentID
);

-- NOT EXISTS
SELECT Name FROM Student s
WHERE NOT EXISTS (
    SELECT * FROM Course c WHERE s.ID = c.StudentID
);

-- 34. Create VIEW
CREATE VIEW HighMarks AS
SELECT * FROM Student WHERE Marks > 75;

-- 35. Update via VIEW
UPDATE HighMarks SET Marks = 80 WHERE ID = 1;

-- 36. Drop VIEW
DROP VIEW HighMarks;

-- 37. Create INDEX
CREATE INDEX idx_student_name ON Student(Name);

-- 38. Stored Procedure
DELIMITER //
CREATE PROCEDURE GetStudents()
BEGIN
    SELECT * FROM Student;
END //
DELIMITER ;

CALL GetStudents();

-- 39. 5th highest marks
SELECT DISTINCT Marks
FROM Student s1
WHERE 5 = (
    SELECT COUNT(DISTINCT Marks)
    FROM Student s2
    WHERE s2.Marks >= s1.Marks
);

-- 40. Find duplicates
SELECT Name, COUNT(*)
FROM Student
GROUP BY Name
HAVING COUNT(*) > 1;

-- 41. Delete duplicates (safe)
DELETE FROM Student
WHERE ID NOT IN (
    SELECT * FROM (
        SELECT MIN(ID)
        FROM Student
        GROUP BY Name
    ) AS temp
);

-- 42. Rank students
SELECT Name, Marks,
RANK() OVER (ORDER BY Marks DESC) AS RankNo
FROM Student;

-- 43. Cumulative sum
SELECT Name, Marks,
SUM(Marks) OVER (ORDER BY ID) AS RunningTotal
FROM Student;

-- 44. Function
DELIMITER //
CREATE FUNCTION GetGrade(m INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE grade VARCHAR(10);
    IF m >= 90 THEN SET grade = 'A';
    ELSEIF m >= 75 THEN SET grade = 'B';
    ELSE SET grade = 'C';
    END IF;
    RETURN grade;
END //
DELIMITER ;

-- 45. Trigger
CREATE TABLE LogTable (
    message VARCHAR(100)
);

DELIMITER //
CREATE TRIGGER after_student_insert
AFTER INSERT ON Student
FOR EACH ROW
BEGIN
    INSERT INTO LogTable VALUES ('New student inserted');
END //
DELIMITER ;