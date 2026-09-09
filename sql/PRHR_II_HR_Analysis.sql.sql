
# PRHR-II — Database Setup & Table Creation

# ============================================================

# Project: PRHR-II (People/HR Analytics)

# Purpose: Create the project database and define the core

# ============================================================

# 1. CREATE DATABASE

# ============================================================

CREATE DATABASE IF NOT EXISTS prhr_ii;

USE prhr_ii;

# Confirm the active database

SELECT DATABASE();
ALTER TABLE prhr_ii.tbl_employee
RENAME COLUMN `ï»¿EmpID` TO EmpID;
# ============================================================

# 2. CREATE EMPLOYEE MASTER TABLE

# ============================================================



CREATE TABLE IF NOT EXISTS tbl_employee (
EmpID INT PRIMARY KEY,
EmpName VARCHAR(100),
EngDt DATE,
TermDt DATE,
DepID INT,
GenderID INT,
RaceID INT,
MgrID INT,
DOB DATE,
PayRate DECIMAL(10,2),
`Level` INT
);

# Verify table structure

DESCRIBE tbl_employee;

# ============================================================

# 3. CREATE EMPLOYEE ACTION TABLE

# ============================================================

# Grain:

# One row = one employee action/event

# Relationship:

# EmpID → tbl_employee.EmpID
# Example:

# An employee may have multiple action records over time.

CREATE TABLE IF NOT EXISTS tbl_action (
ActID INT PRIMARY KEY,
ActionID INT,
EmpID INT,
EffectiveDt DATE
);

# Verify table structure

DESCRIBE tbl_action;

# ============================================================

# 4. CREATE EMPLOYEE PERFORMANCE TABLE

# ============================================================

# Grain:

# One row = one employee performance record

# Relationship:

# EmpID → tbl_employee.EmpID
# Example:

# One employee can have multiple performance records.

CREATE TABLE IF NOT EXISTS tbl_perf (
PerfID INT PRIMARY KEY,
EmpID INT,
Rating INT,
PerfDate DATE
);

# Verify table structure

DESCRIBE tbl_perf;

# ============================================================

# 6. BASIC DATABASE VERIFICATION

# ============================================================

USE prhr_ii;

SHOW TABLES;

# ============================================================

# 7. ROW-COUNT VERIFICATION

# ============================================================

# Final successful counts from the current project dataset:

# tbl_employee → 1,562

# tbl_action   → 2,586

# tbl_perf     → 9,605

SELECT
'tbl_employee' AS table_name,
COUNT(*) AS row_count
FROM tbl_employee

UNION ALL

SELECT
'tbl_action',
COUNT(*)
FROM tbl_action

UNION ALL

SELECT
'tbl_perf',
COUNT(*)
FROM tbl_perf;



# ============================================================

# 8. SAMPLE DATA VERIFICATION

# ============================================================

SELECT *
FROM tbl_action
LIMIT 10;

# ============================================================

# END OF DATABASE SETUP

# ============================================================


# Data Quality & Relationship Validation

# ============================================================
## Check for duplicate Employee IDs in tbl_employee.

SELECT 
    EmpID,
    COUNT(*) AS duplicate_count
FROM tbl_employee
GROUP BY EmpID
HAVING COUNT(*) > 1;

## CHECK NULL EMP_id

SELECT COUNT(*) AS null_empids
FROM tbl_employee
WHERE EmpID IS NULL;

DESCRIBE tbl_action;

DESCRIBE tbl_perf;

## ✅ Relationship Check

SELECT COUNT(*) AS invalid_action_empids
FROM tbl_action a
LEFT JOIN tbl_employee e
    ON a.EmpID = e.EmpID
WHERE e.EmpID IS NULL;

SELECT COUNT(*) AS invalid_perf_empids
FROM tbl_perf p
LEFT JOIN tbl_employee e
    ON p.EmpID = e.EmpID
WHERE e.EmpID IS NULL;

## check row identifier of action table
SELECT 
    `ï»¿ActID`,
    COUNT(*) AS duplicate_count
FROM tbl_action
GROUP BY `ï»¿ActID`
HAVING COUNT(*) > 1;

ALTER TABLE tbl_action
RENAME COLUMN `ï»¿ActID` TO ActID;

DESCRIBE tbl_action;

## Null check
SELECT COUNT(*) AS null_actids
FROM tbl_action
WHERE ActID IS NULL;

