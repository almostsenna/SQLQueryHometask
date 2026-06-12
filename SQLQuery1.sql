--USE master;
--GO

--CREATE DATABASE HogwartsDB
--ON PRIMARY 
--(
--	NAME = HogwartsDB_Data,
--	FILENAME = 'C:\SQLData\HogwartsDB.mdf', 
--    SIZE = 25MB,
--	MAXSIZE = 250MB,
--    FILEGROWTH = 5MB
--),
--FILEGROUP ForbiddenSection 
--(
	
--	NAME = ForbiddenSection_Data,
--	FILENAME = 'C:\SQLData\ForbiddenSection.ndf', 
--    SIZE = 10MB,
--	MAXSIZE = 100MB,
--    FILEGROWTH = 2MB
--)
--LOG ON
--(
--	NAME = HogwartsDB_Log,
--	FILENAME = 'C:\SQLData\HogwartsDB_log.ldf', 
--    SIZE = 10MB,
--	MAXSIZE = 100MB,
--    FILEGROWTH = 2MB
--);

--GO
--USE HogwartsDB;
--GO

--CREATE TABLE Wizards 
--(
--	WizardId INT IDENTITY(1, 1) PRIMARY KEY,
--	[Name] NVARCHAR(100) NOT NULL,
--	[House] NVARCHAR(50) NOT NULL,
--	[BloodStatus] NVARCHAR(30) CONSTRAINT DF_Wizards_BloodStatus DEFAULT 'Unknown',

 	

--);
--GO