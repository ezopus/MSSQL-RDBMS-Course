--Exercise 12
GO
USE [Geography]

  SELECT CountryName, IsoCode 
    FROM Countries
   WHERE LOWER(CountryName) LIKE '%a%a%a%'
ORDER BY IsoCode

--Exercise 13
  SELECT p.PeakName
       , r.RiverName
       , LOWER(CONCAT(LEFT(p.PeakName, LEN(p.PeakName) - 1), r.RiverName))
      AS Mix
    FROM Peaks AS p,
         Rivers AS r
   WHERE RIGHT(p.PeakName, 1) = LEFT (r.RiverName, 1)
ORDER BY Mix

--Exercise 14
GO
USE Diablo

  SELECT TOP(50)
         [Name]
         , FORMAT([Start], 'yyyy-MM-dd') AS [Start]
    FROM Games
   WHERE DATEPART(YEAR, [Start]) BETWEEN 2011 AND 2012
ORDER BY [Start], [Name]

--Exercise 15
  SELECT Username
       , SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS [Email Provider] 
    FROM Users
ORDER BY [Email Provider], Username

--Exercise 16
  SELECT Username, IpAddress
    FROM Users
   WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--Exercise 17
SELECT [Name] AS [Game],
        CASE
            WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
            WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS [Part of the Day],
        CASE
            WHEN [Duration] <= 3 THEN 'Extra Short'
            WHEN [Duration] <= 6 THEN 'Short'
            WHEN [Duration] > 6 THEN 'Long'
            ELSE 'Extra Long'
        END AS [Duration]
FROM Games as g
ORDER BY g.Name, [Duration], [Part of the Day]

--Exercise 18
GO
USE Orders

SELECT ProductName
     , OrderDate AS [OrderDate]
     , DATEADD(day, 3, OrderDate) AS [Pay Due]
     , DATEADD(month, 1, OrderDate) AS [Deliver Due]
FROM Orders


--Exercise 19
CREATE TABLE People (
    [Id] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL,
    [Birthdate] DATETIME2 NOT NULL
)

INSERT INTO People ([Name], [Birthdate])
    VALUES
        ('Victor', '2000-12-07'),
        ('Steven', '1992-09-10'),
        ('Stephen', '1910-09-19'),
        ('John', '2010-01-06')

SELECT [Name]
     , DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years]
     , DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months]
     , DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days]
     , DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
FROM People
