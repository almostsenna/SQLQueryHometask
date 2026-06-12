USE Academy;
GO



-- 1. 
SELECT 
    Name,
    Financing,
    Id
FROM Departments;

-- 2. 
SELECT 
    Name AS [Group Name],
    Rating AS [Group Rating]
FROM [Groups];

-- 3. 
SELECT
    Surname,
    Salary / NULLIF(Premium, 0) * 100 AS [Salary to Premium Percent],
    Salary / (Salary + Premium) * 100 AS [Salary to Total Salary Percent]
FROM Teachers;

-- 4. 
SELECT 
    N'The dean of faculty ' + Name + N' is ' + Dean + N'.' AS [Faculty Info]
FROM Faculties;

-- 5. 
SELECT Surname
FROM Teachers
WHERE IsProfessor = 1
  AND Salary > 1050;

-- 6. 
SELECT Name
FROM Departments
WHERE Financing < 11000
   OR Financing > 25000;

-- 7
SELECT Name
FROM Faculties
WHERE Name <> N'Computer Science';

-- 8
SELECT 
    Surname,
    Position
FROM Teachers
WHERE IsProfessor = 0;

-- 9. 
SELECT 
    Surname,
    Position,
    Salary,
    Premium
FROM Teachers
WHERE IsAssistant = 1
  AND Premium BETWEEN 160 AND 550;

-- 10
SELECT 
    Surname,
    Salary
FROM Teachers
WHERE IsAssistant = 1;

-- 11
SELECT 
    Surname,
    Position
FROM Teachers
WHERE EmploymentDate < '20000101';

-- 12
SELECT 
    Name AS [Name of Department]
FROM Departments
WHERE Name < N'Software Development'
ORDER BY Name;

-- 13
SELECT Surname
FROM Teachers
WHERE IsAssistant = 1
  AND Salary + Premium <= 1200;

-- 14
SELECT Name
FROM [Groups]
WHERE Year = 5
  AND Rating BETWEEN 2 AND 4;

-- 15
SELECT Surname
FROM Teachers
WHERE IsAssistant = 1
  AND (Salary < 550 OR Premium < 200);
GO