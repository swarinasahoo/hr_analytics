# HR Analytics SQL — README

## Overview

This SQL project provides a comprehensive analytics framework for human resources data. It enables HR teams and analysts to explore workforce composition, measure attrition, evaluate employee performance, and identify tenure trends — all from a single `employee_data` table.

---

## Table Schema

The project revolves around a single table: `employee_data`.

| Column | Type | Description |
|---|---|---|
| `EmpID` | INT | Unique employee identifier (Primary Key) |
| `FirstName` / `LastName` | VARCHAR | Employee name |
| `StartDate` / `ExitDate` | VARCHAR | Employment start and exit dates |
| `Title` | VARCHAR | Job title |
| `Supervisor` | VARCHAR | Reporting supervisor |
| `ADEmail` | VARCHAR | Active Directory email |
| `BusinessUnit` | VARCHAR | Business unit the employee belongs to |
| `EmployeeStatus` | VARCHAR | Current status (e.g., Active, Terminated) |
| `EmployeeType` | VARCHAR | Employment type (e.g., Full-Time, Part-Time) |
| `PayZone` | VARCHAR | Compensation zone |
| `EmployeeClassificationType` | VARCHAR | Classification category |
| `TerminationType` / `TerminationDescription` | VARCHAR / TEXT | Details about termination, if applicable |
| `DepartmentType` | VARCHAR | Department the employee belongs to |
| `Division` | VARCHAR | Organisational division |
| `DOB` | VARCHAR | Date of birth |
| `State` | VARCHAR | Employee's state/location |
| `JobFunctionDescription` | VARCHAR | Description of job function |
| `GenderCode` | VARCHAR | Gender identifier |
| `LocationCode` | VARCHAR | Office/location code |
| `RaceDesc` | VARCHAR | Race/ethnicity description |
| `MaritalDesc` | VARCHAR | Marital status |
| `PerformanceScore` | VARCHAR | Qualitative performance score |
| `CurrentEmployeeRating` | INT | Numeric performance rating |

---

## Queries

### 1. Data Preview
```sql
SELECT * FROM employee_data LIMIT 10;
```
Returns the first 10 rows for a quick sanity check of the data.

---

### 2. Total Employee Count
```sql
SELECT COUNT(*) AS total_employees FROM employee_data;
```
Returns the total number of employee records in the table.

---

### 3. Employee Status Distribution
Groups and counts employees by `EmployeeStatus` (e.g., Active vs. terminated) to give a high-level snapshot of workforce health.

---

### 4. Workforce Distribution by Department
Counts employees per `DepartmentType`, sorted by headcount — useful for identifying the largest and smallest teams.

---

### 5. Attrition Rate by Department
Calculates the percentage of employees who have left (non-Active status) within each department. Helps pinpoint which departments have retention problems.

**Formula:** `(employees_left / total_employees) × 100`

---

### 6. Job Roles with Highest Attrition
Breaks down attrition by `Title` to reveal which job roles experience the most turnover — a key input for role-level retention strategy.

---

### 7. Department Performance Analysis
Computes the average `CurrentEmployeeRating` per department, ranked from highest to lowest. Useful for benchmarking departmental performance.

---

### 8. Rank Employees by Performance (Window Function)
Uses `RANK()` with `PARTITION BY DepartmentType` to rank each employee within their department based on their rating. Enables fair, department-relative performance comparisons.

---

### 9. Employee vs. Department Average Rating (Window Function)
Uses `AVG() OVER(PARTITION BY DepartmentType)` to show each employee's rating alongside their department's average, and the difference between them. Useful for identifying standout performers and underperformers.

---

### 10. Identify Top 10% Employees (CTE + Window Function)
Uses `PERCENT_RANK()` inside a CTE to flag employees whose rating places them in the top 10% company-wide. Supports recognition and retention programmes.

---

### 11. Segment Employees into Performance Quartiles (Window Function)
Uses `NTILE(4)` partitioned by department to divide employees into four performance bands within their department:

| Quartile | Band |
|---|---|
| 1 | Top 25% |
| 2 | Upper Mid |
| 3 | Lower Mid |
| 4 | Bottom 25% |

---

### 12. Employees with Highest Tenure
Returns the 20 employees with the earliest `StartDate`, identifying the longest-serving staff members.

---

## Database Compatibility

These queries are written for **PostgreSQL** (note the `::NUMERIC` cast used in `ROUND()` calculations). Minor adjustments may be needed for other databases:

| Feature | PostgreSQL | MySQL | SQL Server |
|---|---|---|---|
| `::NUMERIC` cast | ✅ Native | Use `CAST(x AS DECIMAL)` | Use `CAST(x AS DECIMAL)` |
| `PERCENT_RANK()` | ✅ | ✅ (8.0+) | ✅ |
| `NTILE()` | ✅ | ✅ (8.0+) | ✅ |
| CTEs | ✅ | ✅ (8.0+) | ✅ |

---

## Getting Started

1. Create the table using the `CREATE TABLE` statement at the top of the script.
2. Load your HR data into `employee_data` using `INSERT` statements or a bulk import tool (e.g., `\COPY` in psql, or a CSV import wizard).
3. Run the queries individually or as part of a reporting pipeline.

---

## Use Cases

- **HR Dashboards** — Feed query results into BI tools like Tableau, Power BI, or Metabase.
- **Retention Strategy** — Use attrition queries to target high-turnover departments and roles.
- **Performance Reviews** — Use quartile and ranking queries to support review cycles.
- **Workforce Planning** — Use department distribution and tenure data to plan headcount.
