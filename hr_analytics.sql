-- Create Employee Table

CREATE TABLE employee_data (
    EmpID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    StartDate VARCHAR(20),
    ExitDate VARCHAR(20),
    Title VARCHAR(100),
    Supervisor VARCHAR(100),
    ADEmail VARCHAR(100),
    BusinessUnit VARCHAR(100),
    EmployeeStatus VARCHAR(50),
    EmployeeType VARCHAR(50),
    PayZone VARCHAR(50),
    EmployeeClassificationType VARCHAR(50),
    TerminationType VARCHAR(100),
    TerminationDescription TEXT,
    DepartmentType VARCHAR(100),
    Division VARCHAR(100),
    DOB VARCHAR(20),
    State VARCHAR(50),
    JobFunctionDescription VARCHAR(200),
    GenderCode VARCHAR(10),
    LocationCode VARCHAR(50),
    RaceDesc VARCHAR(100),
    MaritalDesc VARCHAR(50),
    PerformanceScore VARCHAR(50),
    CurrentEmployeeRating INT
);



-- View first 10 rows
SELECT *
FROM employee_data
LIMIT 10;


-- Total Employee Count
SELECT COUNT(*) AS total_employees
FROM employee_data;


-- Employee Status Distribution
SELECT
    EmployeeStatus,
    COUNT(*) AS employee_count
FROM employee_data
GROUP BY EmployeeStatus
ORDER BY employee_count DESC;


-- Workforce Distribution by Department
SELECT
    DepartmentType,
    COUNT(*) AS employee_count
FROM employee_data
GROUP BY DepartmentType
ORDER BY employee_count DESC;


-- Calculate Attrition Rate by Department
SELECT
    DepartmentType,
	COUNT(*) AS total_employees,
	COUNT(
        CASE
            WHEN EmployeeStatus <> 'Active'
            THEN 1
        END
    ) AS employees_left,
	ROUND(
        COUNT(
            CASE
                WHEN EmployeeStatus <> 'Active'
                THEN 1
            END
        )::NUMERIC * 100
        / COUNT(*),
        2
    ) AS attrition_rate
	FROM employee_data
	GROUP BY DepartmentType
	ORDER BY attrition_rate DESC;


-- Identify Job Roles with Highest Attrition
SELECT
    Title,
	COUNT(*) AS total_employees,
	COUNT(
        CASE
            WHEN EmployeeStatus <> 'Active'
            THEN 1
        END
    ) AS attrition_count,
	ROUND(
        COUNT(
            CASE
                WHEN EmployeeStatus <> 'Active'
                THEN 1
            END
        )::NUMERIC * 100
        / COUNT(*),
        2
    ) AS attrition_rate
	FROM employee_data
	GROUP BY Title
	ORDER BY attrition_rate DESC;



-- Department Performance Analysis
SELECT
    DepartmentType,
	ROUND(
        AVG(CurrentEmployeeRating),
        2
    ) AS avg_rating
	FROM employee_data
	GROUP BY DepartmentType
	ORDER BY avg_rating DESC;


-- Rank Employees by Performance
SELECT
    EmpID,
    FirstName,
    LastName,
    DepartmentType,
    CurrentEmployeeRating,
	RANK() OVER(
        PARTITION BY DepartmentType
        ORDER BY CurrentEmployeeRating DESC
    ) AS department_rank
	FROM employee_data;


-- Employee vs Department Average Rating
SELECT
    EmpID,
    FirstName,
    LastName,
    DepartmentType,
    CurrentEmployeeRating,
	ROUND(
        AVG(CurrentEmployeeRating)
        OVER(PARTITION BY DepartmentType),
        2
    ) AS dept_average,
	ROUND(
        CurrentEmployeeRating -
        AVG(CurrentEmployeeRating)
        OVER(PARTITION BY DepartmentType),
        2
    ) AS difference_from_average
	FROM employee_data;



-- Identify Top 10% Employees
WITH employee_rank AS (
SELECT
        EmpID,
        FirstName,
        LastName,
        DepartmentType,
        CurrentEmployeeRating,
		PERCENT_RANK() OVER(
            ORDER BY CurrentEmployeeRating DESC
        ) AS pct_rank
		FROM employee_data
)

SELECT *
FROM employee_rank
WHERE pct_rank <= 0.10;



-- Segment Employees into Quartiles
SELECT
    EmpID,
    FirstName,
    LastName,
    DepartmentType,
    CurrentEmployeeRating,
	NTILE(4) OVER(
        PARTITION BY DepartmentType
        ORDER BY CurrentEmployeeRating DESC
    ) AS quartile,
	CASE
	WHEN NTILE(4) OVER(
             PARTITION BY DepartmentType
             ORDER BY CurrentEmployeeRating DESC
        ) = 1
        THEN 'Top 25%'
		WHEN NTILE(4) OVER(
             PARTITION BY DepartmentType
             ORDER BY CurrentEmployeeRating DESC
        ) = 2
        THEN 'Upper Mid'
		WHEN NTILE(4) OVER(
             PARTITION BY DepartmentType
             ORDER BY CurrentEmployeeRating DESC
        ) = 3
        THEN 'Lower Mid'
		ELSE 'Bottom 25%'
		END AS performance_band
		FROM employee_data;


-- Employees with Highest Tenure
SELECT
    EmpID,
    FirstName,
    LastName,
    Title,
    StartDate
FROM employee_data
ORDER BY StartDate ASC
LIMIT 20;