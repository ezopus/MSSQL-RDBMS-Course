--task #14
CREATE DATABASE CarRental
GO
USE CarRental


CREATE TABLE Categories (
	Id INT PRIMARY KEY,
	CategoryName VARCHAR(50) NOT NULL,
	DailyRate DECIMAL NOT NULL,
	WeeklyRate DECIMAL NOT NULL,
	MonthlyRate DECIMAL NOT NULL,
	WeekendRate DECIMAL,
)
GO
CREATE TABLE Cars (
	Id INT PRIMARY KEY,
	PlateNumber NVARCHAR(12) NOT NULL,
	Manufacturer VARCHAR(50) NOT NULL,
	Model VARCHAR(80) NOT NULL,
	CarYear SMALLINT NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Doors TINYINT NOT NULL,
	Picture VARBINARY,
	CHECK (DATALENGTH(Picture) < 2000),
	Condition VARCHAR(100),
	Available BIT NOT NULL
)

CREATE TABLE Employees (
	Id INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(50),
	Notes VARCHAR(2000),
)

CREATE TABLE Customers (
	Id INT PRIMARY KEY,
	DriverLicenceNumber INT NOT NULL,
	FullName VARCHAR(100) NOT NULL,
	[Address] VARCHAR(200) NOT NULL,
	City VARCHAR(50) NOT NULL,
	ZIPCode VARCHAR(50) NOT NULL,
	Notes VARCHAR(2000),
)
GO
CREATE TABLE RentalOrders (
	Id INT PRIMARY KEY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
	TankLevel DECIMAL(6,2) NOT NULL,
	KilometrageStart FLOAT NOT NULL,
	KilometrageEnd FLOAT NOT NULL,
	TotalKilometrage FLOAT NOT NULL,
	StartDate DATETIME2 NOT NULL,
	EndDate DATETIME2 NOT NULL,
	TotalDays SMALLINT NOT NULL,
	RateApplied DECIMAL NOT NULL,
	TaxRate DECIMAL NOT NULL,
	OrderStatus VARCHAR(50) NOT NULL,
	Notes VARCHAR(2000),
)
GO

INSERT INTO Categories ([Id], [CategoryName], [DailyRate], [WeeklyRate], [MonthlyRate])
	VALUES
	(1, 'Leisure', 45.50, 190, 732.50),
	(2, 'Sport', 92.20, 430.40, 1555),
	(3, 'Van', 62.10, 299.90, 1111.11)

INSERT INTO Cars ([Id], [PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Doors], [Condition], [Available])
	VALUES
	(1, 'PB6969BP', 'Toyota', 'Corolla GR Sport', 2024, 1, 5, 'New', 1),
	(2, 'CB7722HX', 'Volkswagen', 'Sharan', 2016, 3, 5, 'Used', 1),
	(3, 'A0007K', 'Ferrari', 'Enzo', 2008, 2, 2, 'New', 0)

INSERT INTO Employees ([Id], [FirstName], [LastName], [Title])
	VALUES
	(1, 'Georgi', 'Ivanov', 'Driver'),
	(2, 'Ivan', 'Georgiev', 'Reception'),
	(3, 'Elena', 'Elenova', 'Manager')

INSERT INTO	Customers (Id, DriverLicenceNumber, FullName, [Address], City, ZIPCode)
	VALUES
	(1, 288313943, 'Elena Rogleva', 'Makgahan 9', 'Plovdiv', 4004),
	(2, 100294631, 'Georgi Kovachev', 'Tzar Osvoboditel 43', 'Asenovgrad', 4230),
	(3, 322109312, 'Ivan Angelov', 'Dondukov 32', 'Sofia', 1004)

INSERT INTO RentalOrders (Id, EmployeeId, CustomerId, TankLevel, KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus)
	VALUES
	(1, 2, 3, 33.5, 15020, 15900, 880, '2024-01-05', '2024-01-10', 5, 150.50, 0.20, 'Fulfilled'),
	(2, 1, 2, 15.2, 42001, 43300, 1300, '2023-11-10', '2023-12-01', 21, 85.40, 0.11, 'Fulfilled' ),
	(3, 3, 1, 48.9, 5200, 5700, 500, '2024-02-01', '2024-02-10', 9, 220.20, 0.20, 'In progress')
