-- Create DB & Tables
CREATE DATABASE LibraryDB; USE LibraryDB;
CREATE TABLE Book (BookID INT PRIMARY KEY, Title VARCHAR(100), Author VARCHAR(50), Publisher VARCHAR(50), AvailableCopies INT);
CREATE TABLE Member (MemberID INT PRIMARY KEY, Name VARCHAR(50), Department VARCHAR(50), Phone VARCHAR(15));
CREATE TABLE Issue (IssueID INT PRIMARY KEY, BookID INT, MemberID INT, IssueDate DATE, ReturnDate DATE, FOREIGN KEY (BookID) REFERENCES Book(BookID), FOREIGN KEY (MemberID) REFERENCES Member(MemberID));
CREATE TABLE Fine (FineID INT PRIMARY KEY, IssueID INT, Amount DECIMAL(10,2), FOREIGN KEY (IssueID) REFERENCES Issue(IssueID));

-- 1 Insert
INSERT INTO Book VALUES (1,'DBMS','Korth','Pearson',5),(2,'OS','Galvin','Wiley',3),(3,'Java','James','Oracle',4);
INSERT INTO Member VALUES (1,'Arun','CSE','9999'),(2,'Anu','ECE','8888'),(3,'Rahul','CSE','7777');
INSERT INTO Issue VALUES (101,1,1,'2026-04-01','2026-04-10'),(102,2,2,'2026-04-05','2026-04-20'),(103,1,3,'2026-04-07',NULL);
INSERT INTO Fine VALUES (1,102,50);

-- 2
SELECT * FROM Book;

-- 3
SELECT m.Name,b.Title,i.IssueDate FROM Issue i JOIN Book b ON i.BookID=b.BookID JOIN Member m ON i.MemberID=m.MemberID;

-- 4
SELECT * FROM Issue WHERE ReturnDate > IssueDate + INTERVAL 7 DAY;

-- 5
SELECT SUM(Amount) AS TotalFine FROM Fine;

-- 6
SELECT * FROM Book WHERE AvailableCopies>0;

-- 7 (VIEW multi-line)
CREATE VIEW IssuedView AS SELECT m.Name,b.Title,i.IssueDate FROM Member m JOIN Issue i ON m.MemberID=i.MemberID JOIN Book b ON i.BookID=b.BookID;

SELECT * FROM IssuedView;

-- 8 (TRIGGER multi-line)
DELIMITER //
CREATE TRIGGER issue_book AFTER INSERT ON Issue FOR EACH ROW BEGIN UPDATE Book SET AvailableCopies=AvailableCopies-1 WHERE BookID=NEW.BookID; END //
DELIMITER ;

-- 9
CREATE INDEX idx_title ON Book(Title);

-- 10
SELECT BookID,COUNT(*) AS IssueCount,RANK() OVER (ORDER BY COUNT(*) DESC) AS RankNo FROM Issue GROUP BY BookID;

-- 11
SELECT BookID,COUNT(*) AS IssueCount FROM Issue GROUP BY BookID ORDER BY IssueCount DESC LIMIT 3;

-- 12
SELECT MemberID,COUNT(*) AS TotalBooks FROM Issue GROUP BY MemberID;

-- 13
SELECT * FROM Issue i1 WHERE IssueDate=(SELECT MAX(IssueDate) FROM Issue i2 WHERE i1.MemberID=i2.MemberID);

-- 14
SELECT MemberID,COUNT(*) FROM Issue GROUP BY MemberID HAVING COUNT(*)>1;

-- 15
SELECT MemberID,COUNT(*) AS TotalBooks,RANK() OVER (ORDER BY COUNT(*) DESC) FROM Issue GROUP BY MemberID;

-- 16
SELECT * FROM Issue i1 WHERE IssueDate=(SELECT MIN(IssueDate) FROM Issue i2 WHERE i1.BookID=i2.BookID);

-- 17
SELECT BookID,MONTH(IssueDate),COUNT(*) FROM Issue GROUP BY BookID,MONTH(IssueDate) HAVING COUNT(*)>1;

-- 18
SELECT BookID,(COUNT(*)/(SELECT COUNT(*) FROM Issue))*100 AS Contribution FROM Issue GROUP BY BookID;

-- 19
SELECT IssueID,DATEDIFF(CURDATE(),IssueDate) AS Days,RANK() OVER (ORDER BY DATEDIFF(CURDATE(),IssueDate) DESC) FROM Issue WHERE ReturnDate IS NULL;

-- 20
SELECT BookID,MAX(ReturnDate) FROM Issue GROUP BY BookID;

-- 21
SELECT MemberID,COUNT(*) FROM Issue GROUP BY MemberID ORDER BY COUNT(*) DESC;

-- 22
SELECT BookID,AvailableCopies,DENSE_RANK() OVER (ORDER BY AvailableCopies DESC) FROM Book;