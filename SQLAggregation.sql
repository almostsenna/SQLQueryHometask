--USE Academy;
--GO

--ALTER TABLE [Groups]
--ADD StudentsCount INT NULL;
--GO

--ALTER TABLE Lectures
--ADD LectureDay NVARCHAR(20) NULL;
--GO

--UPDATE [Groups]
--SET StudentsCount = 25
--WHERE Name = N'P107';

--UPDATE [Groups]
--SET StudentsCount = 18
--WHERE Name = N'P507';

--UPDATE Lectures
--SET LectureDay = N'Monday'
--WHERE LectureRoom = N'B103';
--GO

--USE Academy;
--GO

--IF NOT EXISTS (
--    SELECT 1 
--    FROM Teachers 
--    WHERE Name = N'Dave' AND Surname = N'McQueen'
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
--        '2001-09-01',
--        N'Dave',
--        300,
--        1600,
--        N'McQueen',
--        0,
--        1,
--        N'Professor'
--    );
--END

--IF NOT EXISTS (
--    SELECT 1 
--    FROM Teachers 
--    WHERE Name = N'Jack' AND Surname = N'Underhill'
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
--        '2008-02-15',
--        N'Jack',
--        200,
--        1300,
--        N'Underhill',
--        0,
--        0,
--        N'Lecturer'
--    );
--END
--GO

--USE Academy;
--GO

--IF NOT EXISTS (SELECT 1 FROM Subjects WHERE Name = N'C# Programming')
--BEGIN
--    INSERT INTO Subjects (Name)
--    VALUES (N'C# Programming');
--END

--IF NOT EXISTS (SELECT 1 FROM Subjects WHERE Name = N'Algorithms')
--BEGIN
--    INSERT INTO Subjects (Name)
--    VALUES (N'Algorithms');
--END
--GO

--USE Academy;
--GO

--DECLARE @DaveId INT;
--DECLARE @JackId INT;
--DECLARE @CSharpId INT;
--DECLARE @AlgorithmsId INT;

--SELECT @DaveId = Id 
--FROM Teachers 
--WHERE Name = N'Dave' AND Surname = N'McQueen';

--SELECT @JackId = Id 
--FROM Teachers 
--WHERE Name = N'Jack' AND Surname = N'Underhill';

--SELECT @CSharpId = Id 
--FROM Subjects 
--WHERE Name = N'C# Programming';

--SELECT @AlgorithmsId = Id 
--FROM Subjects 
--WHERE Name = N'Algorithms';

--IF NOT EXISTS (
--    SELECT 1 
--    FROM Lectures 
--    WHERE TeacherId = @DaveId 
--      AND SubjectId = @CSharpId 
--      AND LectureRoom = N'D201'
--)
--BEGIN
--    INSERT INTO Lectures (SubjectId, TeacherId, LectureRoom, LectureDay)
--    VALUES (@CSharpId, @DaveId, N'D201', N'Tuesday');
--END

--IF NOT EXISTS (
--    SELECT 1 
--    FROM Lectures 
--    WHERE TeacherId = @JackId 
--      AND SubjectId = @AlgorithmsId 
--      AND LectureRoom = N'D201'
--)
--BEGIN
--    INSERT INTO Lectures (SubjectId, TeacherId, LectureRoom, LectureDay)
--    VALUES (@AlgorithmsId, @JackId, N'D201', N'Wednesday');
--END
--GO

--USE Academy;
--GO

--DECLARE @P107Id INT;
--DECLARE @P507Id INT;
--DECLARE @DaveLectureId INT;
--DECLARE @JackLectureId INT;

--SELECT @P107Id = Id
--FROM [Groups]
--WHERE Name = N'P107';

--SELECT @P507Id = Id
--FROM [Groups]
--WHERE Name = N'P507';

--SELECT @DaveLectureId = Lectures.Id
--FROM Lectures
--JOIN Teachers ON Teachers.Id = Lectures.TeacherId
--JOIN Subjects ON Subjects.Id = Lectures.SubjectId
--WHERE Teachers.Name = N'Dave'
--  AND Teachers.Surname = N'McQueen'
--  AND Subjects.Name = N'C# Programming'
--  AND Lectures.LectureRoom = N'D201';

--SELECT @JackLectureId = Lectures.Id
--FROM Lectures
--JOIN Teachers ON Teachers.Id = Lectures.TeacherId
--JOIN Subjects ON Subjects.Id = Lectures.SubjectId
--WHERE Teachers.Name = N'Jack'
--  AND Teachers.Surname = N'Underhill'
--  AND Subjects.Name = N'Algorithms'
--  AND Lectures.LectureRoom = N'D201';

--IF NOT EXISTS (
--    SELECT 1 
--    FROM GroupsLectures 
--    WHERE GroupId = @P507Id AND LectureId = @DaveLectureId
--)
--BEGIN
--    INSERT INTO GroupsLectures (GroupId, LectureId)
--    VALUES (@P507Id, @DaveLectureId);
--END

