USE [Bank]

GO

-- Exercise 01

--DROP TABLE [Logs]
CREATE TABLE [Logs] (
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT NOT NULL,
	OldSum DECIMAL(18,2),
	NewSum DECIMAL(18,2)
	)

GO

CREATE OR ALTER TRIGGER tr_AddToLogWhenAccountBalanceChanges
ON [Accounts] FOR UPDATE
AS
	INSERT INTO [Logs] ([AccountId], [OldSum], [NewSum])
		 SELECT [i].[AccountHolderId]
				 , [d].[Balance]
				 , [i].[Balance]
		   FROM [inserted] AS [i]
           JOIN [deleted] AS [d] ON [i].[Id] = [d].[Id]
		  WHERE [i].[Balance] <> [d].[Balance]
GO

SELECT * FROM [Accounts]

UPDATE [Accounts]
   SET [Balance] = 123.12
 WHERE [Id] = 1

 SELECT * FROM [Logs]

 GO


 -- Exercise 02
CREATE TABLE [NotificationEmails] 
	(
		[Id] INT PRIMARY KEY IDENTITY,
		[Recipient] INT NOT NULL,
		[Subject] NVARCHAR(200),
		[Body] NVARCHAR(MAX)
	)
GO

CREATE OR ALTER TRIGGER tr_CreateNewEmail
ON [Logs] FOR INSERT
AS
	INSERT INTO [NotificationEmails] ([Recipient], [Subject], [Body])
		 SELECT [i].[AccountId]
				, CONCAT('Balance change for account: ', [i].[AccountId])
				, CONCAT('On ', GETDATE(), ' your balance was changed from ', [i].OldSum, ' to ', [i].[NewSum], '.')
		   FROM [inserted] AS [i]
GO
		   
SELECT * FROM [NotificationEmails]

GO


-- Exercise 03
CREATE OR ALTER PROC usp_DepositMoney(@AccountId INT, @MoneyAmount MONEY)
AS
BEGIN
	IF @MoneyAmount > 0.0000
	BEGIN
		UPDATE [Accounts]
		   SET [Balance] += @MoneyAmount
		 WHERE [Id] = @AccountId
	END
END

EXEC usp_DepositMoney 1, 10

SELECT *
  FROM [Accounts]
 WHERE [Id] = 1

GO


-- Exercise 04
CREATE OR ALTER PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount MONEY)
AS
BEGIN
	IF @MoneyAmount > 0.0000
	BEGIN
		UPDATE [Accounts]
		   SET [Balance] -= @MoneyAmount
		 WHERE [Id] = @AccountId
	END
END

EXEC usp_WithdrawMoney 5, 25

SELECT *
  FROM [Accounts]
 WHERE [Id] = 5

 GO


 -- Exercise 05
 CREATE OR ALTER PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount MONEY)
 AS
 BEGIN
	IF @Amount > 0.0000
	BEGIN
		EXEC usp_WithdrawMoney @SenderId, @Amount
		EXEC usp_DepositMoney @ReceiverId, @Amount
	END
 END

 EXEC usp_TransferMoney 5, 1, 5000

 SELECT *
   FROM [Accounts]
 WHERE [Id] IN (1, 5)