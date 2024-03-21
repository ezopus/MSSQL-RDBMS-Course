
-- 16. create view for employees and salaries
CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName
,LastName
,Salary
FROM Employees

--17. create view employees with job titles

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], JobTitle
FROM Employees

-- 18. Distinct Job Titles
SELECT DISTINCT JobTitle FROM Employees

-- 19. Find first 10 started projects
SELECT TOP 10 *
FROM Projects
ORDER BY StartDate, Name

-- 20. Last 7 hired employees
SELECT TOP 7
FirstName
, LastName
, HireDate
FROM Employees
ORDER BY HireDate DESC

-- 21. Increase salaries
--SELECT Salary FROM Employees
--WHERE DepartmentID IN (1, 2, 4, 11)

BEGIN TRAN T1

UPDATE Employees
SET Salary = Salary * 1.12
WHERE DepartmentID IN (
SELECT DepartmentID 
FROM Departments 
WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
)
SELECT Salary FROM Employees

ROLLBACK TRAN T1

