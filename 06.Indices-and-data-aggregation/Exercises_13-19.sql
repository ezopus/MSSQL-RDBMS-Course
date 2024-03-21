USE SoftUni 

GO

-- Exercise 13
  SELECT [DepartmentID]
		 ,SUM([Salary]) AS [TotalSalary]
	FROM [Employees]
GROUP BY [DepartmentID]
ORDER BY [DepartmentID]

GO

-- Exercise 14
  SELECT [DepartmentID]
	     ,MIN([Salary])
	FROM [Employees]
   WHERE [DepartmentID] IN (2, 5, 7) AND [HireDate] > '01/01/2000'
GROUP BY [DepartmentID]

GO

-- Exercise 15
SELECT *
 INTO [filteredTable]
 FROM [Employees]
WHERE [Salary] > 30000

DELETE FROM [filteredTable]
      WHERE [ManagerID] = 42

--SELECT * FROM [filteredTable]

UPDATE [filteredTable]
   SET [Salary] = [Salary] + 5000
 WHERE DepartmentID = 1

  SELECT [DepartmentID],
	     AVG([Salary])
    FROM [filteredTable]
GROUP BY [DepartmentID]

GO

DROP TABLE [filteredTable]

GO

-- Exercise 16
    SELECT [DepartmentID]
	       ,MAX([Salary]) AS [MaxSalary]
      FROM [Employees]
  GROUP BY [DepartmentID]
HAVING NOT MAX([Salary]) BETWEEN 30000 AND 70000

GO

-- Exercise 17
SELECT COUNT([Salary]) AS [Count]
  FROM [Employees]
 WHERE [ManagerID] IS NULL
 
GO

-- Exercise 18
SELECT DISTINCT [DepartmentID]
				 , [Salary]
		  FROM (
	 			SELECT [DepartmentID]
	 				  ,[Salary]
	 				  ,DENSE_RANK() OVER (PARTITION BY [DepartmentID] ORDER BY [Salary] DESC)
	 				AS [SalaryRank]
	 			  FROM [Employees]
			   )
			AS [SalaryRankingQuery]
		 WHERE [SalaryRankingQuery].SalaryRank = 3

GO


-- Exercise 19
SELECT TOP (10) [FirstName]
			    ,[LastName]
				,[DepartmentID]
		   FROM [Employees] AS [e]
	      WHERE [e].[Salary] > (
							    SELECT AVG([Salary]) AS [AverageDepartmentSalary]
			                      FROM [Employees] AS [esub]
								 WHERE [e].DepartmentID = [esub].[DepartmentID]
							  GROUP BY [DepartmentID]
							   )
	   ORDER BY [e].[DepartmentID]

GO

--select average salary of all departments
SELECT AVG(dt.AvgSalByDept)
FROM (
		SELECT [DepartmentID]
			   ,AVG([Salary]) AS [AvgSalByDept]
		FROM [Employees]
		GROUP BY [DepartmentID]
     ) AS [dt]


--select average salary of all employees
SELECT AVG([Salary])
FROM [Employees]
