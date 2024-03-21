-- 2. Find all the info about departments
SELECT * FROM Departments

-- 3. Find all department names
SELECT [Name] FROM Departments

-- 4. Find salary of each employee
SELECT FirstName, LastName, Salary FROM Employees

-- 5. Find full name of each employee
SELECT FirstName, MiddleName, LastName FROM Employees

-- 6. Find Email Address of Each Employee
SELECT FirstName + '.' + LastName + '@softuni.bg' as [Full Email Address]
	FROM Employees

-- 7. Find all different employees'salaries
SELECT DISTINCT Salary FROM Employees

-- 8. Find all information about employees
SELECT * FROM Employees WHERE JobTitle = 'Sales Representative'

-- 9. Find Names of All Employees by Salary in Range
SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE Salary BETWEEN 20000 AND 30000

-- 10. Find names of all employees with salary equal to exactly a given number
SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
	FROM Employees
	WHERE Salary IN (25000, 14000, 12500, 23600)

-- 11. Find all employees without a manager
SELECT FirstName, LastName
	FROM Employees
	WHERE ManagerID IS NULL

-- 12. Find all employees with a salary more than number
SELECT FirstName, LastName, Salary
	FROM Employees
	WHERE Salary > 50000
	ORDER BY Salary DESC

-- 13. Find 5 Best Paid Employees
SELECT TOP 5 FirstName, LastName FROM Employees	ORDER BY Salary DESC

-- 14. Find all employees except marketing
SELECT FirstName, LastName
FROM Employees
WHERE NOT DepartmentID = 4

-- 15. Sort employees table
SELECT * 
FROM Employees
ORDER BY Salary DESC
,FirstName
,LastName DESC
,MiddleName

