--USE Academy;
--GO

---- Додаємо фонд фінансування факультету ( я вирішив піти по хардкору... Тому що, а чому б ні))
--IF COL_LENGTH('Faculties', 'Financing') IS NULL
--BEGIN
--    ALTER TABLE Faculties
--    ADD Financing MONEY NULL;
--END
--GO

---- Додаємо зв'язок кафедри з факультетом
--IF COL_LENGTH('Departments', 'FacultyId') IS NULL
--BEGIN
--    ALTER TABLE Departments
--    ADD FacultyId INT NULL;
--END
--GO

---- Додаємо зв'язок групи з кафедрою
--IF COL_LENGTH('Groups', 'DepartmentId') IS NULL
--BEGIN
--    ALTER TABLE [Groups]
--    ADD DepartmentId INT NULL;
--END
--GO

--USE Academy;
--GO

--IF OBJECT_ID('Subjects', 'U') IS NULL
--BEGIN
--    CREATE TABLE Subjects
--    (
--        Id INT IDENTITY(1,1) PRIMARY KEY,
--        Name NVARCHAR(100) NOT NULL UNIQUE CHECK (LEN(Name) > 0)
--    );
--END
--GO

--USE Academy;
--GO

--IF OBJECT_ID('Lectures', 'U') IS NULL
--BEGIN
--    CREATE TABLE Lectures
--    (
--        Id INT IDENTITY(1,1) PRIMARY KEY,
--        SubjectId INT NOT NULL,
--        TeacherId INT NOT NULL,
--        LectureRoom NVARCHAR(20) NOT NULL CHECK (LEN(LectureRoom) > 0)
--    );
--END
--GO

--USE Academy;
--GO

--IF OBJECT_ID('GroupsLectures', 'U') IS NULL
--BEGIN
--    CREATE TABLE GroupsLectures
--    (
--        Id INT IDENTITY(1,1) PRIMARY KEY,
--        GroupId INT NOT NULL,
--        LectureId INT NOT NULL
--    );
--END
--GO

--USE Academy;
--GO

--IF OBJECT_ID('Curators', 'U') IS NULL
--BEGIN
--    CREATE TABLE Curators
--    (
--        Id INT IDENTITY(1,1) PRIMARY KEY,
--        TeacherId INT NOT NULL
--    );
--END
--GO

--USE Academy;
--GO

--IF OBJECT_ID('GroupsCurators', 'U') IS NULL
--BEGIN
--    CREATE TABLE GroupsCurators
--    (
--        Id INT IDENTITY(1,1) PRIMARY KEY,
--        GroupId INT NOT NULL,
--        CuratorId INT NOT NULL
--    );
--END
--GO
-- тут я сперечався з чатом на рахунок цього, і думав, що можна зробити по іншому як в прикладі конспекту,
-- але чат сказав що спосіб нижче буде тут більш доцільним, а той з нуля
-- ось структура, яку я хотів використати, як приклад:

-------- CREATE TABLE Wands
--------(
--------    WandId INT IDENTITY(1,1) PRIMARY KEY,
--------    CoreMaterial NVARCHAR(100) NOT NULL,
--------    Length DECIMAL(4,1) NOT NULL,
--------    WizardId INT NOT NULL UNIQUE, -- UNIQUE гарантує зв'язок 1:1 (в одного мага - одна паличка)
    
--------    CONSTRAINT FK_Wands_Wizards FOREIGN KEY (WizardId) REFERENCES Wizards(WizardId)
--------);
--------GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_Departments_Faculties'
--)
--BEGIN
--    ALTER TABLE Departments
--    ADD CONSTRAINT FK_Departments_Faculties
--    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_Groups_Departments'
--)
--BEGIN
--    ALTER TABLE [Groups]
--    ADD CONSTRAINT FK_Groups_Departments
--    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_Lectures_Teachers'
--)
--BEGIN
--    ALTER TABLE Lectures
--    ADD CONSTRAINT FK_Lectures_Teachers
--    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_GroupsLectures_Groups'
--)
--BEGIN
--    ALTER TABLE GroupsLectures
--    ADD CONSTRAINT FK_GroupsLectures_Groups
--    FOREIGN KEY (GroupId) REFERENCES [Groups](Id);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_GroupsLectures_Lectures'
--)
--BEGIN
--    ALTER TABLE GroupsLectures
--    ADD CONSTRAINT FK_GroupsLectures_Lectures
--    FOREIGN KEY (LectureId) REFERENCES Lectures(Id);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_Curators_Teachers'
--)
--BEGIN
--    ALTER TABLE Curators
--    ADD CONSTRAINT FK_Curators_Teachers
--    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_GroupsCurators_Groups'
--)
--BEGIN
--    ALTER TABLE GroupsCurators
--    ADD CONSTRAINT FK_GroupsCurators_Groups
--    FOREIGN KEY (GroupId) REFERENCES [Groups](Id);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM sys.foreign_keys 
--    WHERE name = 'FK_GroupsCurators_Curators'
--)
--BEGIN
--    ALTER TABLE GroupsCurators
--    ADD CONSTRAINT FK_GroupsCurators_Curators
--    FOREIGN KEY (CuratorId) REFERENCES Curators(Id);
--END
--GO

