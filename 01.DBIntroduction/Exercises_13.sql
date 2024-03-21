--task #13
CREATE DATABASE Movies
GO
USE Movies


CREATE TABLE Directors (
	[Id] INT PRIMARY KEY,
	[DirectorName] VARCHAR(50) NOT NULL,
	[Notes] VARCHAR(2500)
)

CREATE TABLE Genres (
	[Id] INT PRIMARY KEY,
	[GenreName] VARCHAR(100) NOT NULL,
	[Notes] VARCHAR(2500)
	)

CREATE TABLE Categories (
	[Id] INT PRIMARY KEY,
	[CategoryName] VARCHAR(50) NOT NULL,
	[Notes] VARCHAR(2500)
	)

GO
CREATE TABLE Movies (
	[Id] INT PRIMARY KEY IDENTITY,
	[Title] VARCHAR(250) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES Directors(Id),
	[CopyrightYear] SMALLINT,
	[Length] TIME,
	[GenreId] INT FOREIGN KEY REFERENCES Genres(Id),
	[CategoryId] INT FOREIGN KEY REFERENCES Categories(Id),
	[Rating] FLOAT,
	[Notes] VARCHAR(2500)
)

--DROP TABLE Movies

INSERT INTO Directors([Id], [DirectorName])
	VALUES
	(1, 'Clint Eastwood'),
	(2, 'Christopher Nolan'),
	(3, 'Greta Gerwig'),
	(4, 'Peter Jackson'),
	(5, 'Michael Scott')

INSERT INTO Genres([Id], GenreName)
	VALUES
	(1, 'Action'),
	(2, 'Thriller'),
	(3, 'Comedy'),
	(4, 'Fantasy'),
	(5, 'Crime')

INSERT INTO Categories([Id], [CategoryName])
	VALUES
	(1, '18+'),
	(2, 'PG-13'),
	(3, 'PG-8'),
	(4, '16+'),
	(5, '3+')

INSERT INTO Movies([Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId], [Rating], [Notes])
	VALUES
	('Gran Torino', 1, 2007, '02:20:12', 2, 3, 8.2, 'Not great, not terrible'),
	('The Dark Knight', 2, 2010, '02:40:31', 1, 4, 8.9, 'Awesome'),
	('Barbie', 3, 2023, '02:05:12', 3, 3, 8.2, 'He''s just Ken'),
	('Lord of the rings', 4, 2000, '03:10:44', 4, 2, 9.0, 'Fantastic'),
	('Threat level Midnight', 5, 2024, '02:14:12', 5, 5, 10, 'Updog')