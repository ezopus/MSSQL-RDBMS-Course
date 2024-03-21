USE Geography

-- Exercise 12
SELECT [c].CountryCode AS CountryCode
	, [m].MountainRange AS MountainRange
	, [p].PeakName AS PeakName
	, [p].Elevation AS Elevation
FROM [Countries] AS [c]
JOIN [MountainsCountries] AS [mc] ON mc.CountryCode = c.CountryCode
JOIN [Mountains] AS [m] ON [m].Id = [mc].MountainId
JOIN [Peaks] AS [p] ON [p].MountainId = [m].Id
WHERE [c].CountryCode = 'BG' AND [p].Elevation > 2835
ORDER BY [p].Elevation DESC

-- Exercise 13
SELECT * 
  FROM (
		  SELECT [c].CountryCode
			   , COUNT([c].CountryCode) AS [MountainRanges]
			FROM [Countries] AS [c]
			JOIN [MountainsCountries] AS [mc] ON [mc].CountryCode = [c].CountryCode
			JOIN [Mountains] AS [m] ON [m].Id = [mc].MountainId
		GROUP BY [c].CountryCode
	   ) AS dt
  WHERE dt.CountryCode IN ('BG', 'RU', 'US')

-- Exercise 14
SELECT TOP (5) [c].CountryName AS CountryName
			 , [r].RiverName AS RiverName
		  FROM [Countries] AS [c]
     LEFT JOIN [CountriesRivers] AS [cr] ON [cr].CountryCode = [c].CountryCode
     LEFT JOIN [Rivers] AS [r] ON [r].Id = [cr].RiverId
		 WHERE [c].ContinentCode = 'AF'
	  ORDER BY [c].CountryName

-- Exercise 15
SELECT [ContinentCode]
	  ,[CurrencyCode]
	  ,[CurrencyUsage]
FROM (
	SELECT *
			, DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC) AS [RankedUsage]
	  FROM (
			  SELECT [co].ContinentCode AS ContinentCode
				   , [c].CurrencyCode
				   , COUNT([c].CurrencyCode) AS CurrencyUsage
				FROM [Continents] AS [co]
				JOIN [Countries] AS [c] ON [c].ContinentCode = [co].ContinentCode
			GROUP BY [c].CurrencyCode, [co].ContinentCode
			) AS [usage]
	 WHERE [usage].[CurrencyUsage] > 1
	 ) AS dt
WHERE [RankedUsage] = 1

-- Exercise 16
SELECT COUNT([c].CountryName)
FROM [Countries] AS [c]
LEFT JOIN [MountainsCountries] AS [mc] ON [mc].CountryCode = [c].CountryCode
WHERE [mc].MountainId IS NULL

-- Exercise 17
SELECT TOP (5) CountryName
			  ,HighestPeakElevation
			  ,LongestRiverLength
	  FROM (
			SELECT *
					,DENSE_RANK() OVER (PARTITION BY CountryName ORDER BY HighestPeakElevation DESC) AS ElevationRanking
					,DENSE_RANK() OVER (PARTITION BY CountryName ORDER BY LongestRiverLength DESC) AS RiverRanking
			FROM (
					SELECT [c].CountryName
						 , [p].Elevation AS HighestPeakElevation
						 , [r].Length AS LongestRiverLength
					FROM [Countries] AS [c]
					JOIN [MountainsCountries] AS [mc] ON [mc].CountryCode = [c].CountryCode
					JOIN [Mountains] AS [m] ON [m].Id = [mc].MountainId
					JOIN [Peaks] AS [p] ON [p].MountainId = [m].Id
					JOIN [CountriesRivers] AS [cr] ON [cr].CountryCode = [c].CountryCode
					JOIN [Rivers] AS [r] ON [r].Id = [cr].RiverId
		
				 ) AS dt
		 ) AS ranked
   WHERE ranked.ElevationRanking = 1 AND ranked.RiverRanking = 1
ORDER BY ranked.HighestPeakElevation DESC, ranked.LongestRiverLength DESC, ranked.CountryName


-- Exercise 18
SELECT TOP (5)
	   [Country]
	  ,[Highest Peak Name]
	  ,[Highest Peak Elevation]
	  ,[Mountain]
FROM (
	SELECT *
		, DENSE_RANK() OVER (PARTITION BY [Country] ORDER BY [Highest Peak Elevation] DESC) AS [ElevationRank]
	FROM (
			SELECT [c].[CountryName] AS [Country]
				, CASE
					WHEN [p].[PeakName] IS NOT NULL THEN [p].[PeakName]
					ELSE '(no highest peak)'
					END AS [Highest Peak Name]
				, CASE
					WHEN [p].[Elevation] IS NOT NULL THEN [p].[Elevation]
					ELSE '0'
					END AS [Highest Peak Elevation]
				, CASE
					WHEN [m].[MountainRange] IS NOT NULL THEN [m].[MountainRange]
					ELSE '(no mountain)'
					END AS [Mountain]
			FROM Countries AS [c]
			LEFT JOIN [MountainsCountries] AS [mc] ON [mc].[CountryCode] = [c].[CountryCode]
			LEFT JOIN [Mountains] AS [m] ON [m].[Id] = [mc].MountainId
			LEFT JOIN [Peaks] AS [p] ON [p].[MountainId] = [m].Id
		) AS [query]
	) AS [rankedQuery]
WHERE [rankedQuery].[ElevationRank] = 1
ORDER BY [rankedQuery].[Country]