--USE Academy;
--GO

--UPDATE Faculties
--SET Financing = 20000
--WHERE Name = N'Computer Science';

--UPDATE Faculties
--SET Financing = 15000
--WHERE Name = N'Mathematics';

--UPDATE Faculties
--SET Financing = 12000
--WHERE Name = N'Physics';
--GO

--USE Academy;
--GO

--IF NOT EXISTS (SELECT 1 FROM Faculties WHERE Name = N'Комп''ютерні науки')
--BEGIN
--    INSERT INTO Faculties (Name, Dean, Financing)
--    VALUES (N'Комп''ютерні науки', N'Samantha Adams', 20000);
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (SELECT 1 FROM Departments WHERE Name = N'Software Development')
--BEGIN
--    INSERT INTO Departments (Financing, Name, FacultyId)
--    VALUES (
--        30000, 
--        N'Software Development',
--        (SELECT Id FROM Faculties WHERE Name = N'Комп''ютерні науки')
--    );
--END

--IF NOT EXISTS (SELECT 1 FROM Departments WHERE Name = N'Database Theory')
--BEGIN
--    INSERT INTO Departments (Financing, Name, FacultyId)
--    VALUES (
--        25000, 
--        N'Database Theory',
--        (SELECT Id FROM Faculties WHERE Name = N'Комп''ютерні науки')
--    );
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (SELECT 1 FROM [Groups] WHERE Name = N'P107')
--BEGIN
--    INSERT INTO [Groups] (Name, Rating, Year, DepartmentId)
--    VALUES (N'P107', 5, 1, 
--        (SELECT Id FROM Departments WHERE Name = N'Software Development'));
--END

--IF NOT EXISTS (SELECT 1 FROM [Groups] WHERE Name = N'P507')
--BEGIN
--    INSERT INTO [Groups] (Name, Rating, Year, DepartmentId)
--    VALUES (N'P507', 4, 5, 
--        (SELECT Id FROM Departments WHERE Name = N'Database Theory'));
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 FROM Teachers 
--    WHERE Name = N'Samantha' AND Surname = N'Adams'
--)
--BEGIN
--    INSERT INTO Teachers
--    (
--        EmploymentDate,
--        Name,
--        Premium,
--        Salary,
--        Surname,
--        IsAssistant,
--        IsProfessor,
--        Position
--    )
--    VALUES
--    (
--        '2005-09-01',
--        N'Samantha',
--        500,
--        1800,
--        N'Adams',
--        0,
--        1,
--        N'Professor'
--    );
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (SELECT 1 FROM Subjects WHERE Name = N'Теорія баз даних')
--BEGIN
--    INSERT INTO Subjects (Name)
--    VALUES (N'Теорія баз даних');
--END

--IF NOT EXISTS (SELECT 1 FROM Subjects WHERE Name = N'C# Programming')
--BEGIN
--    INSERT INTO Subjects (Name)
--    VALUES (N'C# Programming');
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM Lectures
--    WHERE SubjectId = (SELECT Id FROM Subjects WHERE Name = N'Теорія баз даних')
--      AND TeacherId = (
--            SELECT Id FROM Teachers 
--            WHERE Name = N'Samantha' AND Surname = N'Adams'
--      )
--      AND LectureRoom = N'B103'
--)
--BEGIN
--    INSERT INTO Lectures (SubjectId, TeacherId, LectureRoom)
--    VALUES
--    (
--        (SELECT Id FROM Subjects WHERE Name = N'Теорія баз даних'),
--        (SELECT Id FROM Teachers WHERE Name = N'Samantha' AND Surname = N'Adams'),
--        N'B103'
--    );
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1
--    FROM GroupsLectures
--    WHERE GroupId = (SELECT Id FROM [Groups] WHERE Name = N'P107')
--      AND LectureId = (
--            SELECT L.Id
--            FROM Lectures L
--            JOIN Subjects S ON S.Id = L.SubjectId
--            WHERE S.Name = N'Теорія баз даних'
--              AND L.LectureRoom = N'B103'
--      )
--)
--BEGIN
--    INSERT INTO GroupsLectures (GroupId, LectureId)
--    VALUES
--    (
--        (SELECT Id FROM [Groups] WHERE Name = N'P107'),
--        (
--            SELECT L.Id
--            FROM Lectures L
--            JOIN Subjects S ON S.Id = L.SubjectId
--            WHERE S.Name = N'Теорія баз даних'
--              AND L.LectureRoom = N'B103'
--        )
--    )
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1
--    FROM Curators
--    WHERE TeacherId = (
--        SELECT Id FROM Teachers 
--        WHERE Name = N'Samantha' AND Surname = N'Adams'
--    )
--)
--BEGIN
--    INSERT INTO Curators (TeacherId)
--    VALUES (
--        (SELECT Id FROM Teachers 
--         WHERE Name = N'Samantha' AND Surname = N'Adams')
--    );
--END
--GO

