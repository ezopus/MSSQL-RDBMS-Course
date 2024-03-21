USE [SoftUni]

GO

-- Exercise 01
CREATE OR ALTER PROC [usp_GetEmployeesSalaryAbove35000]
AS
BEGIN
	SELECT [FirstName]
		   , [LastName]
	  FROM [Employees]
	 WHERE [Salary] > 35000
END

EXEC [dbo].[usp_GetEmployeesSalaryAbove35000]

GO

-- Exercise 02
CREATE OR ALTER PROC [usp_GetEmployeesSalaryAboveNumber] (@Limit DECIMAL(18,4))
AS
BEGIN
	SELECT [FirstName]
		   , [LastName]
	  FROM [Employees]
	 WHERE [Salary] >= @Limit
END

EXEC [dbo].[usp_GetEmployeesSalaryAboveNumber] 48100

GO


-- Exercise 03
CREATE OR ALTER PROC [usp_GetTownsStartingWith] (@Filter VARCHAR(MAX))
AS
BEGIN
	SELECT [Name] AS [Town]
	FROM [Towns]
	WHERE LOWER(LEFT([Name], LEN(@Filter))) = LOWER(@Filter)
END

EXEC [dbo].[usp_GetTownsStartingWith] 'b'

GO


-- Exercise 04
CREATE OR ALTER PROC [usp_GetEmployeesFromTown] (@TownName VARCHAR(MAX))
AS
BEGIN
	SELECT [FirstName]
			, [LastName]
	  FROM [Employees] AS [e]
	  JOIN [Addresses] AS [a] ON [a].[AddressID] = [e].[AddressID]
	  JOIN [Towns] AS [t] ON [t].[TownID] = [a].[TownID]
	 WHERE [t].[Name] = @TownName
END

EXEC [dbo].[usp_GetEmployeesFromTown] 'Sofia'

GO


-- Exercise 05
CREATE FUNCTION [ufn_GetSalaryLevel](@salary DECIMAL(18,4))
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @Result NVARCHAR(10)
	SET @Result = 'High'

	IF (@Salary < 30000)
	BEGIN
		SET @Result = 'Low'
	END
	ELSE IF @Salary <= 50000
	BEGIN
		SET @Result = 'Average'
	END

	RETURN @Result
END

SELECT [Salary]
	   , [dbo].[ufn_GetSalaryLevel]([Salary]) AS [Salary Level]
FROM [Employees]

GO


-- Exercise 06
CREATE OR ALTER PROC usp_EmployeesBySalaryLevel (@SalaryLevel VARCHAR(10))
AS
BEGIN
	SELECT [FirstName]
		   , [LastName]
	FROM [Employees]
	WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @SalaryLevel
END

EXEC [dbo].[usp_EmployeesBySalaryLevel] 'High'

GO


-- Exercise 07
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
AS
BEGIN
	DECLARE @index INT = 1
	DECLARE @char VARCHAR(1)
	SET @index = 1
	WHILE (@index <= LEN(@word))
		BEGIN
			SET @char = SUBSTRING(@word, @index, 1)
			IF (CHARINDEX(@char, @setOfLetters) > 0)
			BEGIN
				SET @index = @index + 1
			END
			ELSE
			BEGIN
				RETURN 0
			END
		END	
	RETURN 1
END

SELECT [dbo].ufn_IsWordComprised ('oistmiahf', 'Sofia') AS [Result]

SELECT FirstName
	  , [dbo].ufn_IsWordComprised ('oistmiahf', FirstName) AS [Result]
  FROM Employees
 WHERE dbo.ufn_IsWordComprised('oistmiahf', FirstName) = 1

GO


-- Exercise 08
CREATE OR ALTER PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
	--First delete all project records for employees from given department
	DELETE FROM [EmployeesProjects]
	WHERE [EmployeeID] IN (
						   SELECT [EmployeeID]
							 FROM [Employees]
							WHERE [DepartmentID] = @departmentId
						   )

	--Set Manager to be null for those whose manager will be deleted
	  UPDATE [Employees]
	     SET [ManagerID] = NULL
	   WHERE [ManagerID] IN (
						   SELECT [EmployeeID]
							 FROM [Employees]
							WHERE [DepartmentID] = @departmentId
						   )

	-- Alter Departments to permit manager to be null
	ALTER TABLE [Departments]
	ALTER COLUMN [ManagerID] INT

	-- Set Manager to be NULL in Departments table
   UPDATE [Departments]
	  SET [ManagerID] = NULL
	WHERE [ManagerID] IN (
						   SELECT [EmployeeID]
							 FROM [Employees]
							WHERE [DepartmentID] = @departmentId
						   )

	-- Now we can delete employees themselves
	DELETE FROM [Employees]
	WHERE [EmployeeID] IN (
						   SELECT [EmployeeID]
							 FROM [Employees]
							WHERE [DepartmentID] = @departmentId
						   )

	SELECT COUNT(*)
	  FROM [Employees]
	 WHERE [DepartmentID] = @departmentId
END


SELECT * FROM [EmployeesProjects]

GO