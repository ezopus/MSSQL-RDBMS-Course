-- Problem 05
SELECT [Name],
		[Rating]
FROM [BoardGames]
ORDER BY [YearPublished], [Name] DESC


-- Problem 06
SELECT [bg].[Id],
		[bg].[Name],
		[bg].[YearPublished],
		[cat].[Name] AS [CategoryName]
FROM [BoardGames] AS [bg]
JOIN [Categories] AS [cat]
ON [cat].[Id] = [bg].[CategoryId]
WHERE [cat].[Name] IN ('Strategy Games', 'Wargames')
ORDER BY [bg].[YearPublished] DESC


-- Problem 07
SELECT [c].[Id],
		CONCAT([c].[FirstName], ' ', [c].LastName) AS [CreatorName],
		[c].[Email]
FROM [Creators] AS [c]
LEFT JOIN [CreatorsBoardgames] AS [cb]
ON [cb].CreatorId = [c].[Id]
LEFT JOIN [Boardgames] AS [b]
ON [b].[Id] = [cb].[BoardgameId]
WHERE [b].Id IS NULL
ORDER BY [CreatorName]


-- Problem 08
SELECT TOP (5) [b].[Name],
				[b].[Rating],
				[c].[Name] AS [CategoryName]
FROM [Boardgames] AS [b]
JOIN [PlayersRanges] AS [pr]
ON [pr].Id = [b].PlayersRangeId
JOIN [Categories] AS [c]
ON [c].Id = [b].[CategoryId]
WHERE ([b].[Rating] > 7 AND [b].[Name] LIKE '%a%') OR ([b].[Rating] > 7.5 AND [pr].PlayersMin = 2 AND [pr].[PlayersMax] = 5)
ORDER BY [b].[Name], [b].Rating DESC



-- Problem 09
SELECT [dt].FullName,
		[dt].Email,
		MAX(dt.Rating) AS [Rating]
FROM (
		SELECT [c].FirstName + ' ' + [c].LastName AS [FullName],
				[c].Email AS [Email],
				[b].[Rating] AS [Rating]
		FROM [Creators] AS [c]
		JOIN [CreatorsBoardgames] AS [cb]
		ON [cb].[CreatorId] = [c].Id
		JOIN [BoardGames] AS [b]
		ON [b].[Id] = [cb].[BoardgameId]
		WHERE RIGHT([c].[Email], 4) = '.com'
	) AS [dt]
GROUP BY [dt].[FullName], [dt].[Email]
ORDER BY [dt].FullName



-- Problem 10
SELECT [dt].[LastName],
	   CEILING(AVG([dt].[Rating])) AS [AverageRating],
	   [dt].[PublisherName]
FROM (
		SELECT [c].[LastName],
			   [b].[Rating] AS [Rating],
			   [p].[Name] AS [PublisherName]
		FROM [Creators] AS [c]
		JOIN [CreatorsBoardgames] AS [cb]
		ON [c].[Id] = [cb].[CreatorId]
		RIGHT JOIN [Boardgames] AS [b]
		ON [cb].[BoardgameId] = [b].[Id]
		JOIN [Publishers] AS [p]
		ON [b].[PublisherId] = [p].[Id]
		WHERE [c].LastName IS NOT NULL AND [p].Name = 'Stonemaier Games'
	) AS [dt]
GROUP BY [dt].LastName, [dt].PublisherName
ORDER BY AVG([dt].[Rating]) DESC


-- Problem 11
GO

CREATE OR ALTER FUNCTION udf_CreatorWithBoardgames(@name VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @count INT = ( SELECT COUNT(*)
							FROM [Creators] AS [c]
							JOIN [CreatorsBoardgames] AS [cb]
							ON [c].[Id] = [cb].[CreatorId]
							JOIN [Boardgames] AS [b]
							ON [b].[Id] = [cb].[BoardgameId]
							WHERE [c].[FirstName] = @name
						)
	RETURN @count
END

GO

SELECT dbo.udf_CreatorWithBoardgames ( 'Bruno')

-- Problem 12
GO
CREATE OR ALTER PROC usp_SearchByCategory(@category VARCHAR(50)) 
AS
BEGIN
	SELECT [b].[Name] AS [Name]
			, [b].[YearPublished]
			, [b].[Rating]
			, [ca].[Name] AS [CategoryName]
			, [p].[Name] AS [PublisherName]
			, CONCAT([pr].[PlayersMin], ' people') AS [MinPlayers]
			, CONCAT([pr].[PlayersMax], ' people') AS [MaxPlayers]
	FROM [Categories] AS [ca]
	JOIN [Boardgames] AS [b]
	ON [b].CategoryId = [ca].Id
	JOIN [Publishers] AS [p]
	ON [b].[PublisherId] = [p].[Id]
	JOIN [PlayersRanges] AS [pr]
	ON [b].[PlayersRangeId] = [pr].[Id]
	WHERE [ca].Name = @category
	ORDER BY [p].[Name], [b].YearPublished DESC
END

GO

EXEC dbo.usp_SearchByCategory 'Wargames'