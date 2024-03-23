USE Geography

-- 22. All mountain peaks
SELECT PeakName FROM Peaks ORDER BY PeakName

-- 23. biggest countries by population
SELECT * FROM Countries

SELECT TOP (30)
CountryName
, [Population]
FROM Countries
WHERE ContinentCode IN (
	SELECT ContinentCode 
	FROM Continents
	WHERE ContinentName = 'Europe')
ORDER BY [Population] DESC


-- 24. Countries and currency (euro/not euro)
SELECT CountryName
, CountryCode
, Currency = CASE CurrencyCode
WHEN 'EUR' THEN 'Euro'
ELSE 'Not Euro'
END
FROM Countries
ORDER BY CountryName


-- 25. All Diablo Characters
USE Diablo
SELECT [Name] FROM Characters ORDER BY [Name]