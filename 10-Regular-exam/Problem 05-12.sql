-- Problem 05
  SELECT Title AS [Book Title], 
  	     ISBN AS [ISBN],
    	 YearPublished AS [YearReleased]
    FROM [Books]
ORDER BY YearPublished DESC, Title


-- Problem 06
  SELECT [b].[Id],
  	     [b].[Title],
  	     [b].[ISBN],
         [g].[Name]
    FROM [Books] AS [b]
    JOIN [Genres] AS [g]
      ON [b].[GenreId] = [g].[Id]
   WHERE [g].[Name] IN ('Biography', 'Historical Fiction')
ORDER BY [g].[Name], [b].[Title]


-- Problem 07
  SELECT [l].[Name] AS [Library],
         [c].[Email] AS [Email]
    FROM [Libraries] AS [l]
    JOIN [Contacts] AS [c]
      ON [l].[ContactId] = [c].[Id]
   WHERE [l].[Id] NOT IN (
                          SELECT [l].[Id]
                          FROM [Libraries] AS [l]
                          JOIN [LibrariesBooks] AS [lb]
                          ON [l].[Id] = [lb].[LibraryId]
                          JOIN [Books] AS [b]
                          ON [lb].[BookId] = [b].[Id]
                          JOIN [Genres] AS [g]
                          ON [b].[GenreId] = [g].[Id]
                          WHERE [g].[Name] = 'Mystery'
                         )
ORDER BY [Library]


-- Problem 08
SELECT TOP (3) [b].[Title] AS [Title],
               [b].[YearPublished] AS [Year],
        	   [g].[Name] AS [Genre]
          FROM [Books] AS [b]
          JOIN [Genres] AS [g]
        ON [b].[GenreId] = [g].[Id]
         WHERE ([b].[YearPublished] > 2000 AND [b].[Title] LIKE '%a%')
         	   OR
               ([b].[YearPublished] < 1950 AND [g].[Name] LIKE 'Fantasy')
      ORDER BY [b].[Title], [b].[YearPublished] DESC


-- Problem 09
  SELECT [a].[Name] AS [Author],
  	     [c].[Email],
   	     [c].[PostAddress] AS [Address]
    FROM [Authors] AS [a]
    JOIN [Contacts] AS [c]
      ON [a].[ContactId] = [c].[Id]
   WHERE [c].[PostAddress] LIKE '%UK'
ORDER BY [a].[Name]


-- Problem 10
  SELECT [a].[Name] AS [Author],
         [b].[Title] AS [Title],
	     [l].[Name] AS [Library],
	     [c].[PostAddress] AS [Library Address]
    FROM [LibrariesBooks] AS [lb]
    JOIN [Books] AS [b]
      ON [lb].[BookId] = [b].[Id]
    JOIN [Libraries] AS [l]
      ON [lb].[LibraryId] = [l].[Id]
    JOIN [Genres] AS [g]
      ON [b].[GenreId] = [g].[Id]
    JOIN [Contacts] AS [c]
      ON [l].[ContactId] = [c].[Id]
    JOIN [Authors] AS [a]
      ON [a].[Id] = [b].[AuthorId]
   WHERE [g].[Name] = 'Fiction' AND [c].[PostAddress] LIKE '%Denver%'
ORDER BY [Title]


-- Problem 11
GO
CREATE FUNCTION udf_AuthorsWithBooks(@name NVARCHAR(100))
RETURNS INT
AS
BEGIN
	DECLARE @count INT = (
	                       SELECT COUNT([b].[Id])
	                              FROM [Books] AS [b]
	                              JOIN [Authors] AS [a]
	                                ON [b].[AuthorId] = [a].[Id]
	                             WHERE [a].[Name] = @name
					     )
	RETURN @count
END

SELECT dbo.udf_AuthorsWithBooks ('J.K. Rowling')

-- Problem 12
GO
CREATE PROC usp_SearchByGenre(@genreName NVARCHAR(30))
AS
BEGIN
	  SELECT [b].[Title],
	         [b].[YearPublished] AS [Year],
	  	     [b].[ISBN],
	  	     [a].[Name] AS [Author],
	  	     [g].[Name] AS [Genre]
	    FROM [Books] AS [b]
	    JOIN [Genres] AS [g]
	      ON [b].[GenreId] = [g].[Id]
	    JOIN [Authors] AS [a]
	      ON [a].[Id] = [b].[AuthorId]
	   WHERE [g].[Name] = @genreName
	ORDER BY [b].[Title]
END

EXEC dbo.usp_SearchByGenre 'Fantasy'