## Duplicate checking
ALTER TABLE tbl_perf
RENAME COLUMN `ï»¿PerfID` TO PerfID;

# DUPLICATE CHECKING
SELECT 
    PerfID,
    COUNT(*) AS duplicate_count
FROM tbl_perf
GROUP BY PerfID
HAVING COUNT(*) > 1;

## Null check (perf)
SELECT COUNT(*) AS null_perfids
FROM tbl_perf
WHERE PerfID IS NULL;

DESCRIBE tbl_perf;

#ADDING PRIMARY KEY FOR EACH TABLE
ALTER TABLE tbl_employee
ADD PRIMARY KEY (EmpID);

ALTER TABLE tbl_action
ADD PRIMARY KEY (ActID);

ALTER TABLE tbl_perf
ADD PRIMARY KEY (PerfID);

#ADDING FOREGIN KEYS
SHOW INDEX FROM tbl_employee;

DESCRIBE tbl_employee;



SHOW CREATE TABLE tbl_employee;
#I

ALTER TABLE tbl_employee
ADD INDEX idx_employee_empid (EmpID);

SHOW INDEX FROM tbl_employee;

DESCRIBE tbl_employee;

#II
ALTER TABLE tbl_action
ADD CONSTRAINT fk_action_employee
FOREIGN KEY (EmpID)
REFERENCES tbl_employee(EmpID);

#III'[
ALTER TABLE tbl_perf
ADD CONSTRAINT fk_perf_employee
FOREIGN KEY (EmpID)
REFERENCES tbl_employee(EmpID);

#One final verification
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'prhr_ii'
  AND REFERENCED_TABLE_NAME IS NOT NULL;
 
 #verfication checking
SELECT 
    EngDt,
    TermDt,
    DOB
FROM tbl_employee
LIMIT 10;

#BlankS counting
SELECT
    SUM(EngDt = '') AS empty_engdt,
    SUM(TermDt = '') AS empty_termdt,
    SUM(DOB = '') AS empty_dob
FROM tbl_employee;

#CONVERT TO NULL
UPDATE tbl_employee
SET TermDt = NULL
WHERE TRIM(TermDt) = '';

#VERFIY
SELECT COUNT(*) AS null_termdt
FROM tbl_employee
WHERE TermDt IS NULL;

#CONVERT TO DATE
ALTER TABLE tbl_employee
MODIFY TermDt DATE NULL;

#CONVERT TO DATE (DATA TYPE CORRECTION)
ALTER TABLE tbl_employee
MODIFY EngDt DATE NULL,
MODIFY DOB DATE NULL;

DESCRIBE tbl_action;
DESCRIBE tbl_perf;

#DATA CHANGING
ALTER TABLE tbl_action
MODIFY EffectiveDt DATE NULL;

ALTER TABLE tbl_perf
MODIFY PerfDate DATE NULL;

DESCRIBE tbl_employee;

SELECT PayRate
FROM tbl_employee
LIMIT 20;

DESCRIBE tbl_employee;
DESCRIBE tbl_action;
DESCRIBE tbl_perf;

# INVALID VALUES CHECKING

#CHECK DOB 
SELECT COUNT(*) AS invalid_dob
FROM tbl_employee
WHERE DOB >= EngDt;

#TERMINATION DATE CHECK
SELECT COUNT(*) AS invalid_termination_dates
FROM tbl_employee
WHERE TermDt IS NOT NULL
  AND TermDt < EngDt;
  
  
#Future joining date  
SELECT COUNT(*) AS future_joining
FROM tbl_employee
WHERE EngDt > CURDATE();


#Action before employee joined ❌
SELECT COUNT(*) AS invalid_action_dates
FROM tbl_action a
JOIN tbl_employee e
    ON a.EmpID = e.EmpID
WHERE a.EffectiveDt < e.EngDt;

#Performance before employee joined
SELECT COUNT(*) AS invalid_perf_dates
FROM tbl_perf p
JOIN tbl_employee e
    ON p.EmpID = e.EmpID
WHERE p.PerfDate < e.EngDt;

#Performance after termination
SELECT COUNT(*) AS invalid_perf_after_termination
FROM tbl_perf p
JOIN tbl_employee e
    ON p.EmpID = e.EmpID
WHERE e.TermDt IS NOT NULL
  AND p.PerfDate > e.TermDt;
  
#Action after termination
SELECT COUNT(*) AS invalid_action_after_termination
FROM tbl_action a
JOIN tbl_employee e
    ON a.EmpID = e.EmpID
