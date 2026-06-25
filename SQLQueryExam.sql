-- Створення бази даних)

--CREATE DATABASE SmartDropDB;
--GO
--USE SmartDropDB;
--GO

--CREATE TABLE dbo.Users (
--UserId INT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
--FullName NVARCHAR(100) NOT NULL,
--City NVARCHAR(50) NOT NULL,
--Balance DECIMAL(18,2) NOT NULL
--CONSTRAINT DF_Users_Balance DEFAULT 0.00,
--BloodStatus_Demo NVARCHAR(50) NULL
--);

--CREATE TABLE dbo.Transactions (
--TransactionId INT IDENTITY(1,1) CONSTRAINT PK_Transactions PRIMARY KEY,
--UserId INT NOT NULL
--CONSTRAINT FK_Transactions_Users
--FOREIGN KEY REFERENCES dbo.Users(UserId),
--Amount DECIMAL(18,2) NOT NULL,
--TransactionDate DATETIME NOT NULL
--CONSTRAINT DF_Transactions_Date DEFAULT GETDATE(),
--MerchantId INT NOT NULL
--);

--CREATE TABLE dbo.Deliveries (
--DeliveryId INT IDENTITY(1,1) CONSTRAINT PK_Deliveries PRIMARY KEY,
--UserId INT NOT NULL
--CONSTRAINT FK_Deliveries_Users
--FOREIGN KEY REFERENCES dbo.Users(UserId),
--CourierName NVARCHAR(100) NOT NULL,
--DeliveryCost DECIMAL(10,2) NOT NULL
--CONSTRAINT CK_Deliveries_Cost CHECK (DeliveryCost >= 0),
--DistanceKm DECIMAL(5,2) NOT NULL,
--CurrentStatus NVARCHAR(30) NOT NULL,
--DeliveryDate DATETIME NOT NULL
--);
--GO

--INSERT INTO dbo.Users (FullName, City, Balance, BloodStatus_Demo) VALUES
--(N'Олексій Коваленко', N'Київ', 15400.50, 'Pure-blood'),
--(N'Марія Петренко', N'Львів', 850.00, 'Muggle-born'),
--(N'Іван Шевченко', N'Київ', 45000.00, 'Half-blood'),
--(N'Анна Бондар', N'Одеса', 320.00, 'Pure-blood'),
--(N'Дмитро Ткаченко', N'Львів', 1200.00, 'Unknown');

--INSERT INTO dbo.Transactions (UserId, Amount, TransactionDate, MerchantId) VALUES
--(1, 4500.00, '2026-06-01 10:30:00', 101),
--(1, 6000.00, '2026-06-02 14:15:00', 102), -- > 10 000 сума Коваленка
--(2, 500.00, '2026-06-01 11:00:00', 101),
--(3, 12000.00, '2026-06-03 09:00:00', 103), -- > 10 000 сума Шевченка
--(4, 150.00, '2026-05-15 18:20:00', 101), -- минулий місяць
--(5, 900.00, '2026-06-04 16:45:00', 102);

--INSERT INTO dbo.Deliveries
--(UserId, CourierName, DeliveryCost, DistanceKm, CurrentStatus, DeliveryDate)
--VALUES
--(1, N'Віталій Кличко', 250.00, 18.50, 'Delivered', '2026-06-01'),
--(3, N'Віталій Кличко', 90.00, 3.20, 'Delivered', '2026-06-02'),
--(2, N'Олег Скрипка', 300.00, 22.00, 'Cancelled', '2026-06-02'),
--(4, N'Олена Кравець', 120.00, 5.00, 'Delivered', '2026-06-03'),
--(5, N'Олег Скрипка', 180.00, 12.00, 'In Progress', '2026-06-04');
--GO

-- Завдання( ну що,поїхали))
--Завд.1

--SELECT
--	u.FullName,
--	SUM(t.Amount) AS TotalTransactionAmount
--FROM dbo.Users AS u
--JOIN dbo.Transactions AS t
--    ON u.UserId = t.UserId
--WHERE 
--    t.TransactionDate >= '2026-06-01'
--    AND t.TransactionDate < '2026-07-01'
--GROUP BY 
--    u.FullName
--HAVING 
--    SUM(t.Amount) > 10000
--ORDER BY 
--    TotalTransactionAmount DESC;


