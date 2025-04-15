create database Group8PayrollManagementSystem;
use Group8PayrollManagementSystem;
select database();

-- CREATE SCRIPTS
-- Create Scipt for Tables for Payroll Management System
-- Table defining job roles within the organization
CREATE TABLE JobRole (
    JobRoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(100),
    Description VARCHAR(255)
);

-- Table to store employee personal and job-related information
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeName VARCHAR(100),
    DepartmentName VARCHAR(250),
    JobRoleID INT,
    SalaryType ENUM('Fixed', 'Hourly'),
    FOREIGN KEY (JobRoleID) REFERENCES JobRole(JobRoleID)
);

-- Table to store details of fixed-salary employees
CREATE TABLE FixedSalary (
    FixedSalaryID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    MonthlySalary DECIMAL(10,2),
    EffectiveDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Table to track hourly wage details for hourly employees
CREATE TABLE HourlySalary (
    HourlySalaryID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    HourlyRate DECIMAL(10,2),
    EffectiveDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Table for recording daily attendance including hours worked
CREATE TABLE Attendance (
    AttendanceID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    AttendanceDate DATE,
    HoursWorked DECIMAL(4,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Table containing details of benefits allocated to employees
CREATE TABLE Benefits (
    BenefitID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    BenefitType VARCHAR(100),
    Contribution DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Table containing details of benefits allocated to employees
CREATE TABLE Bonuses (
    BonusID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    BonusAmount DECIMAL(10,2) NOT NULL,
    BonusReason TEXT,
    BonusDate DATE NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Table to store deductions for employees
CREATE TABLE Deductions (
    DeductionID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    DeductionType ENUM('Loan', 'Health Insurance', 'Other'),
    DeductionAmount DECIMAL(10,2),
    DeductionDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Table to manage payroll records including salary computations
CREATE TABLE Payroll (
    PayrollID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    PayPeriodStart DATE NOT NULL,
    PayPeriodEnd DATE NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

-- Table to record payment transactions linked to payroll
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    PayrollID INT,
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    TransactionReference VARCHAR(100),
    FOREIGN KEY (PayrollID) REFERENCES Payroll(PayrollID)
);

-- Table to store user login credentials and access details
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    Username VARCHAR(50),
    PasswordHash VARCHAR(255),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Table to record generated reports information
CREATE TABLE Reports (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    ReportType VARCHAR(50),
    GeneratedDate DATE,
    GeneratedBy INT,
    ReportLocation VARCHAR(255),
    FOREIGN KEY (GeneratedBy) REFERENCES Users(UserID)
);

-- Audit log table to record system activities for compliance and security
CREATE TABLE AuditLog (
    AuditID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    Action VARCHAR(255),
    ActionTimestamp DATETIME,
    IPAddress VARCHAR(45),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Table to record miscellaneous information
CREATE TABLE Miscellaneous (
    MiscellaneousID INT PRIMARY KEY AUTO_INCREMENT,
    MiscellaneousName VARCHAR(255),
    MiscellaneousValue VARCHAR(255)
);

-- INSERT SCRIPTS
-- Insert Scipt for Tables for Payroll Management System
-- Different JobRoles in Organization Details
INSERT INTO JobRole (RoleName, Description)
VALUES ('Software Engineer', 'Responsible for software development'),
('HR Manager', 'Oversees HR functions and payroll processing');

-- Employees: Fixed and Hourly salary types
INSERT INTO Employee (EmployeeName, JobRoleID, SalaryType)
VALUES ('John Doe','Engineering', 1, 'Fixed'),
('Jane Smith','Human Resources', 2, 'Hourly');

-- Fixed Salary Employee Details
INSERT INTO FixedSalary (EmployeeID, MonthlySalary, EffectiveDate)
VALUES (1, 5000.00, '2025-01-01');

-- Hourly Salary Employee Details
INSERT INTO HourlySalary (EmployeeID, HourlyRate, EffectiveDate)
VALUES (2, 25.00, '2025-01-01');

-- Attendance: Employee with 100% attendance
INSERT INTO Attendance (EmployeeID, AttendanceDate, HoursWorked)
VALUES (1, '2025-03-01', 8.0),
(1, '2025-03-02', 8.0),
-- Continue inserting for each working day of the month
(1, '2025-03-31', 8.0);

-- Attendance Employee with less than 100% attendance
INSERT INTO Attendance (EmployeeID, AttendanceDate, HoursWorked)
VALUES (2, '2025-03-01', 8.0),
(2, '2025-03-02', 0), -- absent
(2, '2025-03-03', 6.0),
-- continue similarly for each working day
(2, '2025-03-31', 8.0);

-- Employee who has Benefits
INSERT INTO Benefits (EmployeeID, BenefitType, Contribution, StartDate, EndDate)
VALUES (1, 'Health Insurance', 200.00, '2025-01-01', '2025-12-31'),
(1, 'Retirement Plan', 150.00, '2025-01-01', '2025-12-31'),
(2, 'Health Insurance', 100.00, '2025-01-01', '2025-12-31');
-- Employee who doesn't have Benefits
-- No insert needed; simply don't add records for EmployeeID = 2 into Benefits table.

-- Insert dummy data into Bonuses table
INSERT INTO Bonuses (EmployeeID, BonusReason, BonusAmount, BonusDate) VALUES
(1, 'Performance Bonus', 500.00, '2025-01-15'),
(2, 'Holiday Bonus', 150.00, '2025-02-20'),
(1, 'Performance Bonus', 1000.00, '2025-03-31');

-- Insert dummy data into Deductions table
INSERT INTO Deductions (EmployeeID, DeductionType, DeductionAmount, DeductionDate)
VALUES (1, 'Loan', 150.00, '2025-03-31'),
(2, 'Loan', 100.00, '2025-03-31'),
(1, 'Health Insurance', 200.00, '2025-03-31'),
(2, 'Health Insurance', 100.00, '2025-03-31'),
(1, 'Other', 50.00, '2025-03-31'),
(2, 'Other', 75.00, '2025-03-31');

-- Payroll Records for Employees
INSERT INTO Payroll (EmployeeID, PayPeriodStart, PayPeriodEnd)
VALUES (1, '2025-03-01', '2025-03-31'),
(2, '2025-03-01', '2025-03-31');

-- Payment records linked to Payroll
INSERT INTO Payments (PayrollID, PaymentDate, PaymentMethod, TransactionReference)
VALUES (1, '2025-04-05', 'Bank Transfer', 'TX123456789'),
(2, '2025-04-05', 'Check', 'CHK987654321');

-- User records for login
INSERT INTO Users (EmployeeID, Username, PasswordHash)
VALUES (1, 'johndoe', 'hashedpassword1'),
(2, 'janesmith', 'hashedpass123');

-- Generated Reports records
INSERT INTO Reports (ReportType, GeneratedDate, GeneratedBy, ReportLocation)
VALUES ('Monthly Payroll', '2025-04-05', 1, '/reports/april_payroll.pdf'),
('Benefits Summary', '2025-04-05', 1, '/reports/april_benefits.pdf');

-- Audit logs recording user actions
INSERT INTO AuditLog (UserID, Action, ActionTimestamp, IPAddress)
VALUES (1, 'Processed payroll for March', NOW(), '192.168.1.10'),
(2, 'Viewed payroll report', '2025-04-05 09:00:00', '192.168.1.10');

-- Insert Miscellaneous values
INSERT INTO Miscellaneous (MiscellaneousName, MiscellaneousValue)
VALUES ('TaxRate', '0.1'),
('OvertimePayRate', '1.5');

-- CREATE VIEW SCRIPTS
-- Create view for payroll with dynamic calculations 
CREATE OR REPLACE VIEW PayrollView AS
SELECT 
    p.PayrollID,
    p.EmployeeID,
    p.PayPeriodStart,
    p.PayPeriodEnd,

    -- Auto calculate BaseSalary based on Employee Salary Type and round it
    CONCAT('$', ROUND(
        CASE 
            WHEN e.SalaryType = 'Fixed' 
            THEN (SELECT f.MonthlySalary FROM FixedSalary f WHERE f.EmployeeID = e.EmployeeID ORDER BY f.EffectiveDate DESC LIMIT 1)
            ELSE (SELECT SUM(a.HoursWorked * h.HourlyRate) 
                  FROM Attendance a 
                  JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                  WHERE a.EmployeeID = e.EmployeeID 
                    AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd)
        END, 2
    )) AS BaseSalary,

    -- Auto calculate Overtime Pay using fetched OvertimePayRate and round it
    CONCAT('$', ROUND(
        COALESCE((SELECT SUM((a.HoursWorked - 8) * h.HourlyRate * 
                             (SELECT CAST(MiscellaneousValue AS DECIMAL(5,2)) 
                              FROM Miscellaneous WHERE MiscellaneousName = 'OvertimePayRate')) 
                  FROM Attendance a 
                  JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                  WHERE a.EmployeeID = e.EmployeeID 
                    AND a.HoursWorked > 8 
                    AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0), 
        2
    )) AS OvertimePay,

    -- Auto calculate Bonus Amount and round it
    CONCAT('$', ROUND(
        COALESCE((SELECT SUM(b.BonusAmount) 
                  FROM Bonuses b 
                  WHERE b.EmployeeID = e.EmployeeID 
                    AND b.BonusDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0), 
        2
    )) AS BonusAmount,

    -- Auto calculate Other Deductions from the Deductions table (excluding tax) and round it
    CONCAT('$', ROUND(
        COALESCE((SELECT SUM(d.DeductionAmount) 
                  FROM Deductions d 
                  WHERE d.EmployeeID = e.EmployeeID 
                    AND d.DeductionType <> 'Tax' 
                    AND d.DeductionDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0), 
        2
    )) AS TotalDeductions,

    -- Auto calculate GrossPay (Base Salary + Overtime Pay + Bonus - Total Deductions) and round it
    CONCAT('$', ROUND(
        (
            COALESCE((SELECT f.MonthlySalary FROM FixedSalary f WHERE f.EmployeeID = e.EmployeeID ORDER BY f.EffectiveDate DESC LIMIT 1), 
                     (SELECT SUM(a.HoursWorked * h.HourlyRate) 
                      FROM Attendance a 
                      JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                      WHERE a.EmployeeID = e.EmployeeID 
                        AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
            + COALESCE((SELECT SUM((a.HoursWorked - 8) * h.HourlyRate * 
                                   (SELECT CAST(MiscellaneousValue AS DECIMAL(5,2)) 
                                    FROM Miscellaneous WHERE MiscellaneousName = 'OvertimePayRate')) 
                        FROM Attendance a 
                        JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                        WHERE a.EmployeeID = e.EmployeeID 
                          AND a.HoursWorked > 8 
                          AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
            + COALESCE((SELECT SUM(b.BonusAmount) 
                        FROM Bonuses b 
                        WHERE b.EmployeeID = e.EmployeeID 
                          AND b.BonusDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
            - COALESCE((SELECT SUM(d.DeductionAmount) 
                        FROM Deductions d 
                        WHERE d.EmployeeID = e.EmployeeID 
                          AND d.DeductionType <> 'Tax' 
                          AND d.DeductionDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
        ), 2
    )) AS GrossPay,
    
    CONCAT('$', ROUND(
        (
            (
                COALESCE((SELECT f.MonthlySalary FROM FixedSalary f WHERE f.EmployeeID = e.EmployeeID ORDER BY f.EffectiveDate DESC LIMIT 1), 
                         (SELECT SUM(a.HoursWorked * h.HourlyRate) 
                          FROM Attendance a 
                          JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                          WHERE a.EmployeeID = e.EmployeeID 
                            AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
                + COALESCE((SELECT SUM((a.HoursWorked - 8) * h.HourlyRate * 
                                       (SELECT CAST(MiscellaneousValue AS DECIMAL(5,2)) 
                                        FROM Miscellaneous WHERE MiscellaneousName = 'OvertimePayRate')) 
                            FROM Attendance a 
                            JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                            WHERE a.EmployeeID = e.EmployeeID 
                              AND a.HoursWorked > 8 
                              AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
                + COALESCE((SELECT SUM(b.BonusAmount) 
                            FROM Bonuses b 
                            WHERE b.EmployeeID = e.EmployeeID 
                              AND b.BonusDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
                - COALESCE((SELECT SUM(d.DeductionAmount) 
                            FROM Deductions d 
                            WHERE d.EmployeeID = e.EmployeeID 
                              AND d.DeductionType <> 'Tax' 
                              AND d.DeductionDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
            ) * ((SELECT CAST(MiscellaneousValue AS DECIMAL(5,2)) 
                      FROM Miscellaneous WHERE MiscellaneousName = 'TaxRate'))
        ), 2
    )) AS Tax,

    -- Auto calculate Net Pay using new formula: NetPay = GrossPay * (1 - TaxRate) and round it
    CONCAT('$', ROUND(
        (
            (
                COALESCE((SELECT f.MonthlySalary FROM FixedSalary f WHERE f.EmployeeID = e.EmployeeID ORDER BY f.EffectiveDate DESC LIMIT 1), 
                         (SELECT SUM(a.HoursWorked * h.HourlyRate) 
                          FROM Attendance a 
                          JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                          WHERE a.EmployeeID = e.EmployeeID 
                            AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
                + COALESCE((SELECT SUM((a.HoursWorked - 8) * h.HourlyRate * 
                                       (SELECT CAST(MiscellaneousValue AS DECIMAL(5,2)) 
                                        FROM Miscellaneous WHERE MiscellaneousName = 'OvertimePayRate')) 
                            FROM Attendance a 
                            JOIN HourlySalary h ON a.EmployeeID = h.EmployeeID
                            WHERE a.EmployeeID = e.EmployeeID 
                              AND a.HoursWorked > 8 
                              AND a.AttendanceDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
                + COALESCE((SELECT SUM(b.BonusAmount) 
                            FROM Bonuses b 
                            WHERE b.EmployeeID = e.EmployeeID 
                              AND b.BonusDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
                - COALESCE((SELECT SUM(d.DeductionAmount) 
                            FROM Deductions d 
                            WHERE d.EmployeeID = e.EmployeeID 
                              AND d.DeductionType <> 'Tax' 
                              AND d.DeductionDate BETWEEN p.PayPeriodStart AND p.PayPeriodEnd), 0)
            ) * (1 - (SELECT CAST(MiscellaneousValue AS DECIMAL(5,2)) 
                      FROM Miscellaneous WHERE MiscellaneousName = 'TaxRate'))
        ), 2
    )) AS NetPay

FROM Payroll p
JOIN Employee e ON p.EmployeeID = e.EmployeeID;

-- COMPLEX QUERIES SCRIPTS
-- Retrieve the total hours worked by each employee in a specific month. (Akshata Sardeshpande)
SELECT e.EmployeeName, 
      SUM(a.HoursWorked) AS TotalHoursWorked,
      COUNT(a.AttendanceDate) AS DaysWorked
FROM employee e
JOIN attendance a ON e.EmployeeID = a.EmployeeID
WHERE MONTH(a.AttendanceDate) = 3 AND YEAR(a.AttendanceDate) = 2025
GROUP BY e.EmployeeName;

-- Retrieve the top 5 employees who received the highest total bonus amount in a given period. (Akshata Sardeshpande)
SELECT e.EmployeeName, SUM(b.BonusAmount) AS TotalBonus
FROM employee e
JOIN bonuses b ON e.EmployeeID = b.EmployeeID
WHERE b.BonusDate BETWEEN '2025-01-01' AND '2025-03-31'
GROUP BY e.EmployeeName
ORDER BY TotalBonus DESC
LIMIT 5;

-- Find Employees Earning Above the Average Salary for Their Job Role (Keerthana Sreeramareddy)
-- Query for Fixed Salary Employees
(
  SELECT 
    e.EmployeeID, 
    e.EmployeeName, 
    jr.RoleName,
    fs.MonthlySalary AS Salary,
    'Fixed' AS SalaryType
  FROM Employee e
  JOIN FixedSalary fs ON e.EmployeeID = fs.EmployeeID
  JOIN JobRole jr ON e.JobRoleID = jr.JobRoleID
  WHERE fs.MonthlySalary >= (
    SELECT AVG(fs2.MonthlySalary)
    FROM FixedSalary fs2
    JOIN Employee e2 ON fs2.EmployeeID = e2.EmployeeID
    WHERE e2.JobRoleID = e.JobRoleID
  )
)
UNION
-- Query for Hourly Employees
(
  SELECT 
    e.EmployeeID, 
    e.EmployeeName, 
    jr.RoleName,
    h.TotalHourly AS Salary,
    'Hourly' AS SalaryType
  FROM Employee e
  JOIN JobRole jr ON e.JobRoleID = jr.JobRoleID
  JOIN (
    SELECT a.EmployeeID, SUM(a.HoursWorked * hs.HourlyRate) AS TotalHourly
    FROM Attendance a
    JOIN HourlySalary hs ON a.EmployeeID = hs.EmployeeID
    GROUP BY a.EmployeeID
  ) h ON e.EmployeeID = h.EmployeeID
  WHERE h.TotalHourly >= (
    SELECT AVG(h2.TotalHourly)
    FROM (
      SELECT e2.EmployeeID, e2.JobRoleID,
             SUM(a2.HoursWorked * hs2.HourlyRate) AS TotalHourly
      FROM Attendance a2
      JOIN HourlySalary hs2 ON a2.EmployeeID = hs2.EmployeeID
      JOIN Employee e2 ON a2.EmployeeID = e2.EmployeeID
      GROUP BY e2.EmployeeID, e2.JobRoleID
    ) h2
    WHERE h2.JobRoleID = e.JobRoleID
  )
);

-- Find the Top 5 Employees with the Most Hours Worked - Over the Last 6 Months (Keerthana Sreeramareddy)
-- Fixed Salary Anomalies
(
  SELECT 
    e.EmployeeID,
    e.EmployeeName,
    jr.RoleName,
    ROUND(fs.MonthlySalary, 2) AS Salary,
    'Fixed' AS SalaryType,
    ROUND((
      SELECT AVG(fs2.MonthlySalary)
      FROM FixedSalary fs2 
      JOIN Employee e2 ON fs2.EmployeeID = e2.EmployeeID
      WHERE e2.JobRoleID = e.JobRoleID
    ), 2) AS AvgSalary,
    ROUND(fs.MonthlySalary - (
      SELECT AVG(fs2.MonthlySalary)
      FROM FixedSalary fs2 
      JOIN Employee e2 ON fs2.EmployeeID = e2.EmployeeID
      WHERE e2.JobRoleID = e.JobRoleID
    ), 2) AS SalaryDeviation,
    ROUND((
      SELECT STDDEV(fs3.MonthlySalary)
      FROM FixedSalary fs3 
      JOIN Employee e3 ON fs3.EmployeeID = e3.EmployeeID
      WHERE e3.JobRoleID = e.JobRoleID
    ), 2) AS StdDev
  FROM Employee e
  JOIN FixedSalary fs ON e.EmployeeID = fs.EmployeeID
  JOIN JobRole jr ON e.JobRoleID = jr.JobRoleID
  HAVING ABS(SalaryDeviation) >= StdDev
)
UNION ALL
-- Hourly Salary Anomalies
(
  SELECT 
    e.EmployeeID,
    e.EmployeeName,
    jr.RoleName,
    ROUND(h.TotalHourly, 2) AS Salary,
    'Hourly' AS SalaryType,
    ROUND((
      SELECT AVG(h2.TotalHourly)
      FROM (
        SELECT e2.EmployeeID, e2.JobRoleID,
               SUM(a2.HoursWorked * hs2.HourlyRate) AS TotalHourly
        FROM Attendance a2
        JOIN HourlySalary hs2 ON a2.EmployeeID = hs2.EmployeeID
        JOIN Employee e2 ON a2.EmployeeID = e2.EmployeeID
        GROUP BY e2.EmployeeID, e2.JobRoleID
      ) h2
      WHERE h2.JobRoleID = e.JobRoleID
    ), 2) AS AvgSalary,
    ROUND(h.TotalHourly - (
      SELECT AVG(h2.TotalHourly)
      FROM (
        SELECT e2.EmployeeID, e2.JobRoleID,
               SUM(a2.HoursWorked * hs2.HourlyRate) AS TotalHourly
        FROM Attendance a2
        JOIN HourlySalary hs2 ON a2.EmployeeID = hs2.EmployeeID
        JOIN Employee e2 ON a2.EmployeeID = e2.EmployeeID
        GROUP BY e2.EmployeeID, e2.JobRoleID
      ) h2
      WHERE h2.JobRoleID = e.JobRoleID
    ), 2) AS SalaryDeviation,
    ROUND((
      SELECT STDDEV(h3.TotalHourly)
      FROM (
        SELECT e3.EmployeeID, e3.JobRoleID,
               SUM(a3.HoursWorked * hs3.HourlyRate) AS TotalHourly
        FROM Attendance a3
        JOIN HourlySalary hs3 ON a3.EmployeeID = hs3.EmployeeID
        JOIN Employee e3 ON a3.EmployeeID = e3.EmployeeID
        GROUP BY e3.EmployeeID, e3.JobRoleID
      ) h3
      WHERE h3.JobRoleID = e.JobRoleID
    ), 2) AS StdDev
  FROM Employee e
  JOIN JobRole jr ON e.JobRoleID = jr.JobRoleID
  JOIN (
      SELECT a.EmployeeID, SUM(a.HoursWorked * hs.HourlyRate) AS TotalHourly
      FROM Attendance a
      JOIN HourlySalary hs ON a.EmployeeID = hs.EmployeeID
      GROUP BY a.EmployeeID
  ) h ON e.EmployeeID = h.EmployeeID
  HAVING ABS(SalaryDeviation) >= StdDev
);

-- Employees with Both Bonuses and Deductions in the Same Month. Lists employees who received a bonus and had deductions in March 2025. (Soumya Saswat Patra)
SELECT 
    e.EmployeeID,
    e.EmployeeName,
    e.SalaryType,
    b.TotalBonus,
    d.TotalDeductions
FROM Employee e
JOIN (
    -- Aggregate total bonus for each employee for March 2025
    SELECT EmployeeID, SUM(BonusAmount) AS TotalBonus
    FROM Bonuses
    WHERE MONTH(BonusDate) = 3 
      AND YEAR(BonusDate) = 2025
    GROUP BY EmployeeID
) b ON e.EmployeeID = b.EmployeeID
JOIN (
    -- Aggregate total deductions for each employee for March 2025
    SELECT EmployeeID, SUM(DeductionAmount) AS TotalDeductions
    FROM Deductions
    WHERE MONTH(DeductionDate) = 3 
      AND YEAR(DeductionDate) = 2025
    GROUP BY EmployeeID
) d ON e.EmployeeID = d.EmployeeID
WHERE b.TotalBonus > 0 
  AND d.TotalDeductions > 0;

-- Employees with High Deduction Percentage > 20% of Base Salary (Soumya Saswat Patra)
-- Fixed Salary Employees
(
  SELECT 
    e.EmployeeID,
    e.EmployeeName,
    'Fixed' AS SalaryType,
    ROUND(fs.MonthlySalary, 2) AS BaseSalary,
    ROUND(COALESCE(SUM(d.DeductionAmount), 0), 2) AS TotalDeductions,
    ROUND((COALESCE(SUM(d.DeductionAmount), 0) / fs.MonthlySalary) * 100, 2) AS DeductionPercentage
  FROM Employee e
  JOIN FixedSalary fs ON e.EmployeeID = fs.EmployeeID
  LEFT JOIN Deductions d ON e.EmployeeID = d.EmployeeID
  GROUP BY e.EmployeeID, e.EmployeeName, fs.MonthlySalary
  HAVING ROUND((COALESCE(SUM(d.DeductionAmount), 0) / fs.MonthlySalary) * 100, 2) > 20
)
UNION ALL
-- Hourly Salary Employees
(
  SELECT 
    e.EmployeeID,
    e.EmployeeName,
    'Hourly' AS SalaryType,
    ROUND(SUM(a.HoursWorked * hs.HourlyRate), 2) AS BaseSalary,
    ROUND(COALESCE(SUM(d.DeductionAmount), 0), 2) AS TotalDeductions,
    ROUND((COALESCE(SUM(d.DeductionAmount), 0) / SUM(a.HoursWorked * hs.HourlyRate)) * 100, 2) AS DeductionPercentage
  FROM Employee e
  JOIN HourlySalary hs ON e.EmployeeID = hs.EmployeeID
  JOIN Attendance a ON e.EmployeeID = a.EmployeeID
  LEFT JOIN Deductions d ON e.EmployeeID = d.EmployeeID
  GROUP BY e.EmployeeID, e.EmployeeName
  HAVING ROUND((COALESCE(SUM(d.DeductionAmount), 0) / SUM(a.HoursWorked * hs.HourlyRate)) * 100, 2) > 20
);

-- Retrieve Employees Who Were Absent More Than 3 Days in a Month (Gauri Jayesh Pawar)
SELECT 
    e.EmployeeID, 
    e.EmployeeName, 
    COUNT(a.AttendanceDate) AS AbsentDays
FROM Employee e
JOIN Attendance a ON e.EmployeeID = a.EmployeeID
WHERE a.HoursWorked = 0
  AND MONTH(a.AttendanceDate) = 3
  AND YEAR(a.AttendanceDate) = 2025
GROUP BY e.EmployeeID, e.EmployeeName
HAVING COUNT(a.AttendanceDate) > 3;

-- Identify Employees Not Receiving Bonuses this year (Gauri Jayesh Pawar)
SELECT 
    e.EmployeeID, 
    e.EmployeeName, 
    e.SalaryType,
    e.DepartmentName
FROM Employee e
LEFT JOIN Bonuses b 
    ON e.EmployeeID = b.EmployeeID 
    AND YEAR(b.BonusDate) = YEAR(CURDATE())
WHERE b.EmployeeID IS NULL;

-- Get Department-Wise Total Payroll Expense (Abhishek Bhadauria)
SELECT 
    e.DepartmentName,
    CONCAT('$', ROUND(SUM(COALESCE(fs.TotalFixed, 0)), 2)) AS TotalFixedSalary,
    CONCAT('$', ROUND(SUM(COALESCE(h.TotalHourly, 0)), 2)) AS TotalHourlySalary,
    CONCAT('$', ROUND(SUM(COALESCE(b.TotalBonuses, 0)), 2)) AS TotalBonuses,
    CONCAT('$', ROUND(SUM(COALESCE(d.TotalDeductions, 0)), 2)) AS TotalDeductions,
    CONCAT('$', ROUND(SUM(
        COALESCE(fs.TotalFixed, 0)
        + COALESCE(h.TotalHourly, 0)
        + COALESCE(b.TotalBonuses, 0)
        - COALESCE(d.TotalDeductions, 0)
    ), 2)) AS TotalPayrollExpense
FROM Employee e
-- Subquery for fixed salary: retrieve the most recent (or maximum) fixed salary for each employee
LEFT JOIN (
    SELECT EmployeeID, MAX(MonthlySalary) AS TotalFixed
    FROM FixedSalary
    GROUP BY EmployeeID
) fs ON e.EmployeeID = fs.EmployeeID
-- Subquery for hourly salary: calculate total hourly earnings based on hours worked and hourly rate
LEFT JOIN (
    SELECT a.EmployeeID, SUM(a.HoursWorked * hs.HourlyRate) AS TotalHourly
    FROM Attendance a
    JOIN HourlySalary hs ON a.EmployeeID = hs.EmployeeID
    GROUP BY a.EmployeeID
) h ON e.EmployeeID = h.EmployeeID
-- Subquery for bonuses: total bonuses per employee
LEFT JOIN (
    SELECT EmployeeID, SUM(BonusAmount) AS TotalBonuses
    FROM Bonuses
    GROUP BY EmployeeID
) b ON e.EmployeeID = b.EmployeeID
-- Subquery for deductions: total deductions per employee
LEFT JOIN (
    SELECT EmployeeID, SUM(DeductionAmount) AS TotalDeductions
    FROM Deductions
    GROUP BY EmployeeID
) d ON e.EmployeeID = d.EmployeeID
GROUP BY e.DepartmentName
ORDER BY TotalPayrollExpense DESC;

-- Analyze bonus payment frequency and amounts over last 12 months (Abhishek Bhadauria)
SELECT 
    e.EmployeeID,
    e.EmployeeName,
    COUNT(b.EmployeeID) AS TotalBonusCount,
    12 AS TotalPeriodMonths,
    ROUND(
      (COUNT(DISTINCT DATE_FORMAT(b.BonusDate, '%Y-%m')) 
       / 12
      ) * 100, 2
    ) AS BonusConsistencyPercentage,
    ROUND(AVG(b.BonusAmount), 2) AS AvgBonusAmount,
    ROUND(SUM(b.BonusAmount), 2) AS TotalBonusAmount
FROM Employee e
JOIN Bonuses b ON e.EmployeeID = b.EmployeeID
WHERE b.BonusDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND CURDATE()
GROUP BY e.EmployeeID
ORDER BY BonusConsistencyPercentage DESC, TotalBonusCount DESC;