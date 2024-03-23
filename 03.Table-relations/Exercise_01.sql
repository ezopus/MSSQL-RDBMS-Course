CREATE DATABASE TableRelations

USE TableRelations



CREATE TABLE Persons (
    [PersonID] INT NOT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [Salary] DECIMAL(8,2),
    [PassportID] INT
)

ALTER TABLE Persons
    ADD CONSTRAINT PK_Primary PRIMARY KEY (PersonID)

INSERT INTO [Persons] (PersonID, FirstName, Salary, PassportID)
    VALUES
        (1, 'Roberto', 43300.00, 102),
        (2, 'Tom', 56100.00, 103),
        (3, 'Yana', 60200.00, 101)

CREATE TABLE Passports (
    [PassportID] INT PRIMARY KEY IDENTITY (101, 1),
    [PassportNumber] NVARCHAR(20)
)
     
INSERT INTO Passports (PassportNumber)
    VALUES
        ('N34FG21B'),
        ('K65LO4R7'),
        ('ZE657QP2')

ALTER TABLE [Persons]
    ADD CONSTRAINT FK_PassportID FOREIGN KEY (PassportID) REFERENCES Passports (PassportID)

ALTER TABLE [Persons]
    ADD UNIQUE(PassportID)


--CREATE DATABASE MyDB

--ALTER DATABASE Documents SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
 
--DROP DATABASE Documents