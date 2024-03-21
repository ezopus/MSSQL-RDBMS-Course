--task #7

CREATE TABLE [People] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH([Picture]) <= 2000000),
	[Height] DECIMAL(3,2),
	[Weight] DECIMAL(5,2),
	[Gender] CHAR(1) NOT NULL,
	CHECK (Gender = 'm' OR Gender = 'f'),
	[Birthdate] DATE NOT NULL,
	[Biography] VARCHAR(MAX)
)

--! DROP TABLE People


INSERT INTO People ([Name], [Height], [Weight], [Gender], [Birthdate])
	VALUES
	('Gosho', 1.70, 79, 'm', '1990-03-04'),
	('Elena', 1.60, 49, 'f', '1994-09-29'),
	('Elena', 1.60, 49, 'f', '1994-09-29'),
	('Elena', 1.60, 49, 'f', '1994-09-29'),
	('Elena', 1.60, 49, 'f', '1994-09-29')

--SELECT * FROM People


--task #8
CREATE TABLE Users (
	[Id] INT PRIMARY KEY IDENTITY,
	[Username] VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY,
	CHECK (DATALENGTH(ProfilePicture) <= 900),
	[LastLoginTime] TIME,
	[IsDeleted] BIT,
)

--TRUNCATE TABLE Users

INSERT INTO Users ([Username], [Password], [LastLoginTime], [IsDeleted])
	VALUES
	('ezo', 'parola', DEFAULT, 0),
	('slon', 'slon4', '12:00:00', 1),
	('Pesho', 'Gosho', '23:12', 0),
	('slon', 'slon4', '12:00:00', 1),
	('Pesho', 'Gosho', '11:6', 0)

SELECT * FROM Users

--task #9
ALTER TABLE Users
	DROP CONSTRAINT PK__Users__3214EC0776A788AE;

ALTER TABLE Users
	ADD CONSTRAINT PK_Primary PRIMARY KEY (Id, Username)


--task #10
--to successfully add the check make sure no previous records have a password length of less than 5 symbols
ALTER TABLE Users
	ADD CONSTRAINT CK_CheckPasswordIsAtLeast5Symbols CHECK (LEN(Password) > 4)

--task #11
ALTER TABLE Users
ADD CONSTRAINT DF_LoginTime
DEFAULT CURRENT_TIMESTAMP FOR LastLoginTime

--task #12
ALTER TABLE Users
	DROP CONSTRAINT PK_Primary;
ALTER TABLE Users
	ADD CONSTRAINT PK_Primary PRIMARY KEY (Id);
ALTER TABLE Users
	ADD CONSTRAINT CK_UsernameMustBe4SymbolsOrMore CHECK (LEN(Username) > 3)
