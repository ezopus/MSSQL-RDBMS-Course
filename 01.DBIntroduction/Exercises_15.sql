--task #15
CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees (
	Id INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50),
	Notes VARCHAR(2000),
	)
CREATE TABLE Customers (
	AccountNumber INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	PhoneNumber INT NOT NULL,
	EmergencyName VARCHAR(80) NOT NULL,
	EmergencyNumber INT NOT NULL,
	Notes VARCHAR(2000),
	)
CREATE TABLE RoomStatus (
	RoomStatus VARCHAR(50) PRIMARY KEY NOT NULL,
	Notes VARCHAR(500),
	)
CREATE TABLE RoomTypes (
	RoomType VARCHAR(50) PRIMARY KEY,
	Notes VARCHAR(500),
	)
CREATE TABLE BedTypes (
	BedType VARCHAR(50) PRIMARY KEY,
	Notes VARCHAR(500),
	)
CREATE TABLE Rooms (
	RoomNumber INT PRIMARY KEY,
	RoomType VARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType) NOT NULL, 
	BedType VARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType) NOT NULL,
	Rate DECIMAL NOT NULL,
	RoomStatus VARCHAR(50) FOREIGN KEY REFERENCES RoomStatus(RoomStatus),
	Notes VARCHAR(500)
	)
CREATE TABLE Payments (
		Id INT NOT NULL,
		EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
		PaymentDate DATE NOT NULL,
		AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
		FirstDateOccupied DATE NOT NULL,
		LastDateOccupied DATE NOT NULL,
		TotalDays SMALLINT NOT NULL,
		AmountCharged DECIMAL NOT NULL,
		TaxRate DECIMAL NOT NULL,
		PaymentTotal DECIMAL NOT NULL,
		Notes VARCHAR(2500)
		PRIMARY KEY (Id, AccountNumber)
	)
CREATE TABLE Occupancies (
	Id INT NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	DateOccupied DATETIME2 NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL,
	RateApplied DECIMAL NOT NULL,
	PhoneCharge DECIMAL NOT NULL,
	Notes VARCHAR(1200)
	)

INSERT INTO Employees ([Id], [FirstName], [LastName], [Title])
	VALUES
	(1, 'Georgi', 'Ivanov', 'Driver'),
	(2, 'Ivan', 'Georgiev', 'Reception'),
	(3, 'Elena', 'Elenova', 'Manager')
INSERT INTO	Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber)
	VALUES
	(1, 'Elena', 'Rogleva', 0888123456, 'Georgi Kovachev', 0999123456),
	(2, 'Georgi', 'Kovachev', 0877332211, 'Elena Rogleva', 0233452344),
	(3, 'Ivan', 'Angelov', 0879373737, 'Pesho Ivanov', 0878787878)
INSERT INTO RoomStatus (RoomStatus)
	VALUES
	('Free'),
	('Occupied'),
	('Maintenance')
INSERT INTO RoomTypes (RoomType)
	VALUES
	('Standard Double Room'),
	('Deluxe Double Room'),
	('Suite')
INSERT INTO BedTypes (BedType)
	VALUES
	('Single bed'),
	('Queen size'),
	('King size')
INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus)
	VALUES
	(101, 'Standard Double Room', 'Single bed', 80.50, 'Free'),
	(201, 'Deluxe Double Room', 'Queen size', 112.20, 'Occupied'),
	(301, 'Suite', 'King size', 180.80, 'Maintenance')
INSERT INTO Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, PaymentTotal)
	VALUES
	(1, 1, '2023-12-23', 1, '2023-12-27', '2024-01-01', 5, 100, 0.2, 500),
	(2, 2, '2024-01-02', 2, '2024-01-10', '2024-01-17', 7, 80, 0.2, 560),
	(3, 3, '2023-10-10', 3, '2024-02-01', '2024-02-10', 9, 150, 0.2, 1350)
INSERT INTO Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge)
	VALUES
	(1, 2, '2023-12-27', 1, 101, 80.5, 0),
	(2, 3, '2024-01-10', 2, 201, 112.2, 0),
	(3, 3, '2024-02-01', 3, 301, 180.8, 0)