--Завд.2
--SELECT
--    DeliveryId,
--    CourierName,
--    DeliveryCost,
--    CASE
--        WHEN CurrentStatus = 'Cancelled' THEN 'Loss'
--        WHEN DeliveryCost > 200 AND DistanceKm > 15 THEN 'Premium'
--        ELSE 'Standard'
--    END AS DeliveryCategory
--FROM dbo.Deliveries;

--Завд.3
--SELECT
--    u.City,
--    d.CourierName,
--    d.DeliveryCost,
--    ROW_NUMBER() OVER (
--        PARTITION BY u.City
--        ORDER BY d.DeliveryCost DESC
--    ) AS CourierRank
--FROM dbo.Deliveries AS d
--JOIN dbo.Users AS u
--    ON d.UserId = u.UserId
--ORDER BY
--    u.City,
--    CourierRank;

-- Завд.4

--CREATE OR ALTER PROCEDURE dbo.sp_ProcessPayment
--	@UserId INT,
--	@Amount DECIMAL(18,2),
--	@MerchantId INT
--AS
--BEGIN
--	SET  NOCOUNT ON;
--	BEGIN TRY
--		BEGIN TRANSACTION;

--		DECLARE @CurrentBalance DECIMAL(18,2);
--		SELECT 
--			@CurrentBalance = Balance
--		From dbo.Users
--		WHERE UserId = @UserId;

--		IF @CurrentBalance < @Amount
--		BEGIN

--		THROW 50001, 'В користувача гроші всьо, нєма))',1;
--		END;

--		UPDATE dbo.Users
--		SET Balance = Balance - @Amount
--		WHERE UserId = @UserId;

--		INSERT INTO dbo.Transactions 
--			(UserId, Amount, MerchantId)
--		Values
--			(@UserId, @Amount, @MerchantId);
--		COMMIT TRANSACTION;

--	END TRY
--    BEGIN CATCH
--        IF @@TRANCOUNT > 0
--        BEGIN
--            ROLLBACK TRANSACTION;
--        END;

--        THROW;
--    END CATCH;
--END;


--Завд.5


-- Неоптимальний запит:
-- SELECT * 
-- FROM dbo.Transactions
-- WHERE YEAR(TransactionDate) = 2026 
--   AND MONTH(TransactionDate) = 6;

-- Таке дуже так собі робити, бо наші умови YEAR(TransactionDate) і MONTH(TransactionDate) роблять запит non-SARGable, і сам запит буде дуже повільним, а нам цього нє нада)
-- SARGability = це Search ARGument ABLE, тобто умова написана таким чином, щоб SQL Server міг використати індекс для швидкого пошуку, а це нам вже треба)
-- Просто, коли ми застосовуємо функцію до колонки TransactionDate, наш SQL Server змушений обчислювати YEAR() і MONTH() для кожного рядка, і через це він часто не може виконати Index Seek
-- У плані виконання це може призвести до Index Scan або Table Scan, тобто Scan означає, що сервер переглядає багато рядків, а Seek означає, що сервер одразу знаходить потрібний діапазон в індексі

--ось вже наш нормальний SARGable-запит:
SELECT 
    TransactionId,
    UserId,
    Amount,
    TransactionDate,
    MerchantId
FROM dbo.Transactions
WHERE 
    TransactionDate >= '2026-06-01'
    AND TransactionDate <  '2026-07-01';

-- Некластеризований покриваючий індекс:
-- TransactionDate ставимо в ключ індексу, бо по ньому йде фільтрація, Amount ми додаємо в INCLUDE, бо додаток часто читає суму операції
-- а UserId і MerchantId ми будемо додавати в INCLUDE, щоб індекс, по суті, покривав цей SELECT)
CREATE NONCLUSTERED INDEX Indx_Transactions_TransactionDate_Covering
ON dbo.Transactions (TransactionDate)
INCLUDE (UserId, Amount, MerchantId);

--нарешті, ахахаха))