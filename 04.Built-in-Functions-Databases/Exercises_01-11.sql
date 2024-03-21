USE SoftUni

--Exercise 01
SELECT FirstName, LastName 
  FROM Employees
 WHERE FirstName LIKE 'Sa%'

--Exercise 02
SELECT FirstName, LastName 
  FROM Employees
 WHERE LastName LIKE '%ei%'
 

--Exercise 03
SELECT FirstName 
  FROM Employees
 WHERE DepartmentID IN (3, 10) 
   AND DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005

--Exercise 04
SELECT FirstName, LastName
  FROM Employees
 WHERE JobTitle NOT LIKE '%engineer%'

--Exercise 05
SELECT [Name] 
  FROM Towns
 WHERE LEN([Name]) BETWEEN 5 AND 6
 ORDER BY [Name]

--Exercise 06
SELECT * 
  FROM Towns
 WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
 ORDER BY [Name]

--Exercise 07
SELECT * 
  FROM Towns
 WHERE NOT LEFT([Name], 1) IN ('R', 'B', 'D')
 ORDER BY [Name]

--Exercise 08
GO

CREATE VIEW V_EmployeesHiredAfter2000 AS 
SELECT FirstName, LastName FROM Employees
WHERE YEAR(HireDate) > 2000

GO

--Exercise 09
SELECT FirstName, LastName 
  FROM Employees
 WHERE LEN(LastName) = 5

--Exercise 10
SELECT EmployeeID
     , FirstName
     , LastName
     , Salary
     , DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank
  FROM Employees
 WHERE Salary BETWEEN 10000 AND 50000
 ORDER BY Salary DESC 

--Exercise 11
  SELECT * 
    FROM (
          SELECT EmployeeID
              , FirstName
              , LastName
              , Salary
              , DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank
            FROM Employees
          WHERE Salary BETWEEN 10000 AND 50000
        )
      AS Selection
   WHERE Rank = 2
ORDER BY Salary DESC 

