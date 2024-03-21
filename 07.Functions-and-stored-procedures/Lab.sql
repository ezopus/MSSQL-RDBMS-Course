USE SoftUni

GO

CREATE FUNCTION udf_GetSalaryLevel(@Salary MONEY)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @Result NVARCHAR(10)
	SET @Result = 'High'

	IF (@Salary < 30000)
	BEGIN
		SET @Result = 'Low'
	END
	ELSE IF @Salary < 50000
	BEGIN
		SET @Result = 'Average'
	END

	RETURN @Result
END

SELECT [FirstName]
	  ,[LastName]
	  ,[Salary]
	  ,dbo.udf_GetSalaryLevel([Salary]) AS [SalaryLevel]
FROM [Employees]

