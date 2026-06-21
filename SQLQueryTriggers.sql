CREATE DATABASE SportsShop;
GO

USE SportsShop;
GO

CREATE TABLE ProductTypes
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Manufacturers
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE Products
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ProductTypeId INT NOT NULL,
    ManufacturerId INT NOT NULL,
    Price MONEY NOT NULL CHECK (Price > 0),
    Quantity INT NOT NULL CHECK (Quantity >= 0),

    CONSTRAINT FK_Products_ProductTypes
        FOREIGN KEY (ProductTypeId) REFERENCES ProductTypes(Id),

    CONSTRAINT FK_Products_Manufacturers
        FOREIGN KEY (ManufacturerId) REFERENCES Manufacturers(Id)
);
GO

CREATE TABLE Customers
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL,
    BirthDate DATE NOT NULL,
    RegistrationDate DATE NOT NULL
);
GO

CREATE TABLE Sellers
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(150) NOT NULL
);
GO

CREATE TABLE Sales
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    SellerId INT NOT NULL,
    SaleDate DATE NOT NULL,

    CONSTRAINT FK_Sales_Customers
        FOREIGN KEY (CustomerId) REFERENCES Customers(Id),

    CONSTRAINT FK_Sales_Sellers
        FOREIGN KEY (SellerId) REFERENCES Sellers(Id)
);
GO

CREATE TABLE SaleItems
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SaleId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice MONEY NOT NULL CHECK (UnitPrice > 0),

    CONSTRAINT FK_SaleItems_Sales
        FOREIGN KEY (SaleId) REFERENCES Sales(Id),

    CONSTRAINT FK_SaleItems_Products
        FOREIGN KEY (ProductId) REFERENCES Products(Id)
);
GO

USE SportsShop;
GO

INSERT INTO ProductTypes (Name)
VALUES
(N'Взуття'),
(N'Одяг'),
(N'Аксесуари');

INSERT INTO Manufacturers (Name)
VALUES
(N'Nike'),
(N'Adidas'),
(N'Puma');

INSERT INTO Products (Name, ProductTypeId, ManufacturerId, Price, Quantity)
VALUES
(N'Nike Air Max', 1, 1, 4500, 10),
(N'Adidas Ultraboost', 1, 2, 5200, 5),
(N'Puma Runner', 1, 3, 3200, 0),
(N'Nike T-Shirt', 2, 1, 1200, 20),
(N'Adidas Hoodie', 2, 2, 2500, 7),
(N'Puma Cap', 3, 3, 800, 15);

INSERT INTO Customers (FullName, BirthDate, RegistrationDate)
VALUES
(N'John Smith', '1990-05-12', '2020-01-10'),
(N'Anna Brown', '1988-03-22', '2019-06-15'),
(N'Mike Johnson', '1995-11-02', '2021-09-01'),
(N'Kate Wilson', '1992-07-19', '2018-12-05'),
(N'Tom Hardy', '1985-01-30', '2023-03-20');

INSERT INTO Sellers (FullName)
VALUES
(N'Dave McQueen'),
(N'Jack Underhill'),
(N'Samantha Adams');

INSERT INTO Sales (CustomerId, SellerId, SaleDate)
VALUES
(1, 1, '2024-01-10'),
(2, 1, '2024-02-15'),
(3, 2, '2024-03-20'),
(4, 3, '2024-04-05');

INSERT INTO SaleItems (SaleId, ProductId, Quantity, UnitPrice)
VALUES
(1, 1, 2, 4500),
(1, 4, 1, 1200),
(2, 2, 1, 5200),
(3, 5, 2, 2500),
(4, 6, 3, 800);
GO

CREATE OR ALTER PROCEDURE usp_GetAllProducts
AS
BEGIN
    SELECT
        Products.Id,
        Products.Name AS ProductName,
        ProductTypes.Name AS ProductType,
        Manufacturers.Name AS Manufacturer,
        Products.Price,
        Products.Quantity
    FROM Products
    JOIN ProductTypes ON ProductTypes.Id = Products.ProductTypeId
    JOIN Manufacturers ON Manufacturers.Id = Products.ManufacturerId;
END;
GO

