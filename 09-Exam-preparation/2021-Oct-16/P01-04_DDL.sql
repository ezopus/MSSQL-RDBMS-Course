CREATE DATABASE [CigarShop]

GO


USE [CigarShop]

GO

-- Problem 01
CREATE TABLE [Sizes]
	(
		[Id] INT PRIMARY KEY IDENTITY,
		[Length] INT NOT NULL,
		CHECK ([Length] >= 10 AND [Length] <= 25),
		[RingRange] DECIMAL (15,2) NOT NULL,
		CHECK([RingRange] >= 1.5 AND [RingRange] <= 7.5)
	)

CREATE TABLE [Tastes]
	(
		[Id] INT PRIMARY KEY IDENTITY,
		[TasteType] VARCHAR(20) NOT NULL,
		[TasteStrength] VARCHAR(15) NOT NULL,
		[ImageURL] NVARCHAR(100) NOT NULL
	)

CREATE TABLE [Brands]
	(
		[Id] INT PRIMARY KEY IDENTITY,
		[BrandName] VARCHAR(30) UNIQUE NOT NULL,
		[BrandDescription] VARCHAR(MAX)
	)

CREATE TABLE [Cigars]
	(
		[Id] INT PRIMARY KEY IDENTITY,
		[CigarName] VARCHAR(80) NOT NULL,
		[BrandId] INT FOREIGN KEY REFERENCES [Brands]([Id]) NOT NULL,
		[TastId] INT FOREIGN KEY REFERENCES [Tastes]([Id]) NOT NULL,
		[SizeId] INT FOREIGN KEY REFERENCES [Sizes]([Id]) NOT NULL,
		[PriceForSingleCigar] MONEY NOT NULL,
		[ImageURL] NVARCHAR(100) NOT NULL,
	)

	

CREATE TABLE [Addresses]
	(
		[Id] INT PRIMARY KEY IDENTITY,
		[Town] VARCHAR(30) NOT NULL,
		[Country] NVARCHAR(30) NOT NULL,
		[Streat] NVARCHAR(100) NOT NULL,
		[ZIP] VARCHAR(20) NOT NULL
	)

CREATE TABLE [Clients]
	(
		[Id] INT PRIMARY KEY IDENTITY,
		[FirstName] NVARCHAR(30) NOT NULL,
		[LastName] NVARCHAR(30) NOT NULL,
		[Email] NVARCHAR(50) NOT NULL,
		[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
	)

CREATE TABLE [ClientsCigars]
	(
		[ClientId] INT FOREIGN KEY REFERENCES [Clients]([Id]) NOT NULL,
		[CigarId] INT FOREIGN KEY REFERENCES [Cigars]([Id]) NOT NULL,
		PRIMARY KEY ([ClientId], [CigarId])
	)

GO


-- Problem 02
INSERT INTO [Cigars] (CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
	 VALUES 
('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO [Addresses] (Town, Country, Streat, ZIP)
	 VALUES
('Sofia','Bulgaria', '18 Bul. Vasil levski', 1000),
('Athens', 'Greece', '4342 McDonald Avenue', 10435),
('Zagreb', 'Croatia', '4333 Lauren Drive', 10000)



-- Problem 03

--update cigar price where taste = 'spicy'
UPDATE [Cigars]
SET [PriceForSingleCigar] *= 1.2
WHERE [TastId] = (
					SELECT [Id]
					FROM [Tastes]
					WHERE [TasteType] = 'Spicy'
				 )

-- update empty brand description
UPDATE [Brands]
SET [BrandDescription] = 'New description'
WHERE [BrandDescription] IS NULL


-- Problem 04

ALTER TABLE [Clients]
ALTER COLUMN [AddressId] INT 

UPDATE [Clients]
SET [AddressId] = NULL
WHERE [AddressId] IN (
						SELECT [Id]
						  FROM [Addresses]
						 WHERE LEFT([Country], 1) = 'C'
				      )

DELETE FROM [Addresses]
WHERE LEFT([Country], 1) = 'C'



