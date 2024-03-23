CREATE TABLE Manufacturers (
    ManufacturerID INT PRIMARY KEY,
    [Name] NVARCHAR(80) NOT NULL,
    EstablishedOn DATETIME2
)

CREATE TABLE Models (
    ModelID INT PRIMARY KEY IDENTITY (101, 1),
    [Name] NVARCHAR(50) NOT NULL,
    ManufacturerID INT FOREIGN KEY  REFERENCES Manufacturers (ManufacturerID)
)

INSERT INTO Manufacturers (ManufacturerID, Name, EstablishedOn)
    VALUES 
        (1, 'BMW', '07/03/1916'),
        (2, 'Tesla', '01/01/2003'),
        (3, 'Lada', '01/05/1966')

INSERT INTO Models (Name, ManufacturerID)
    VALUES
        ('X1', 1),
        ('i6', 1),
        ('Model S', 2),
        ('Model X', 2),
        ('Model 3', 2),
        ('Nova', 3)