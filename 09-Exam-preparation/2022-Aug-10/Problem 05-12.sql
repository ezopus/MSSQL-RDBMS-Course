-- Problem 05
SELECT Name, Age, PhoneNumber, Nationality
FROM Tourists
ORDER BY Nationality, Age DESC, Name 

-- Problem 06
SELECT s.Name AS [Site],
		l.Name AS [Location],
		s.Establishment AS [Establishment],
		c.Name AS [Category]
FROM Sites AS s
JOIN Locations AS l
ON s.LocationId = l.Id
JOIN Categories AS c
ON s.CategoryId = c.Id
ORDER BY [Category] DESC, [Location], [Site]

-- Problem 07
SELECT [l].[Province],
	   [l].[Municipality],
	   [l].[Name] AS [Location],
	   COUNT([l].[Id]) AS [CountOfSites]
FROM [Sites] AS [s]
JOIN [Locations] AS [l]
ON [s].LocationId = [l].Id
WHERE Province = 'Sofia'
GROUP BY [l].Province, [l].[Municipality], [l].[Name]
ORDER BY CountOfSites DESC, Location


-- Problem 08
SELECT [s].[Name] AS [Site],
	   [l].[Name] AS [Location],
	   [l].Municipality,
	   [l].Province,
	   [s].[Establishment]
FROM Sites AS [s]
JOIN [Locations] AS [l]
ON [s].LocationId = [l].[Id]
WHERE LEFT([l].Name, 1) NOT IN ('B', 'M', 'D') AND [s].Establishment LIKE '%BC'
ORDER BY [s].[Name]


-- Problem 09
SELECT [t].[Name] AS [Name],
		[t].[Age],
		[t].PhoneNumber,
		[t].Nationality,
		CASE
			WHEN [b].Name IS NULL THEN '(no bonus prize)'
			ELSE [b].Name
		END AS [Reward]
FROM [Tourists] AS [t]
LEFT JOIN [TouristsBonusPrizes] AS [tb]
ON [t].Id = [tb].[TouristId]
LEFT JOIN [BonusPrizes] AS [b]
ON [b].Id = [tb].BonusPrizeId
ORDER BY [t].[Name]


-- Problem 10
SELECT DISTINCT RIGHT([t].[Name], LEN([t].[Name]) - CHARINDEX(' ', [t].[Name])) AS [LastName],
	   [t].[Nationality],
	   [t].[Age],
	   [t].[PhoneNumber]
FROM [Tourists] AS [t]
LEFT JOIN [SitesTourists] AS [st]
ON [t].Id = [st].TouristId
JOIN [Sites] AS [s]
ON [s].[Id] = [st].[SiteId]
JOIN [Categories] AS [c]
ON [c].[Id] = [s].CategoryId
WHERE [c].[Name] = 'History and archaeology'
ORDER BY [LastName]

--SELECT RIGHT([t].[Name], LEN([t].[Name]) - CHARINDEX(' ', [t].[Name]))
--FROM [Tourists] AS [t]



-- Problem 11
GO
CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(100))
RETURNS INT
AS
BEGIN
	DECLARE @count INT = (
						SELECT COUNT([s].[Name])
						FROM [Sites] AS [s]
						JOIN [SitesTourists] AS [st]
						ON [s].[Id] = [st].[SiteId]
						WHERE [s].[Name] = @Site 
						)
	RETURN @count
END

SELECT dbo.udf_GetTouristsCountOnATouristSite ('Regional History Museum – Vratsa')
SELECT dbo.udf_GetTouristsCountOnATouristSite ('Samuil’s Fortress')
GO

-- Problem 12
CREATE OR ALTER PROC usp_AnnualRewardLottery(@TouristName VARCHAR(50))
AS
BEGIN
	DECLARE @siteCount INT = ( 
								SELECT COUNT([t].[Name])
								FROM [Tourists] AS [t]
								JOIN [SitesTourists] AS [st]
								ON [t].[Id] = [st].[TouristId]
								WHERE [t].[Name] = @TouristName
							 )
	UPDATE [Tourists]
	SET [Reward] =  CASE
						WHEN @siteCount >= 100 THEN 'Gold badge'
						WHEN @siteCount >= 50 THEN 'Silver badge'
						WHEN @siteCount >= 25 THEN 'Bronze badge'
					END		
	WHERE [Name] = @TouristName

	SELECT Name,
			Reward
	FROM [Tourists]
	WHERE Name = @TouristName		
END

GO

EXEC dbo.usp_AnnualRewardLottery 'Gerhild Lutgard'

EXEC dbo.usp_AnnualRewardLottery 'Teodor Petrov'