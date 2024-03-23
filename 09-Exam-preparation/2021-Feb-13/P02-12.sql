-- Problem 02

INSERT INTO [Files] ([Name], [Size], [ParentId], [CommitId])
	 VALUES 
('Trade.idk', 2598.0, 1, 1),
('menu.net', 9238.31, 2, 2),
('Administrate.soshy', 1246.93, 3, 3),
('Controller.php', 7353.15, 4, 4),
('Find.java', 9957.86, 5, 5),
('Controller.json', 14034.87, 3, 6),
('Operate.xix', 7662.92, 7, 7)


INSERT INTO [Issues] ([Title], [IssueStatus], [RepositoryId], [AssigneeId])
	 VALUES
('Critical Problem with HomeController.cs file', 'open', 1, 4),
('Typo fix in Judge.html', 'open', 4, 3),
('Implement documentation for UsersService.cs', 'closed', 8, 2),
('Unreachable code in Index.cs', 'open', 9, 8)


-- Problem 03
UPDATE [Issues]
   SET [IssueStatus] = 'closed'
 WHERE [AssigneeId] = 6

 -- Problem 04

 --delete from repositories where name matches
 DELETE FROM [RepositoriesContributors]
	   WHERE [RepositoryId] = ( SELECT [Id]
								FROM [Repositories]
								WHERE [Name] = 'Softuni-Teamwork'
								)
--delete from commits all issues who are from that repository
DELETE FROM [Commits]
	  WHERE [IssueId] IN (
							SELECT [Id]
							FROM [Issues]
							WHERE [RepositoryId] = (
													SELECT [Id]
													FROM [Repositories]
													WHERE [Name] = 'Softuni-Teamwork'
													)
						 )

-- delete all issues from that repository
DELETE FROM [Issues]
	  WHERE [RepositoryId] = ( SELECT [Id]
								FROM [Repositories]
								WHERE [Name] = 'Softuni-Teamwork'
								)
-- Problem 05
SELECT [Id]
	   ,[Message]
	   ,[RepositoryId]
	   ,[ContributorId]
FROM [Commits]
ORDER BY [Id], [Message], [RepositoryId], [ContributorId]

-- Problem 06
   SELECT [Id]
         , [Name]
	     , [Size]
    FROM [Files]
   WHERE [Size] > 1000 AND [Name] LIKE '%html%'
ORDER BY [Size] DESC, [Id], [Name]


-- Problem 07
  SELECT [i].[Id],
	      CONCAT([u].[Username], ' : ', [i].[Title])
    FROM [Issues] AS [i]
    JOIN [Users] AS [u] ON [u].Id = [i].[AssigneeId]
ORDER BY [i].[Id] DESC, [i].[AssigneeId]


-- Problem 08
SELECT [f].[Id]
		, [f].[Name]
		, CONCAT([f].[Size], 'KB') AS [Size]
FROM [Files] AS [f]
LEFT JOIN [Files] AS [pf] ON [f].Id = [pf].ParentId
WHERE [pf].[Id] IS NULL
ORDER BY [f].[Id], [f].[Name], [f].[Size] DESC


-- Problem 09
SELECT TOP (5) [r].[Id],
			   [r].Name,
			   COUNT([r].[Id])
			AS [Commits]
		  FROM [Repositories]
			AS [r]
		  JOIN [Commits]
			AS [c]
			ON [r].Id = [c].RepositoryId
		  JOIN [RepositoriesContributors]
			AS [rc]
			ON [rc].RepositoryId = [r].Id
	  GROUP BY [r].Id, [r].Name
	  ORDER BY [Commits] DESC, [r].[Id], [r].Name


-- Problem 10
  SELECT [u].[Username],
		 AVG([f].[Size])
	  AS [Size]
    FROM [Users]
      AS [u]
  RIGHT JOIN [Commits]
      AS [c]
      ON [c].ContributorId = [u].[Id]
    JOIN [Files]
	  AS [f]
	  ON [f].CommitId = [c].Id
GROUP BY [u].Username
ORDER BY [Size] DESC, [u].[Username]



-- Problem 11
GO
CREATE OR ALTER FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @count INT
	SET @count = 
				(
					SELECT COUNT([c].[Id])
					FROM [Users]
					AS [u]
					JOIN [Commits]
					AS [c]
					ON [c].ContributorId = [u].[Id]
					WHERE [u].[Username] = @username
				)
	RETURN @count
END

GO


-- Problem 12
CREATE OR ALTER PROC usp_SearchForFiles(@fileExtension VARCHAR(4))
AS
BEGIN
	  SELECT [Id],
	         [Name],
			 CONCAT([Size], 'KB') 
	      AS [Size]
	    FROM [Files]
	   WHERE [Name] LIKE CONCAT('%', @fileExtension, '%')
	ORDER BY [Id], [Name], [Size] DESC
END

EXEC usp_SearchForFiles 'txt'