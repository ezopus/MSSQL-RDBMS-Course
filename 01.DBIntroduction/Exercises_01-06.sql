--task #1
CREATE DATABASE [Minions]

USE Minions

--task #2

CREATE TABLE [Minions] (
	[Id] INT PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	[Age] INT
)

--task #3

CREATE TABLE [Towns] (
	[Id] INT PRIMARY KEY,
	[Name] VARCHAR(80) NOT NULL
)


ALTER TABLE [Minions]
	ADD [TownId] INT FOREIGN KEY REFERENCES Towns(Id)
	
GO
--task #4
INSERT INTO [Towns]([Id], [Name])
	VALUES
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')
	
--SELECT * FROM Towns

--ALTER TABLE [Minions]
--	ADD CONSTRAINT FK_MinionsTownId_TownId FOREIGN KEY (TownId)
--	REFERENCES Towns (Id)

INSERT INTO Minions([Id], [Name], [Age], [TownId]) VALUES (1, 'Kevin', 22, 1),	(2, 'Bob', 15, 3),	(3, 'Steward', NULL, 2)

--SELECT * FROM Minions

GO

--task #5

TRUNCATE TABLE Minions
SELECT * FROM Minions


--task #6

DROP TABLE Minions, Towns


