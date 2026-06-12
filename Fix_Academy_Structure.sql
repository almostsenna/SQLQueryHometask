USE Academy;
GO

ALTER TABLE Faculties
ADD Dean NVARCHAR(MAX) NOT NULL DEFAULT N'Unknown Dean';
GO

ALTER TABLE Teachers
ADD 
    IsAssistant BIT NOT NULL DEFAULT 0,
    IsProfessor BIT NOT NULL DEFAULT 0,
    Position NVARCHAR(MAX) NOT NULL DEFAULT N'Unknown Position';
GO