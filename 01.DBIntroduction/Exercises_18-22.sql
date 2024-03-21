--task #18
INSERT INTO Towns VALUES ('Sofia'), ('Plovdiv'), ('Varna'), ('Burgas')

INSERT INTO Departments VALUES ('Engineering'), ('Sales'), ('Marketing'), ('Software Development'), ('Quality Assurance')

INSERT INTO Employees ([FirstName], [MiddleName],[LastName], [JobTitle], [DepartmentId], [HireDate], [Salary])
	VALUES
	('Ivan', 'Ivanov', 'Ivanov', '.NET Developer',  4, '2013-02-01', 3500.00),
	('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
	('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
	('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
	('Peter', 'Pan', 'Pan', 'Intern',  3, '2016-08-28', 599.98)

--task #19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--task #20
SELECT * FROM Towns ORDER BY [Name] ASC
SELECT * FROM Departments ORDER BY [Name] ASC
SELECT * FROM Employees ORDER BY Salary DESC

--task #21
SELECT [Name] FROM Towns ORDER BY [Name] ASC
SELECT [Name] FROM Departments ORDER BY [Name] ASC
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

--task #22
UPDATE Employees SET Salary = Salary * 1.1;
SELECT Salary FROM Employees