WHERE e.TermDt IS NOT NULL
  AND a.EffectiveDt > e.TermDt;
  
  
#Performance Rating validity  
SELECT COUNT(*) AS invalid_ratings
FROM tbl_perf
WHERE Rating NOT BETWEEN 1 AND 5;


#Check negative IDs
SELECT COUNT(*) AS negative_employee_ids
FROM tbl_employee
WHERE EmpID < 0
   OR DepID < 0
   OR GenderID < 0
   OR RaceID < 0
   OR MgrID < 0;
   
#Check duplicate employee names — informational only
SELECT EmpName, COUNT(*) AS name_count
FROM tbl_employee
GROUP BY EmpName
HAVING COUNT(*) > 1;

#Performance before employee joined
SELECT COUNT(*) AS invalid_perf_dates
FROM tbl_perf p
JOIN tbl_employee e
    ON p.EmpID = e.EmpID
WHERE p.PerfDate < e.EngDt;

#Performance after termination
SELECT COUNT(*) AS invalid_perf_after_termination
FROM tbl_perf p
JOIN tbl_employee e
    ON p.EmpID = e.EmpID
WHERE e.TermDt IS NOT NULL
  AND p.PerfDate > e.TermDt;
  
  #SQL BUSINESSS ANALYSIS
  
  #I WORKFORCE ANALYSIS
  #TOTAL EMPLOYEES
  
  SELECT COUNT(*) AS total_employees
FROM tbl_employee;

#COUNT BY DEPARTMENT
SELECT
    DepID,
    COUNT(*) AS Emp_Dep
FROM tbl_employee
GROUP BY DepID
ORDER BY DepID ASC;

#Active vs Terminated Employees

SELECT
    CASE
        WHEN TermDt IS NULL THEN 'Active'
        ELSE 'Terminated'
    END AS Employee_Status,
    COUNT(*) AS Employee_Count
FROM tbl_employee
GROUP BY Employee_Status;

#Employees by Gender
SELECT
    GenderID,
    COUNT(*) AS Employee_Count
FROM tbl_employee
GROUP BY GenderID
ORDER BY Employee_Count DESC;

#Employees by Level
SELECT
    `Level`,
    COUNT(*) AS Employee_Count
FROM tbl_employee
GROUP BY `Level`
ORDER BY `Level`;

#II HIRING ANALYSIS

#Hiring by Year

SELECT
    YEAR(EngDt) AS Hire_Year,
    COUNT(*) AS Employees_Hired
FROM tbl_employee
GROUP BY YEAR(EngDt)
ORDER BY Hire_Year;

#Hiring by Department
SELECT
    DepID,
    COUNT(*) AS Employees_Hired
FROM tbl_employee
GROUP BY DepID
ORDER BY Employees_Hired DESC;

#TERMINATION AND ATTRITION ANALYSIS

#ATTRITION / TERMINATION ANALYSIS
# Terminations by Year

SELECT
    YEAR(TermDt) AS Termination_Year,
    COUNT(*) AS Employees_Terminated
FROM tbl_employee
WHERE TermDt IS NOT NULL
GROUP BY YEAR(TermDt)
ORDER BY Termination_Year;

# Total Active vs Terminated
SELECT
    CASE
        WHEN TermDt IS NULL THEN 'Active'
        ELSE 'Terminated'
    END AS Employee_Status,
    COUNT(*) AS Employee_Count
FROM tbl_employee
GROUP BY Employee_Status;


#Terminations by Department
SELECT
    DepID,
    COUNT(*) AS Employees_Terminated
FROM tbl_employee
WHERE TermDt IS NOT NULL
GROUP BY DepID
ORDER BY Employees_Terminated DESC;

#Termination Rate by Department ⭐

SELECT
    DepID,
    COUNT(*) AS Total_Employees,
    SUM(TermDt IS NOT NULL) AS TermiInated,
    ROUND(
        SUM(TermDt IS NOT NULL) * 100.0 / COUNT(*),
        2
    ) AS Termination_Rate
FROM tbl_employee
GROUP BY DepID
ORDER BY Termination_Rate DESC;



# Employee Tenure
SELECT
    EmpID,
    EmpName,
    EngDt,
    TermDt,
    TIMESTAMPDIFF(
        MONTH,
        EngDt,
        COALESCE(TermDt, CURDATE())
    ) AS Tenure_Months
FROM tbl_employee;

