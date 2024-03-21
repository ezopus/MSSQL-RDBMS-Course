USE [Bank]

GO

-- Exercise 09
CREATE OR ALTER PROC usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
	FROM [AccountHolders]
END

GO

-- Exercise 10
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@limit MONEY)  --very important to allow floating point numbers
AS
BEGIN
	  SELECT [FirstName]
			 , [LastName]
		FROM (
			  SELECT [ah].[FirstName]
					 , [ah].[LastName]
					 , SUM([Balance]) AS [TotalSum]
				FROM [AccountHolders] AS [ah]
				JOIN [Accounts] AS [a] ON [ah].Id = [a].AccountHolderId
			GROUP BY [ah].FirstName, [ah].LastName
			  HAVING SUM([Balance]) > @limit
			 ) 
		  AS [dt]
	ORDER BY [dt].[FirstName], [dt].[LastName]
END

EXEC [dbo].[usp_GetHoldersWithBalanceHigherThan] 7000

EXEC [dbo].[usp_GetHoldersWithBalanceHigherThan] 0.2

GO


-- Exercise 11


CREATE OR ALTER FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18,4), @yearlyRate FLOAT, @years INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
	DECLARE @futureValueOutput DECIMAL(18,4) = @sum * (POWER((1 + @yearlyRate), @years))

	RETURN @futureValueOutput
END

GO

SELECT [dbo].[ufn_CalculateFutureValue](1000.98, 0.05, 3)

GO