--IF NOT EXISTS (
--    SELECT 1 
--    FROM GroupsLectures 
--    WHERE GroupId = @P107Id AND LectureId = @JackLectureId
--)
--BEGIN
--    INSERT INTO GroupsLectures (GroupId, LectureId)
--    VALUES (@P107Id, @JackLectureId);
--END
--GO
---- перевірка чи я добавив Дейва і Джека)
--USE Academy; 
--GO

--SELECT 
--    Teachers.Name,
--    Teachers.Surname,
--    Subjects.Name AS SubjectName,
--    [Groups].Name AS GroupName,
--    Lectures.LectureRoom,
--    Lectures.LectureDay
--FROM Teachers
--JOIN Lectures ON Lectures.TeacherId = Teachers.Id
--JOIN Subjects ON Subjects.Id = Lectures.SubjectId
--JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
--JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
--ORDER BY Teachers.Surname;
---- 1.
SELECT 
    COUNT(DISTINCT Teachers.Id) AS TeachersCount
FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
JOIN Departments ON Departments.Id = [Groups].DepartmentId
WHERE Departments.Name = N'Software Development';
---- 2.
SELECT 
    COUNT(*) AS LecturesCount
FROM Lectures
JOIN Teachers ON Teachers.Id = Lectures.TeacherId
WHERE Teachers.Name = N'Dave'
  AND Teachers.Surname = N'McQueen';
---- 3.
SELECT 
    COUNT(*) AS LessonsCount
FROM Lectures
WHERE LectureRoom = N'D201';
---- 4.
SELECT 
    LectureRoom,
    COUNT(*) AS LecturesCount
FROM Lectures
GROUP BY LectureRoom;
---- 5.
SELECT 
    SUM(GroupData.StudentsCount) AS StudentsCount
FROM (
    SELECT DISTINCT
        [Groups].Id,
        [Groups].StudentsCount
    FROM Teachers
    JOIN Lectures ON Lectures.TeacherId = Teachers.Id
    JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
    JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
    WHERE Teachers.Name = N'Jack'
      AND Teachers.Surname = N'Underhill'
) AS GroupData;
---- 6.
SELECT 
    AVG(Teachers.Salary) AS AverageSalary
FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
JOIN Departments ON Departments.Id = [Groups].DepartmentId
JOIN Faculties ON Faculties.Id = Departments.FacultyId
WHERE Faculties.Name IN (N'Computer Science', N'Комп''ютерні науки');
---- 7.
SELECT 
    MIN(StudentsCount) AS MinStudentsCount,
    MAX(StudentsCount) AS MaxStudentsCount
FROM [Groups];
---- 8.
SELECT 
    AVG(Financing) AS AverageDepartmentFinancing
FROM Departments;
---- 9.
SELECT 
    Teachers.Name + N' ' + Teachers.Surname AS FullName,
    COUNT(DISTINCT Subjects.Id) AS SubjectsCount
FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN Subjects ON Subjects.Id = Lectures.SubjectId
GROUP BY Teachers.Name, Teachers.Surname;
---- 10.
SELECT 
    LectureDay,
    COUNT(*) AS LecturesCount
FROM Lectures
GROUP BY LectureDay
ORDER BY 
    CASE LectureDay
        WHEN N'Monday' THEN 1
        WHEN N'Tuesday' THEN 2
        WHEN N'Wednesday' THEN 3
        WHEN N'Thursday' THEN 4
        WHEN N'Friday' THEN 5
        WHEN N'Saturday' THEN 6
        WHEN N'Sunday' THEN 7
        ELSE 8
    END;
---- 11.
SELECT 
    Lectures.LectureRoom,
    COUNT(DISTINCT Departments.Id) AS DepartmentsCount
FROM Lectures
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN [Groups] ON [Groups].Id = GroupsLectures.GroupId
JOIN Departments ON Departments.Id = [Groups].DepartmentId
GROUP BY Lectures.LectureRoom;
---- 12.
SELECT 
    Faculties.Name AS FacultyName,
    COUNT(DISTINCT Subjects.Id) AS SubjectsCount
FROM Faculties
JOIN Departments ON Departments.FacultyId = Faculties.Id
JOIN [Groups] ON [Groups].DepartmentId = Departments.Id
JOIN GroupsLectures ON GroupsLectures.GroupId = [Groups].Id
JOIN Lectures ON Lectures.Id = GroupsLectures.LectureId
JOIN Subjects ON Subjects.Id = Lectures.SubjectId
GROUP BY Faculties.Name;
---- 13. 
SELECT 
    Teachers.Name + N' ' + Teachers.Surname AS TeacherFullName,
    Lectures.LectureRoom,
    COUNT(*) AS LecturesCount
FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
GROUP BY 
    Teachers.Name,
    Teachers.Surname,
    Lectures.LectureRoom;