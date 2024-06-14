-- Problem 05
SELECT FORMAT([ArrivalDate], 'yyyy-MM-dd') AS [ArrivalDate],
       [AdultsCount],
	   [ChildrenCount]
FROM [Bookings] AS [b]
JOIN [Rooms] AS [r]
ON [b].[RoomId] = [r].Id
ORDER BY [r].Price DESC, [b].[ArrivalDate]

-- Problem 06
SELECT [h].[Id],
		[h].[Name]
FROM [Hotels] AS [h]
JOIN [HotelsRooms] AS [hr]
ON [h].[Id] = [hr].[HotelId]
JOIN [Rooms] AS [r]
ON [hr].RoomId = [r].[Id]
JOIN [Bookings] AS [b]
ON [b].HotelId = [h].Id
WHERE [r].[Type] = 'VIP Apartment'
GROUP BY [h].[Id], [h].[Name]
ORDER BY COUNT([h].[Id]) DESC

-- Problem 07
SELECT [t].[Id],
		[t].[Name],
		[t].[PhoneNumber]
FROM [Tourists] AS [t]
LEFT JOIN [Bookings] AS [b]
ON [t].Id = [b].[TouristId]
WHERE [b].ArrivalDate IS NULL
ORDER BY [t].[Name]


-- Problem 08
SELECT TOP (10) 
		[h].[Name] AS [HotelName],
		[d].[Name] AS [DestinationName],
		[co].[Name] AS [CountryName]
FROM [Bookings] AS [b]
JOIN [Hotels] AS [h]
ON [b].[HotelId] = [h].[Id]
JOIN [Destinations] AS [d]
ON [h].[DestinationId] = [d].[Id]
JOIN [Countries] AS [co]
ON [co].Id = [d].[CountryId]
WHERE [b].[ArrivalDate] < '2023-12-31' AND [h].[Id] % 2 <> 0
ORDER BY [co].[Name], [b].[ArrivalDate]


-- Problem 09
SELECT [h].[Name] AS [HotelName],
	[r].[Price] AS [RoomPrice]
FROM [Tourists] AS [t]
JOIN [Bookings] AS [b]
ON [t].[Id] = [b].[TouristId]
JOIN [Hotels] AS [h]
ON [b].[HotelId] = [h].[Id]
JOIN [Rooms] AS [r]
ON [b].[RoomId] = [r].[Id]
WHERE [t].[Name] NOT LIKE '%EZ'
ORDER BY [r].Price DESC


-- Problem 10
SELECT [dt].[HotelName],
		SUM([dt].[Revenue]) AS [HotelRevenue]
FROM (
	SELECT [h].[Name] AS [HotelName],
		[r].[Price] * (DATEDIFF(day, [b].[ArrivalDate], [b].[DepartureDate])) AS [Revenue]
	FROM [Bookings] AS [b]
	JOIN [Hotels] AS [h]
	ON [b].[HotelId] = [h].[Id]
	JOIN [Rooms] AS [r]
	ON [b].[RoomId] = [r].[Id]
	) AS [dt]
GROUP BY [dt].[HotelName]
ORDER BY [HotelRevenue] DESC

GO

-- Problem 11
CREATE FUNCTION udf_RoomsWithTourists(@name VARCHAR(40))
RETURNS INT
AS
BEGIN
	DECLARE @count INT = (
							SELECT SUM([b].[AdultsCount]) + SUM([b].[ChildrenCount])
							FROM [Bookings] AS [b]
							JOIN [Rooms] AS [r]
							ON [b].RoomId = [r].[Id]
							WHERE [r].[Type] = @name
						  )
	RETURN @count
END

GO

SELECT dbo.udf_RoomsWithTourists('Double Room')

GO


-- Problem 12
CREATE OR ALTER PROC usp_SearchByCountry(@country VARCHAR(80)) 
AS
BEGIN
	SELECT [t].[Name],
			[t].[PhoneNumber],
			[t].[Email],
			COUNT([b].[TouristId]) AS [CountOfBookings]
	FROM [Tourists] AS [t]
	LEFT JOIN [Bookings] AS [b]
	ON [t].[Id] = [b].[TouristId]
	JOIN [Countries] AS [co]
	ON [t].[CountryId] = [co].[Id]
	WHERE [b].[ArrivalDate] IS NOT NULL AND [co].[Name] = @country
	GROUP BY [t].[Name], [t].[PhoneNumber], [t].[Email]
	ORDER BY [t].[Name], [CountOfBookings] DESC
END

GO

EXEC dbo.usp_SearchByCountry 'Greece'