CREATE OR ALTER PROCEDURE usp_GetProductsByType
    @ProductTypeName NVARCHAR(100)
AS
BEGIN
    SELECT
        Products.Id,
        Products.Name AS ProductName,
        ProductTypes.Name AS ProductType,
        Manufacturers.Name AS Manufacturer,
        Products.Price,
        Products.Quantity
    FROM Products
    JOIN ProductTypes ON ProductTypes.Id = Products.ProductTypeId
    JOIN Manufacturers ON Manufacturers.Id = Products.ManufacturerId
    WHERE ProductTypes.Name = @ProductTypeName
      AND Products.Quantity > 0;
END;
GO

CREATE OR ALTER PROCEDURE usp_GetTop3OldestCustomers
AS
BEGIN
    SELECT TOP 3
        Id,
        FullName,
        BirthDate,
        RegistrationDate
    FROM Customers
    ORDER BY RegistrationDate ASC;
END;
GO

CREATE OR ALTER PROCEDURE usp_GetBestSeller
AS
BEGIN
    SELECT TOP 1
        Sellers.Id,
        Sellers.FullName AS SellerName,
        SUM(SaleItems.Quantity * SaleItems.UnitPrice) AS TotalSalesAmount
    FROM Sellers
    JOIN Sales ON Sales.SellerId = Sellers.Id
    JOIN SaleItems ON SaleItems.SaleId = Sales.Id
    GROUP BY Sellers.Id, Sellers.FullName
    ORDER BY TotalSalesAmount DESC;
END;
GO

CREATE OR ALTER PROCEDURE usp_CheckManufacturerAvailability
    @ManufacturerName NVARCHAR(100)
AS
BEGIN
    IF EXISTS
    (
        SELECT 1
        FROM Products
        JOIN Manufacturers ON Manufacturers.Id = Products.ManufacturerId
        WHERE Manufacturers.Name = @ManufacturerName
          AND Products.Quantity > 0
    )
    BEGIN
        SELECT N'yes' AS Result;
    END
    ELSE
    BEGIN
        SELECT N'no' AS Result;
    END
END;
GO

CREATE OR ALTER PROCEDURE usp_GetMostPopularManufacturer
AS
BEGIN
    SELECT TOP 1
        Manufacturers.Id,
        Manufacturers.Name AS ManufacturerName,
        SUM(SaleItems.Quantity * SaleItems.UnitPrice) AS TotalSalesAmount
    FROM Manufacturers
    JOIN Products ON Products.ManufacturerId = Manufacturers.Id
    JOIN SaleItems ON SaleItems.ProductId = Products.Id
    GROUP BY Manufacturers.Id, Manufacturers.Name
    ORDER BY TotalSalesAmount DESC;
END;
GO

CREATE OR ALTER PROCEDURE usp_DeleteCustomersAfterDate
    @Date DATE
AS
BEGIN
    DECLARE @DeletedCustomers TABLE
    (
        Id INT
    );

    INSERT INTO @DeletedCustomers (Id)
    SELECT Id
    FROM Customers
    WHERE RegistrationDate > @Date;

    DECLARE @DeletedCount INT;

    SELECT @DeletedCount = COUNT(*)
    FROM @DeletedCustomers;

    DELETE SaleItems
    FROM SaleItems
    JOIN Sales ON Sales.Id = SaleItems.SaleId
    JOIN @DeletedCustomers DC ON DC.Id = Sales.CustomerId;

    DELETE Sales
    FROM Sales
    JOIN @DeletedCustomers DC ON DC.Id = Sales.CustomerId;

    DELETE Customers
    FROM Customers
    JOIN @DeletedCustomers DC ON DC.Id = Customers.Id;

    SELECT @DeletedCount AS DeletedCustomersCount;
END;
GO

EXEC usp_GetAllProducts;

EXEC usp_GetProductsByType N'Взуття';

EXEC usp_GetTop3OldestCustomers;

EXEC usp_GetBestSeller;

EXEC usp_CheckManufacturerAvailability N'Nike';

EXEC usp_GetMostPopularManufacturer;

EXEC usp_DeleteCustomersAfterDate '2021-01-01';