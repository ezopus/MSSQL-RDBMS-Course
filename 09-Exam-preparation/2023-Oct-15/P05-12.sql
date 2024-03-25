-- Problem 05
SELECT CAST([b].[ArrivalDate] AS DATE) AS [ArrivalDate],
	   [b].AdultsCount,
	   [b].ChildrenCount
FROM [Bookings] 
AS [b]
JOIN [Rooms]
AS [r]
ON [b].[RoomId] = [r].[Id]
ORDER BY [r].[Price] DESC, [b].[ArrivalDate]


-- Problem 06
  SELECT [h].[Id],
	     [h].[Name]
    FROM [Hotels]
	  AS [h]
	JOIN [HotelsRooms]
	  AS [hr]
	  ON [h].[Id] = [hr].[HotelId]
	JOIN [Rooms]
	  AS [r]
	  ON [hr].[RoomId] = [r].[Id]
	JOIN [Bookings]
	  AS [b]
      ON [b].HotelId = [h].[Id]
   WHERE [r].[Type] = 'VIP Apartment'
GROUP BY [h].[Id], [h].[Name]
ORDER BY COUNT([h].[Id]) DESC


-- Problem 07
   SELECT [t].[Id],
	      [t].[Name],
	      [t].[PhoneNumber]
	 FROM [Tourists]
	   AS [t]
LEFT JOIN [Bookings]
	   AS [b]
	   ON [b].[TouristId] = [t].Id
	WHERE [b].[Id] IS NULL
 ORDER BY [t].[Name]


 -- Problem 08
 SELECT TOP(10) [h].[Name] AS [HotelName],
				[d].[Name] AS [DestinationName],
				[c].[Name] AS [CountryName]
           FROM [Bookings]
             AS [b]
           JOIN [Hotels]
             AS [h]
             ON [h].[Id] = [b].[HotelId]
           JOIN [Destinations]
             AS [d]
             ON [d].Id = [h].DestinationId
           JOIN [Countries]
             AS [c]
             ON [c].[Id] = [d].[CountryId]
          WHERE [b].[ArrivalDate] < '2023-12-31' AND [h].Id % 2 <> 0
       ORDER BY [c].[Name], [b].[ArrivalDate]


-- Problem 09
-- TO DO

SELECT [h].[Name] AS [HotelName],
	   [r].[Price] AS [RoomPrice]
FROM [Hotels]
AS [h]
JOIN [HotelsRooms]
AS [hr]
ON [hr].[HotelId] = [h].[Id]
JOIN [Rooms]
AS [r]
ON [r].[Id] = [hr].[RoomId]
JOIN [Bookings]
AS [b]
ON [b].[HotelId] = [h].[Id]
JOIN [Tourists]
AS [to]
ON [to].[Id] = [b].[TouristId]
WHERE (RIGHT([to].[Name], 2) <> 'EZ')
	  AND
	  [h].[Id] IN (
					SELECT [b].[HotelId]
					  FROM [Tourists] AS [to]
				      JOIN [Bookings] AS [b]
  					    ON [to].[Id] = [b].[TouristId]
					  JOIN [Rooms] AS [r]
					    ON [r].[Id] = [b].[RoomId]
					 WHERE (RIGHT([to].[Name], 2) <> 'EZ')
				  GROUP BY [b].[HotelId]
					)
	  AND
	  [r].[Id] IN (
					SELECT [b].[RoomId]
					  FROM [Tourists] AS [to]
					  JOIN [Bookings] AS [b]
  					    ON [to].[Id] = [b].[TouristId]
					 WHERE (RIGHT([to].[Name], 2) <> 'EZ')
				  GROUP BY [b].[RoomId]
					)
	  

--GROUP BY [h].[Name]
ORDER BY [r].[Price] DESC


SELECT * FROM [Hotels]

SELECT * FROM [Destinations]

SELECT * FROM [Bookings]

SELECT * FROM [Tourists] AS [to] WHERE (RIGHT([to].[Name], 2) <> 'EZ')



-- Problem 10
-- TO DO
  SELECT [h].[Name] AS [HotelName],
         DATEDIFF(day, [b].[ArrivalDate], [b].DepartureDate) * (
														  	   SELECT [ro].[Price] 
														  	   FROM [Rooms]
														  	   AS [ro]
														  	   WHERE [ro].[Id] = [b].[Id]
														  	   ) 
	  AS [NightsCount]
	FROM [Hotels]
	  AS [h]
	JOIN [HotelsRooms]
	  AS [hr]
	  ON [hr].[HotelId] = [h].[Id]
	JOIN [Rooms]
	  AS [r]
	  ON [r].[Id] = [hr].[RoomId]
    JOIN [Bookings]
	  AS [b]
	  ON [h].[Id] = [b].[HotelId]
GROUP BY [h].[Name]

SELECT DATEDIFF(day, [b].[ArrivalDate], [b].DepartureDate) * (
														  	   SELECT [ro].[Price] 
														  	   FROM [Rooms]
														  	   AS [ro]
															   JOIN [Bookings]
															   AS [bo]
															   ON [ro].Id = [bo].[RoomId]
														  	   WHERE [bo].[RoomId] = [ro].[Id]
														  	 )
FROM [Bookings]
AS [b]


-- Problem 11
GO

CREATE OR ALTER FUNCTION udf_RoomsWithTourists(@name VARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @count INT = ( SELECT SUM([b].AdultsCount + [b].ChildrenCount)
						   FROM [Tourists]
						   AS [t]
						   LEFT JOIN [Bookings]
						   AS [b]
						   ON [t].[Id] = [b].[TouristId]
						   LEFT JOIN [Rooms]
						   AS [r]
						   ON [r].[Id] = [b].[RoomId]
						   WHERE [r].[Type] = @name					   
						 )
	RETURN @count
END

GO

SELECT dbo.udf_RoomsWithTourists('Double Room')
SELECT dbo.udf_RoomsWithTourists('VIP')

-- Problem 12
GO
CREATE OR ALTER PROC usp_SearchByCountry @country NVARCHAR(50)
AS
BEGIN
	SELECT [t].[Name],
			[t].[PhoneNumber],
			[t].[Email],
			COUNT([b].[Id]) AS [CountofBookings]
	FROM [Tourists]
	AS [t]
	JOIN [Countries]
	AS [c]
	ON [t].[CountryId] = [c].[Id]
	INNER JOIN [Bookings]
	AS [b]
	ON [b].[TouristId] = [t].[Id]
	WHERE [c].[Name] = @country
	GROUP BY [t].[Name], [t].[PhoneNumber], [t].[Email]
	ORDER BY [t].[Name], [CountofBookings] DESC
END

EXEC usp_SearchByCountry 'Greece'

GO