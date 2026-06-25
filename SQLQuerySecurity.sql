--USE HogwartsDB;
--GO

--ALTER TABLE dbo.Wizards
--ALTER COLUMN BloodStatus ADD MASKED WITH (FUNCTION = 'partial(0, "XXXXX", 0)');
--GO

--2

USE HogwartsDB;
GO

CREATE TABLE MaraudersMapLogs
(
    TrackId INT IDENTITY(1,1) PRIMARY KEY,
    WizardName NVARCHAR(100) NOT NULL,
    [Location] NVARCHAR(100) NOT NULL,
    MovementTime DATETIME NOT NULL
);
GO

INSERT INTO MaraudersMapLogs (WizardName, [Location], MovementTime)
VALUES
(N'Гаррі Поттер', N'Велика зала', '2026-06-01T08:15:00'),
(N'Герміона Ґрейнджер', N'Бібліотека', '2026-06-15T14:30:00'),
(N'Рон Візлі', N'Грифіндорська вежа', '2026-06-30T23:50:00'),
(N'Драко Малфой', N'Підземелля', '2026-07-01T00:00:00'),
(N'Луна Лавґуд', N'Астрономічна вежа', '2026-05-31T23:59:00');
GO

SELECT TrackId, WizardName, Location, MovementTime
FROM MaraudersMapLogs
WHERE MovementTime >= '2026-06-01'
  AND MovementTime <  '2026-07-01';