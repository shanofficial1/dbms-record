-- Create Tables
CREATE TABLE Customer (CustomerID INT PRIMARY KEY, Name VARCHAR(50), Address VARCHAR(100), Phone VARCHAR(15));
CREATE TABLE Branch (BranchID INT PRIMARY KEY, BranchName VARCHAR(50), Location VARCHAR(50));
CREATE TABLE Account (AccountID INT PRIMARY KEY, CustomerID INT, BranchID INT, Balance DECIMAL(10,2), AccountType VARCHAR(20), FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID), FOREIGN KEY (BranchID) REFERENCES Branch(BranchID));
CREATE TABLE Transaction (TransactionID INT PRIMARY KEY, AccountID INT, Amount DECIMAL(10,2), Type VARCHAR(20), Date DATE, FOREIGN KEY (AccountID) REFERENCES Account(AccountID));

-- Insert Data
INSERT INTO Customer VALUES (1,'Arun','Kannur','9999999999'),(2,'Anu','Kochi','8888888888'),(3,'Rahul','Calicut','7777777777');
INSERT INTO Branch VALUES (1,'Main','Kannur'),(2,'City','Kochi');
INSERT INTO Account VALUES (101,1,1,5000,'Savings'),(102,2,2,8000,'Current'),(103,3,1,3000,'Savings');
INSERT INTO Transaction VALUES (1,101,2000,'Deposit','2026-04-01'),(2,101,500,'Withdraw','2026-04-02'),(3,102,3000,'Deposit','2026-04-03');

-- 2 View all accounts
SELECT * FROM Account;

-- 3 Customer account details
SELECT c.Name,a.AccountID,a.Balance FROM Customer c JOIN Account a ON c.CustomerID=a.CustomerID;

-- 4 Transaction details
SELECT * FROM Transaction;

-- 5 Total Balance per Branch
SELECT b.BranchName,SUM(a.Balance) FROM Branch b JOIN Account a ON b.BranchID=a.BranchID GROUP BY b.BranchName;

-- 6 High Value Transactions (>1000)
SELECT * FROM Transaction WHERE Amount > 1000;

-- 7 View (multi-line)
CREATE VIEW CustomerAccountView AS
SELECT c.Name,a.AccountID,a.Balance
FROM Customer c
JOIN Account a ON c.CustomerID=a.CustomerID;

-- 8 Index on AccountID
CREATE INDEX idx_account_id ON Account(AccountID);

-- 9 Trigger (multi-line)
DELIMITER //
CREATE TRIGGER update_balance
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
IF NEW.Type='Deposit' THEN
UPDATE Account SET Balance = Balance + NEW.Amount WHERE AccountID = NEW.AccountID;
ELSE
UPDATE Account SET Balance = Balance - NEW.Amount WHERE AccountID = NEW.AccountID;
END IF;
END //
DELIMITER ;

-- 10 Top 3 customers by balance
SELECT c.Name,SUM(a.Balance) AS TotalBalance FROM Customer c JOIN Account a ON c.CustomerID=a.CustomerID GROUP BY c.Name ORDER BY TotalBalance DESC LIMIT 3;

-- 11 Balance after each transaction
SELECT t.AccountID,t.Amount,a.Balance FROM Transaction t JOIN Account a ON t.AccountID=a.AccountID;

-- 12 Accounts with no transactions
SELECT * FROM Account WHERE AccountID NOT IN (SELECT AccountID FROM Transaction);

-- 13 Detect high value transactions (>2000)
SELECT * FROM Transaction WHERE Amount > 2000;

-- 14 Monthly transaction summary
SELECT MONTH(Date) AS Month,SUM(Amount) FROM Transaction GROUP BY MONTH(Date);

-- 15 Customers with multiple accounts
SELECT CustomerID,COUNT(*) FROM Account GROUP BY CustomerID HAVING COUNT(*) > 1;

-- 16 Second highest balance
SELECT MAX(Balance) FROM Account WHERE Balance < (SELECT MAX(Balance) FROM Account);

-- 17 Rank accounts
SELECT AccountID,Balance,RANK() OVER (ORDER BY Balance DESC) AS RankNo FROM Account;

-- 18 Branch-wise average balance
SELECT BranchID,AVG(Balance) FROM Account GROUP BY BranchID;

-- 19 Customers with no withdrawals
SELECT c.Name FROM Customer c WHERE NOT EXISTS (SELECT * FROM Transaction t JOIN Account a ON t.AccountID=a.AccountID WHERE a.CustomerID=c.CustomerID AND t.Type='Withdraw');

-- 20 Transaction count per account
SELECT AccountID,COUNT(*) FROM Transaction GROUP BY AccountID;

-- 21 Latest transaction per account
SELECT * FROM Transaction t1 WHERE Date=(SELECT MAX(Date) FROM Transaction t2 WHERE t1.AccountID=t2.AccountID);

-- 22 Accounts below minimum balance (<4000)
SELECT * FROM Account WHERE Balance < 4000;

-- 23 Percentage contribution of each account
SELECT AccountID,(Balance/(SELECT SUM(Balance) FROM Account))*100 AS Percentage FROM Account;

-- 24 Sudden large withdrawals (>1000)
SELECT * FROM Transaction WHERE Type='Withdraw' AND Amount > 1000;