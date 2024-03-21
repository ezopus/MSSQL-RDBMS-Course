-- Exercise 01
  SELECT TOP (5) EmployeeID
       , JobTitle
       , e.AddressID 
       , [AddressText]
    FROM Employees AS e
    JOIN Addresses AS a ON a.AddressID = e.AddressID
ORDER BY e.AddressID

-- Exercise 02
SELECT TOP (50) 
           FirstName
         , LastName 
         , t.Name AS [Town]
         , AddressText
    FROM Employees AS e
    JOIN Addresses AS a ON a.AddressID = e.AddressID
    JOIN Towns AS t ON t.TownID = a.TownID
ORDER BY FirstName, LastName

-- Exercise 03
SELECT 
    e.EmployeeID
    , e.FirstName
    , e.LastName
    , d.Name
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.Name = 'Sales'

-- Exercise 04
SELECT TOP (5)
    e.EmployeeID
    , e.FirstName
    , e.Salary
    , d.Name AS [DepartmentName]
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID

-- Exercise 05
SELECT TOP (3)
    e.EmployeeID AS EmployeeID
    , e.FirstName AS FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY e.EmployeeID

-- Exercise 06
   SELECT FirstName
		, LastName
		, HireDate
		, d.Name as DeptName
	 FROM Employees AS e
LEFT JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
	WHERE d.Name IN ('Sales', 'Finance') AND DATEPART(YEAR, e.HireDate) >= 1999
 ORDER BY e.HireDate

-- Exercise 07
SELECT TOP (5)
	e.EmployeeID
	, e.FirstName
	, p.Name AS ProjectName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep 
	   ON e.EmployeeID = ep.EmployeeID
	 JOIN Projects AS p 
	   ON ep.ProjectID = p.ProjectID
WHERE DATEPART(YEAR, p.StartDate) > '13.08.2002' AND p.EndDate IS NULL
ORDER BY e.EmployeeID

-- Exercise 08
   SELECT e.EmployeeID AS EmployeeID
	    , e.FirstName AS FirstName
		, CASE 
			WHEN YEAR(p.StartDate) >= 2005 THEN ''
			ELSE p.Name
		  END AS ProjectName
     FROM Employees AS e
     JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
	 JOIN Projects AS p ON ep.ProjectID = p.ProjectID
    WHERE e.EmployeeID = 24 

-- Exercise 09
  SELECT e.EmployeeID
       , e.FirstName AS FirstName
	   , m.EmployeeID AS ManagerID
	   , m.FirstName AS ManagerName
    FROM Employees AS e
    JOIN Employees AS m ON e.ManagerID = m.EmployeeID
   WHERE e.ManagerID IN (3,7)
ORDER BY e.EmployeeID

-- Exercise 10
SELECT TOP (50) e.EmployeeID AS EmployeeID
				, CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName
				, CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName
				, d.Name AS DepartmentName
FROM [Employees] AS e
JOIN [Employees] AS m ON e.ManagerID = m.EmployeeID
LEFT JOIN [Departments] AS d ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID

-- Exercise 11
SELECT TOP (1) MinAverageSalary
      FROM (
			SELECT AVG(Salary) AS MinAverageSalary
					, e.DepartmentID
			 FROM [Employees] AS [e]
			 JOIN [Departments] AS d ON [e].DepartmentID = [d].DepartmentID
		 GROUP BY [e].DepartmentID
			 ) AS avgSal
  ORDER BY MinAverageSalary
