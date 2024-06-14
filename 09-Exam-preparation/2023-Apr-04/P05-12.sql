-- Problem 05
  SELECT [Number],
	     [Currency]
    FROM [Invoices]
ORDER BY [Amount] DESC, [DueDate]


-- Problem 06
  SELECT [p].[Id],
		 [p].[Name],
		 [p].[Price],
		 [c].[Name] AS [CategoryName]
    FROM [Products] AS [p]
    JOIN [Categories] AS [c]
      ON [p].[CategoryId] = [c].[Id]
   WHERE [c].[Name] IN ('ADR', 'Others')
ORDER BY [p].[Price] DESC


-- Problem 07
   SELECT [c].[Id],
		  [c].[Name] AS [Client],
		  CONCAT([a].[StreetName], ' ', [a].StreetNumber, ', ', [a].[City], ', ', [a].PostCode, ', ', [co].[Name])  AS [Address]
	 FROM [Clients] AS [c]
LEFT JOIN [ProductsClients] AS [pc]
       ON [c].[Id] = [pc].[ClientId]
LEFT JOIN [Products] AS [p]
       ON [pc].[ProductId] = [p].[Id]
	 JOIN [Addresses] AS [a]
	   ON [c].AddressId = [a].[Id]
	 JOIN [Countries] AS [co]
	   ON [co].Id = [a].CountryId
    WHERE [p].[Id] IS NULL
 ORDER BY [c].[Name]


 -- Problem 08
SELECT TOP (7) [i].[Number],
               [i].[Amount],
               [c].[Name] AS [ClientName]
          FROM [Invoices] AS [i]
          JOIN [Clients] AS [c]
            ON [i].[ClientId] = [c].[Id]
         WHERE ([i].[DueDate] < '2023-01-01' AND [i].[Currency] = 'EUR')
               OR ([i].[Amount] > 500 AND LEFT([c].[NumberVAT], 2) = 'DE')
      ORDER BY [i].[Number], [i].[Amount]


-- Problem 09
-- TO DO
--author's solution
  SELECT [c].[Name] AS [Client]
         , MAX([p].[Price]) AS [Price]
   	     , [c].[NumberVAT] AS [VAT Number]
    FROM [Clients] AS [c]
    JOIN [ProductsClients] AS [pc]
      ON [c].[Id] = [pc].[ClientId]
    JOIN [Products] AS [p]
      ON [pc].[ProductId] = [p].[Id]
   WHERE RIGHT([c].[Name], 2) <> 'KG'
GROUP BY [c].[Name], [c].[NumberVAT]
ORDER BY MAX([p].[Price]) DESC

--my solution, rows 5 and 6 are switched but IDK why?
SELECT [dt].[Client],
	   [dt].[Price],
	   [dt].[VAT Number]
FROM (
		SELECT [c].[Name] AS [Client]
			   , [p].[Price] AS [Price]
			   , [c].[NumberVAT] AS [VAT Number]
			   , DENSE_RANK() OVER (PARTITION BY [c].[Id] ORDER BY [p].[Price] DESC) AS [Ranked]
		  FROM [Clients] AS [c]
		  JOIN [ProductsClients] AS [pc]
			ON [c].[Id] = [pc].[ClientId]
		  JOIN [Products] AS [p]
			ON [pc].[ProductId] = [p].[Id]
		 WHERE RIGHT([c].[Name], 2) <> 'KG'
	 ) AS [dt]
WHERE [dt].[Ranked] = 1
ORDER BY [dt].[Price] DESC

-- Problem 10
    SELECT [c].[Name],
           FLOOR(AVG([p].[Price])) AS [AveragePrice]
      FROM [Clients] AS [c]
INNER JOIN [ProductsClients] AS [pc]
	    ON [pc].[ClientId] = [c].[Id]
INNER JOIN [Products] AS [p]
	    ON [p].[Id] = [pc].[ProductId]
INNER JOIN [Vendors] AS [v]
	    ON [p].[VendorId] = [v].[Id]
     WHERE [v].[NumberVAT] LIKE '%FR%'
  GROUP BY [c].[Name]
  ORDER BY AVG([p].[Price]), [c].[Name] DESC


-- Problem 11
GO

CREATE OR ALTER FUNCTION udf_ProductWithClients(@name NVARCHAR(25))
RETURNS INT
AS
BEGIN
	DECLARE @count INT = (SELECT COUNT(*)
	                        FROM [Clients] AS [c]
	                   LEFT JOIN [ProductsClients] AS [pc]
	                          ON [c].[Id] = [pc].[ClientId]
	                   LEFT JOIN [Products] AS [p]
	                          ON [p].[Id] = [pc].[ProductId]
	                       WHERE [p].[Name] = @name)
	RETURN @count
END

GO

SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')

-- Problem 12
GO

CREATE OR ALTER PROC usp_SearchByCountry @country VARCHAR(10)
AS
BEGIN
	SELECT [v].[Name] AS [Vendor],
		   [v].[NumberVAT] AS [VAT],
		   CONCAT([a].[StreetName], ' ', [a].[StreetNumber]) AS [Street Info],
		   CONCAT([a].[City], ' ', [a].[PostCode]) AS [City Info]
	  FROM [Vendors] AS [v]
	  JOIN [Addresses] AS [a]
	    ON [v].[AddressId] = [a].[Id]
	  JOIN [Countries] AS [co]
	    ON [co].[Id] = [a].[CountryId]
	 WHERE [co].[Name] = @country
  ORDER BY [v].[Name], [a].[City]
END

EXEC usp_SearchByCountry 'France'