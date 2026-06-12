

--CREATE DATABASE Academy;
--GO

--USE Academy;
--GO

--CREATE TABLE Groups (
--    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
--    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(Name) > 0),
--    Rating INT NOT NULL CHECK (Rating BETWEEN 0 AND 5),
--    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5)
--);


--CREATE TABLE Departments (
--    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
--    Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0),
--    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
--);


--CREATE TABLE Faculties (
--    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
--    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
--);


--CREATE TABLE Teachers (
--    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
--    EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01'),
--    Name NVARCHAR(MAX) NOT NULL CHECK (LEN(Name) > 0),
--    Premium MONEY NOT NULL DEFAULT 0 CHECK (Premium >= 0),
--    Salary MONEY NOT NULL CHECK (Salary > 0),
--    Surname NVARCHAR(MAX) NOT NULL CHECK (LEN(Surname) > 0)
--);