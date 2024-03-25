-- Problem 05
  SELECT [DateOfDeparture],
	     [Price] AS [TicketPrice]
    FROM [Tickets]
ORDER BY [Price], [DateOfDeparture] DESC


-- Problem 06
	SELECT [p].[Name] AS [PassengerName]
		   , [t].[Price] AS [TicketPrice]
		   , [t].[DateOfDeparture]
		   , [t].[TrainId]
	  FROM [Tickets] 
		AS [t]
	  JOIN [Passengers] 
		AS [p]
		ON [t].[PassengerId] = [p].Id
  ORDER BY [t].[Price] DESC, [p].[Name]



-- Problem 07
   SELECT [t].[Name] AS [Town],
          [rs].[Name] AS [RailwayStation]
     FROM [Towns]
       AS [t]
LEFT JOIN [RailwayStations]
       AS [rs]
       ON [t].Id = [rs].[TownId]
LEFT JOIN [TrainsRailwayStations]
       AS [trs]
       ON [trs].[RailwayStationId] = [rs].[Id]
    WHERE [trs].[TrainId] IS NULL
 ORDER BY [t].[Name], [rs].[Name]


 -- Problem 08
 SELECT TOP(3) [tr].[Id] AS [TrainId],
			   [tr].[HourOfDeparture],
			   [ti].[Price] AS [TicketPrice],
			   [to].[Name] AS [Destination]
          FROM [Trains]
    	    AS [tr]
    	  JOIN [Towns]
    	    AS [to]
    	    ON [to].Id = [tr].ArrivalTownId
    	  JOIN [Tickets]
    	    AS [ti]
    	    ON [tr].[Id] = [ti].[TrainId]
    	 WHERE (LEFT([tr].[HourOfDeparture], 2) LIKE '08' AND [ti].[Price] > 50)
      ORDER BY [ti].[Price]


-- Problem 09
SELECT [to].[Name] AS [TownName],
	   COUNT([to].[Name])
FROM [Passengers]
AS [p]
JOIN [Tickets]
AS [ti]
ON [p].[Id] = [ti].[PassengerId]
JOIN [Trains]
AS [tr]
ON [ti].[TrainId] = [tr].[Id]
JOIN [Towns]
AS [to]
ON [to].[Id] = [tr].[ArrivalTownId]
WHERE [ti].[Price] > 76.99
GROUP BY [to].[Name]
ORDER BY [TownName]


-- Problem 10
SELECT [tr].[Id] AS [TrainID],
	   [to].[Name] AS [DepartureTown],
	   [m].[Details] AS [Details]
FROM [MaintenanceRecords]
AS [m]
JOIN [Trains]
AS [tr]
ON [m].[TrainId] = [tr].[Id]
JOIN [Towns]
AS [to]
ON [tr].[DepartureTownId] = [to].[Id]
WHERE [m].[Details] LIKE '%inspection%'
ORDER BY [tr].[Id]


-- Problem 11
GO

CREATE FUNCTION udf_TownsWithTrains(@name VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @count INT = (SELECT COUNT(*)
						  FROM [Towns]
							AS [to]
					 LEFT JOIN [Trains]
							AS [arr]
							ON [to].[Id] = [arr].[ArrivalTownId] OR [to].[Id] = [arr].[DepartureTownId]
						 WHERE [to].[Name] = @name)
	RETURN @count
END

SELECT dbo.udf_TownsWithTrains ('Paris')

GO


-- Problem 12
CREATE OR ALTER PROC usp_SearchByTown @townName VARCHAR(30)
AS
BEGIN
	  SELECT [p].[Name] AS [PassengerName],
			 [ti].[DateOfDeparture] AS [DateOfDeparture],
			 [tr].[HourOfDeparture] AS [HourOfDeparture]
		FROM [Passengers]
		  AS [p]
		JOIN [Tickets]
		  AS [ti]
		  ON [p].[Id] = [ti].[PassengerId]
		JOIN [Trains]
		  AS [tr]
		  ON [tr].[Id] = [ti].[TrainId]
		JOIN [Towns]
		  AS [to]
		  ON [to].[Id] = [tr].[ArrivalTownId]
	   WHERE [to].[Name] = @townName
	ORDER BY [ti].[DateOfDeparture] DESC, [p].[Name]
END

EXEC usp_SearchByTown 'Berlin'