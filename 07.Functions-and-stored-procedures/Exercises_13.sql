USE [Diablo]

GO
-- Exercise 13

CREATE OR ALTER FUNCTION [ufn_CashInUsersGames](@gameName NVARCHAR(50))
RETURNS TABLE
AS RETURN (
			SELECT SUM([Cash]) AS [SumCash]
			FROM (
					SELECT [Cash]
	  					   ,ROW_NUMBER() OVER (ORDER BY [Cash] DESC) AS [RowNumber]
					  FROM [UsersGames] 
						AS [ug]
					  JOIN [Games] 
						AS [g] 
						ON [ug].GameId = [g].Id
					 WHERE [g].Name = @gameName
				) 
			   AS [SumQuery]
			WHERE [SumQuery].[RowNumber] % 2 <> 0
	      )	

GO

SELECT * FROM [dbo].[ufn_CashInUsersGames]('Love in a mist')