#Average Tenure: Active vs Terminated ⭐
SELECT
    CASE
        WHEN TermDt IS NULL THEN 'Active'
        ELSE 'Terminated'
    END AS Employee_Status,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MONTH,
                EngDt,
                COALESCE(TermDt, CURDATE())
            )
        ),
        2
    ) AS Avg_Tenure_Months
FROM tbl_employee
GROUP BY Employee_Status;

#ACTION ANALYSIS

#Most Common Employee Actions

SELECT
    ActionID,
    COUNT(*) AS Action_Count
FROM tbl_action
GROUP BY ActionID
ORDER BY Action_Count DESC;

# Actions by Year
SELECT
    YEAR(EffectiveDt) AS Action_Year,
    COUNT(*) AS Action_Count
FROM tbl_action
GROUP BY YEAR(EffectiveDt)
ORDER BY Action_Year;

#Employees with Most Actions ⭐
SELECT
    EmpID,
    COUNT(*) AS Total_Actions
FROM tbl_action
GROUP BY EmpID
ORDER BY Total_Actions DESC;

# Employees with Multiple Actions
SELECT
    EmpID,
    COUNT(*) AS Total_Actions
FROM tbl_action
GROUP BY EmpID
HAVING COUNT(*) > 1
ORDER BY Total_Actions DESC;


#IV PERFORMANCE ANALYSIS

#Performance Records by Year
SELECT
    YEAR(PerfDate) AS Performance_Year,
    COUNT(*) AS Performance_Records
FROM tbl_perf
GROUP BY YEAR(PerfDate)
ORDER BY Performance_Year;

DESCRIBE tbl_perf;

# Performance Rating Distribution


SELECT
    PerfID,
    COUNT(*) AS Record_Count
FROM tbl_perf
GROUP BY PerfID
ORDER BY PerfID;

#QAverage Performance by Employee
SELECT
    EmpID,
    ROUND(AVG(PerfID), 2) AS Avg_Performance
FROM tbl_perf
GROUP BY EmpID
ORDER BY Avg_Performance DESC;

# Employees with Highest Performance ⭐
SELECT
    EmpID,
    ROUND(AVG(PerfID), 2) AS Avg_Performance,
    COUNT(*) AS Reviews
FROM tbl_perf
GROUP BY EmpID
HAVING COUNT(*) >= 2
ORDER BY Avg_Performance DESC;


#Performance by Year (average)
SELECT
    YEAR(PerfDate) AS Performance_Year,
    ROUND(AVG(PerfID), 2) AS Avg_Performance
FROM tbl_perf
GROUP BY YEAR(PerfDate)
ORDER BY Performance_Year;



#EMPLOYEE LIFECYCLE ANALYSIS

#Employee Tenure by Department

# What is the average employee tenure in each department?

SELECT
    DepID,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MONTH,
                EngDt,
                COALESCE(TermDt, CURDATE())
            )
        ),
        2
    ) AS Avg_Tenure_Months
FROM tbl_employee
GROUP BY DepID
ORDER BY Avg_Tenure_Months DESC;

#Employees with Longest Tenure ⭐

# Which employees have been with the organization the longest?

SELECT
    EmpID,
    EmpName,
    EngDt,
    TermDt,
    TIMESTAMPDIFF(
        MONTH,
        EngDt,
        COALESCE(TermDt, CURDATE())
    ) AS Tenure_Months
FROM tbl_employee
ORDER BY Tenure_Months DESC
LIMIT 10;

#Employees with Shortest Tenure

# Which employees stayed for the shortest period?

SELECT
    EmpID,
    EmpName,
    EngDt,
    TermDt,
    TIMESTAMPDIFF(
        MONTH,
        EngDt,
        COALESCE(TermDt, CURDATE())
    ) AS Tenure_Months
FROM tbl_employee
WHERE TermDt IS NOT NULL
ORDER BY Tenure_Months ASC
LIMIT 10;

#Termination by Department ⭐

#Which departments have the highest number of terminated employees?

SELECT
    DepID,
    COUNT(*) AS Terminated_Employees
FROM tbl_employee
WHERE TermDt IS NOT NULL
GROUP BY DepID
ORDER BY Terminated_Employees DESC;

#Average Tenure of Terminated Employees

# How long did terminated employees typically stay?

SELECT
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MONTH,
                EngDt,
                TermDt
            )
        ),
        2
    ) AS Avg_Terminated_Tenure_Months
FROM tbl_employee
WHERE TermDt IS NOT NULL;