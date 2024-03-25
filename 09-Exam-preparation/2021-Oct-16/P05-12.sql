-- Problem 05
  SELECT [CigarName]
	     , [PriceForSingleCigar]
	     , [ImageURL]
    FROM [Cigars]
ORDER BY [PriceForSingleCigar], [CigarName] DESC


-- Problem 06
	SELECT [c].[Id]
		   , [c].[CigarName]
		   , [c].[PriceForSingleCigar]
		   , [t].[TasteType]
		   , [t].[TasteStrength]
	  FROM [Cigars] 
		AS [c]
	  JOIN [Tastes] 
		AS [t]
		ON [t].Id = [c].[TastId]
	 WHERE [t].TasteType = 'Earthy' OR [t].[TasteType] = 'Woody'
  ORDER BY [c].[PriceForSingleCigar] DESC


-- Problem 07
   SELECT [c].[Id],
          CONCAT([c].[FirstName], ' ', [c].[LastName])
	   AS [ClientName],
	      [c].[Email]
     FROM [Clients]
       AS [c]
LEFT JOIN [ClientsCigars]
       AS [cc]
	   ON [c].[Id] = [cc].[ClientId]
    WHERE [cc].ClientId IS NULL
 ORDER BY [ClientName]
	

-- Problem 08
SELECT TOP (5) c.CigarName,
  		       c.PriceForSingleCigar,
  		       c.ImageURL
          FROM Cigars
            AS c
    INNER JOIN Sizes
            AS s
            ON c.SizeId = s.Id
         WHERE (s.[Length] >= 12 AND (c.CigarName LIKE '%ci%' OR (c.PriceForSingleCigar > 50 AND s.RingRange > 2.55)))
      ORDER BY c.CigarName, c.PriceForSingleCigar DESC


-- Problem 09
  SELECT [FullName],
		 [Country],
		 [ZIP],
		 [CigarPrice]
	FROM (

			SELECT CONCAT(c.FirstName, ' ', c.LastName) AS [FullName],
			   a.Country,
			   a.ZIP,
			   CONCAT('$', ci.PriceForSingleCigar) AS [CigarPrice],
			   DENSE_RANK() OVER (PARTITION BY a.ZIP ORDER BY ci.PriceForSingleCigar DESC) AS [CigarRank]
		  FROM Clients
			AS c
		  JOIN ClientsCigars
			AS cc
			ON c.Id = cc.ClientId
		  JOIN Addresses
			AS a
			ON c.AddressId = a.Id
		  JOIN Cigars
			AS ci
			ON cc.CigarId = ci.Id
		 WHERE a.ZIP NOT LIKE '%[^0-9]%'
		 )
	   AS [query]
	WHERE [CigarRank] = 1
 ORDER BY [FullName]


 -- Problem 10
    SELECT [c].[LastName],
		   AVG([s].[Length]) AS [CigarLength],
		   CEILING(AVG(s.RingRange)) AS [CigarRingRange] 
      FROM [Clients]
        AS [c]
INNER JOIN [ClientsCigars]
		AS [cc]
		ON [c].Id = cc.ClientId
	  JOIN [Cigars]
	    AS [ci]
		ON [cc].CigarId = [ci].Id
      JOIN [Sizes]
	    AS [s]
		ON [ci].[SizeId] = [s].[Id]
  GROUP BY [c].[LastName]
  ORDER BY [CigarLength] DESC

  GO

  -- Problem 11
  CREATE OR ALTER FUNCTION udf_ClientWithCigars(@name NVARCHAR(30))
  RETURNS INT
  AS
  BEGIN
		DECLARE @cigarCount INT
		SET @cigarCount = (SELECT COUNT(*) 
					          		  AS [CigarCount]
					          	    FROM [Clients]
					          	      AS [c]
					           LEFT JOIN [ClientsCigars]
					          	      AS [cc]
					          	      ON [c].[Id] = [cc].[ClientId]
					          	   WHERE [c].[FirstName] = @name
					      )
		
		RETURN @cigarCount
  END

  GO

  SELECT dbo.udf_ClientWithCigars('Betty')
  SELECT dbo.udf_ClientWithCigars('2')

  GO

  -- Problem 12
CREATE OR ALTER PROC usp_SearchByTaste @taste VARCHAR(20)
AS
BEGIN
	SELECT [ci].[CigarName],
		   CONCAT('$', [ci].[PriceForSingleCigar]) AS [Price],
		   [t].[TasteType],
		   [b].[BrandName],
		   CONCAT([s].[Length], ' cm') AS [CigarLength],
		   CONCAT([s].[RingRange], ' cm') AS [CigarRingRange]
	  FROM [Cigars]
	    AS [ci]
	  JOIN [Sizes]
	    AS [s]
		ON [ci].[SizeId] = [s].[Id]
	  JOIN [Brands]
	    AS [b]
		ON [ci].[BrandId] = [b].[Id]
	  JOIN [Tastes]
	    AS [t]
		ON [ci].[TastId] = [t].[Id]
     WHERE [t].[TasteType] = @taste
  ORDER BY [CigarLength], [CigarRingRange] DESC
END

GO

EXEC usp_SearchByTaste 'Woody'