--IF NOT EXISTS (
--    SELECT 1
--    FROM GroupsCurators
--    WHERE GroupId = (SELECT Id FROM [Groups] WHERE Name = N'P107')
--      AND CuratorId = (
--            SELECT C.Id
--            FROM Curators C
--            JOIN Teachers T ON T.Id = C.TeacherId
--            WHERE T.Name = N'Samantha' AND T.Surname = N'Adams'
--      )
--)
--BEGIN
--    INSERT INTO GroupsCurators (GroupId, CuratorId)
--    VALUES
--    (
--        (SELECT Id FROM [Groups] WHERE Name = N'P107'),
--        (
--            SELECT C.Id
--            FROM Curators C
--            JOIN Teachers T ON T.Id = C.TeacherId
--            WHERE T.Name = N'Samantha' AND T.Surname = N'Adams'
--        )
--    );
--END
--GO



--USE Academy;
--GO

--ALTER TABLE Lectures
--ADD CONSTRAINT FK_Lectures_Subjects
--FOREIGN KEY (SubjectId) REFERENCES Subjects(Id);
--GO

USE Academy;
GO

-- 1. Вивести всі можливі пари рядків викладачів та груп.
SELECT 
    Teachers.Surname AS TeacherSurname,
    [Groups].Name AS GroupName
FROM Teachers
CROSS JOIN [Groups];

-- 2. Вивести назви факультетів, на яких фонд фінансування кафедр перевищує фонд фінансування факультету.
SELECT DISTINCT
    Faculties.Name AS FacultyName
FROM Faculties
JOIN Departments ON Departments.FacultyId = Faculties.Id
WHERE Departments.Financing > Faculties.Financing;

-- 3. Вивести прізвища кураторів груп та назви груп, які вони курують.
SELECT 
    Teachers.Surname AS CuratorSurname,
    [Groups].Name AS GroupName
FROM Teachers
JOIN Curators ON Curators.TeacherId = Teachers.Id
JOIN GroupsCurators ON GroupsCurators.CuratorId = Curators.Id
JOIN [Groups] ON [Groups].Id = GroupsCurators.GroupId;

-- 4. Вивести прізвища викладачів, які читають лекції у групі P107.
SELECT DISTINCT
    Teachers.Surname AS TeacherSurname
FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
WHERE [Groups].Name = N'P107';

-- 5. Вивести прізвища викладачів та назви факультетів, на яких вони читають лекції.
SELECT DISTINCT
    Teachers.Surname AS TeacherSurname,
    Faculties.Name AS FacultyName
FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
JOIN Departments ON Departments.Id = [Groups].DepartmentId
JOIN Faculties ON Faculties.Id = Departments.FacultyId;

-- 6. Виведіть назви кафедр та назви груп, які до них відносяться.
SELECT 
    Departments.Name AS DepartmentName,
    [Groups].Name AS GroupName
FROM Departments
JOIN [Groups] ON [Groups].DepartmentId = Departments.Id;

-- 7. Виведіть назви предметів, які викладає викладач Samantha Adams.
SELECT DISTINCT
    Subjects.Name AS SubjectName
FROM Subjects
JOIN Lectures ON Lectures.SubjectId = Subjects.Id
JOIN Teachers ON Teachers.Id = Lectures.TeacherId
WHERE Teachers.Name = N'Samantha'
  AND Teachers.Surname = N'Adams';

-- 8. Виведіть назви кафедр, на яких викладається предмет Теорія баз даних.
SELECT DISTINCT
    Departments.Name AS DepartmentName
FROM Departments
JOIN [Groups] ON [Groups].DepartmentId = Departments.Id
JOIN GroupsLectures ON GroupsLectures.GroupId = [Groups].Id
JOIN Lectures ON Lectures.Id = GroupsLectures.LectureId
JOIN Subjects ON Subjects.Id = Lectures.SubjectId
WHERE Subjects.Name = N'Теорія баз даних';

-- 9. Виведіть назви груп, які належать до факультету Комп'ютерні науки.
SELECT 
    [Groups].Name AS GroupName
FROM [Groups]
JOIN Departments ON Departments.Id = [Groups].DepartmentId
JOIN Faculties ON Faculties.Id = Departments.FacultyId
WHERE Faculties.Name = N'Комп''ютерні науки';

-- 10. Виведіть назви груп 5-го курсу, а також назви факультетів, до яких вони відносяться.
SELECT 
    [Groups].Name AS GroupName,
    Faculties.Name AS FacultyName
FROM [Groups]
JOIN Departments ON Departments.Id = [Groups].DepartmentId
JOIN Faculties ON Faculties.Id = Departments.FacultyId
WHERE [Groups].Year = 5;

-- 11. Вивести прізвища викладачів та лекції, які вони читають,
-- тобто назви дисциплін та груп, лише для аудиторії B103.
SELECT 
    Teachers.Surname AS TeacherSurname,
    Subjects.Name AS SubjectName,
    [Groups].Name AS GroupName
FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN Subjects ON Subjects.Id = Lectures.SubjectId
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
WHERE Lectures.LectureRoom = N'B103';
GO