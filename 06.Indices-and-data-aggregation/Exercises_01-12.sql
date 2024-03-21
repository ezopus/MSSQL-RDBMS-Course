USE [Gringotts]

-- Exercise 01
SELECT COUNT(Id) AS [Count]
FROM [WizzardDeposits]


-- Exercise 02
SELECT TOP (1) [MagicWandSize] AS [LongestMagicWand]
FROM [WizzardDeposits] 
ORDER BY [MagicWandSize] DESC


-- Exercise 03

--SELECT [query].[DepositGroup]
--	 , [query].[LongestMagicWand]
--FROM (
--		SELECT *
--				,DENSE_RANK() OVER (PARTITION BY [DepositGroup] ORDER BY [LongestMagicWand] DESC) AS [SizeRank]
--		FROM (
--				  SELECT [w].[DepositGroup] AS [DepositGroup]
--						,[MagicWandSize] AS [LongestMagicWand]
--					FROM [WizzardDeposits] AS [w]
--				GROUP BY [w].[DepositGroup], [w].[MagicWandSize]
--			) AS [ranked]
		
--	) AS [query]
--WHERE [query].[SizeRank] = 1
--ORDER BY [query].DepositGroup

  SELECT [DepositGroup]
		, MAX([MagicWandSize]) AS [LongestMagicWand]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]


-- Exercise 04
SELECT TOP (2) [DepositGroup]
          FROM [WizzardDeposits]
      GROUP BY [DepositGroup]
      ORDER BY AVG([MagicWandSize])


-- Exercise 05
  SELECT [DepositGroup]
	     ,SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]


-- Exercise 06
SELECT [DepositGroup]
	     ,SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]


-- Exercise 07
SELECT [DepositGroup]
	     ,SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]
  HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC


-- Exercise 08
SELECT [DepositGroup]
,[MagicWandCreator]
,[DepositCharge]
FROM [WizzardDeposits]
GROUP BY [MagicWandCreator], [DepositGroup], [DepositCharge]
ORDER BY [MagicWandCreator], [DepositGroup]


-- Exercise 09
  SELECT [AgeGroup]
	     ,COUNT(*)
	FROM (
			SELECT [Age]
				   ,CASE
						WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
						WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
						WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
						WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
						WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
						WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
						WHEN [Age] > 60 THEN '[61+]'
					END AS [AgeGroup]
			FROM [WizzardDeposits] AS [AgeGroups]
	     )
	  AS [Ages]
GROUP BY [AgeGroup]


-- Exercise 10
SELECT *
FROM (
		SELECT LEFT([FirstName], 1) AS FirstLetter
		  FROM [WizzardDeposits]
		 WHERE [DepositGroup] = 'Troll Chest'
	 ) AS FirstLetters
GROUP BY FirstLetter
ORDER BY FirstLetter


-- Exercise 11
  SELECT [DepositGroup]
         ,[IsDepositExpired]
         ,AVG([DepositInterest]) AS [AverageInterest]
    FROM [WizzardDeposits]
   WHERE [DepositStartDate] > '1985-01-01'
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] DESC, [IsDepositExpired]


-- Exercise 12

--LEAD SOLUTION
SELECT SUM([Host Wizard Deposit] - [Guest Wizard Deposit])
	AS [SumDifference]
  FROM (
		SELECT [FirstName] 
			AS [Host Wizard]
			  ,[DepositAmount] 
			AS [Host Wizard Deposit]
			  ,LEAD([FirstName]) OVER (ORDER BY [Id]) 
			AS [Guest Wizard]
			  ,LEAD([DepositAmount]) OVER (ORDER BY [Id]) 
			AS [Guest Wizard Deposit]
		FROM [WizzardDeposits] AS [wd]
		) AS [HostGuestQuery]
 WHERE [HostGuestQuery].[Guest Wizard] IS NOT NULL

--JOIN SOLUTION
SELECT SUM([Difference]) AS [SumDifference]
FROM (
		SELECT [wd1].FirstName AS [Host Wizard]
			  ,[wd1].DepositAmount AS [Host Wizard Deposit]
			  ,[wd2].FirstName AS [Guest Wizard]
			  ,[wd2].DepositAmount AS [Guest Wizard Deposit]
			  ,([wd1].DepositAmount - [wd2].DepositAmount) AS [Difference]
		  FROM [WizzardDeposits] AS [wd1]
	INNER JOIN [WizzardDeposits] AS [wd2] ON [wd1].Id + 1 = [wd2].Id
     ) AS [dt]

