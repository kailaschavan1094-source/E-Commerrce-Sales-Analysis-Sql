USE ecommerce_project;
-- ==========================================
-- Project : E-Commerce Orders Analysis
-- Step 1 : Create Orders Table
-- ==========================================

CREATE TABLE orders (

    -- Unique Order ID
    OrderID VARCHAR(20) PRIMARY KEY,

    -- Order Date
    Date DATE,

    -- Customer ID
    CustomerID VARCHAR(20),

    -- Product Name
    Product VARCHAR(50),

    -- Quantity Purchased
    Quantity INT,

    -- Price Per Unit
    UnitPrice DECIMAL(10,2),

    -- Shipping Address
    ShippingAddress VARCHAR(255),

    -- Payment Method
    PaymentMethod VARCHAR(50),

    -- Order Status
    OrderStatus VARCHAR(20),

    -- Courier Tracking Number
    TrackingNumber VARCHAR(30),

    -- Number of Items in Cart
    ItemsInCart INT,

    -- Coupon Applied
    CouponCode VARCHAR(20),

    -- Referral Source
    ReferralSource VARCHAR(30),

    -- Total Order Price
    TotalPrice DECIMAL(10,2)

);
-- SHOW TABLES;
-- SELECT*FROM orders;
-- DROP TABLE orders;
-- DROP TABLE IF EXISTS orders;
-- ==========================================
-- Create Orders Table
-- ==========================================

CREATE TABLE orders (
    OrderID VARCHAR(20),
    Date DATE,
    CustomerID VARCHAR(20),
    Product VARCHAR(100),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    ShippingAddress VARCHAR(255),
    PaymentMethod VARCHAR(50),
    OrderStatus VARCHAR(30),
    TrackingNumber VARCHAR(50),
    ItemsInCart INT,
    CouponCode VARCHAR(50),
    ReferralSource VARCHAR(50),
    TotalPrice DECIMAL(10,2)
);
SHOW TABLES;
-- ============================================
-- Step 3: Verify Imported Data
-- ============================================

-- Display all records
-- SELECT *
-- FROM orders;

-- Count total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Display first 10 records
SELECT *
FROM orders
LIMIT 10;

-- ============================================
-- Check for NULL values
-- ============================================

SELECT
    SUM(OrderID IS NULL) AS orderid_null,
    SUM(Date IS NULL) AS date_null,
    SUM(CustomerID IS NULL) AS customerid_null,
    SUM(Product IS NULL) AS product_null,
    SUM(Quantity IS NULL) AS quantity_null,
    SUM(UnitPrice IS NULL) AS unitprice_null,
    SUM(TotalPrice IS NULL) AS totalprice_null
FROM orders;

-- ============================================
-- Analyze Orders by Status
-- ============================================

SELECT
    OrderStatus,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY OrderStatus
ORDER BY Total_Orders DESC;

-- ============================================
-- Analyze Orders by Payment Method
-- ============================================

SELECT
    PaymentMethod,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY PaymentMethod
ORDER BY Total_Orders DESC;

-- ============================================
-- Top 10 Best Selling Products
-- ============================================

SELECT
    Product,
    SUM(Quantity) AS Total_Quantity_Sold
FROM orders
GROUP BY Product
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

-- ============================================
-- Top 10 Customers by Revenue
-- ============================================

SELECT
    CustomerID,
    SUM(TotalPrice) AS Total_Spent
FROM orders
GROUP BY CustomerID
ORDER BY Total_Spent DESC
LIMIT 10;

-- ============================================
-- Monthly Revenue Trend
-- ============================================

SELECT
    MONTH(Date) AS Month_Number,
    SUM(TotalPrice) AS Total_Revenue
FROM orders
GROUP BY MONTH(Date)
ORDER BY Month_Number;

-- ============================================
-- Calculate Total Revenue
-- ============================================

SELECT SUM(TotalPrice) AS Total_Revenue
FROM orders;

-- ============================================
-- Calculate Average Order Value
-- ============================================

SELECT
    ROUND(AVG(TotalPrice),2) AS Average_Order_Value
FROM orders;

-- ============================================
-- Orders with and without Coupon
-- ============================================

SELECT
    CASE
        WHEN CouponCode IS NULL OR CouponCode = '' THEN 'No Coupon'
        ELSE 'Coupon Applied'
    END AS Coupon_Status,
    
    -- ============================================
-- Referral Source Analysis
-- ============================================

SELECT
    ReferralSource,
    COUNT(*) AS Total_Orders,
    SUM(TotalPrice) AS Revenue
FROM orders
GROUP BY ReferralSource
ORDER BY Revenue DESC;
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY Coupon_Status;


-- ============================================
-- Referral Source Analysis
-- ============================================

SELECT
    ReferralSource,
    COUNT(*) AS Total_Orders,
    SUM(TotalPrice) AS Revenue
FROM orders
GROUP BY ReferralSource
ORDER BY Revenue DESC;

-- ============================================
-- Top 10 Highest Value Orders
-- ============================================

SELECT
    OrderID,
    CustomerID,
    Product,
    TotalPrice
FROM orders
ORDER BY TotalPrice DESC
LIMIT 10;

-- ============================================
-- Rank Products by Total Revenue
-- Using Window Function
-- ============================================

SELECT
    Product,
    SUM(TotalPrice) AS Total_Revenue,
    RANK() OVER(ORDER BY SUM(TotalPrice) DESC) AS Product_Rank
FROM orders
GROUP BY Product;

-- ============================================
-- Find Top 5 Customers Using CTE
-- ============================================

WITH CustomerRevenue AS
(
    SELECT
        CustomerID,
        SUM(TotalPrice) AS Revenue
    FROM orders
    GROUP BY CustomerID
)

SELECT *
FROM CustomerRevenue
ORDER BY Revenue DESC
LIMIT 5;

-- ============================================
-- Categorize Orders by Value
-- ============================================

SELECT
    OrderID,
    CustomerID,
    TotalPrice,

    CASE
        WHEN TotalPrice >= 1000 THEN 'High Value'
        WHEN TotalPrice >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Category

FROM orders;

-- ============================================
-- Customers Spending Above Average
-- ============================================

SELECT
    CustomerID,
    SUM(TotalPrice) AS Total_Spent
FROM orders
GROUP BY CustomerID
HAVING SUM(TotalPrice) >
(
    SELECT AVG(TotalPrice)
    FROM orders
)
ORDER BY Total_Spent DESC;

-- ============================================
-- Create Customer Summary View
-- ============================================

CREATE VIEW Customer_Summary AS

SELECT
    CustomerID,
    COUNT(OrderID) AS Total_Orders,
    SUM(TotalPrice) AS Total_Revenue
FROM orders
GROUP BY CustomerID;

SELECT *
FROM Customer_Summary;

-- ============================================
-- Top 5 Shipping Addresses by Revenue
-- ============================================

SELECT
    ShippingAddress,
    SUM(TotalPrice) AS Total_Revenue
FROM orders
GROUP BY ShippingAddress
ORDER BY Total_Revenue DESC
LIMIT 5;

-- ============================================
-- Average Quantity Sold per Product
-- ============================================

SELECT
    Product,
    ROUND(AVG(Quantity),2) AS Average_Quantity
FROM orders
GROUP BY Product
ORDER BY Average_Quantity DESC;

-- ============================================
-- Find Pending Orders
-- ============================================

SELECT *
FROM orders
WHERE OrderStatus = 'Pending';

-- ============================================
-- Delivered Orders Percentage
-- ============================================

SELECT
ROUND(
(
SUM(CASE
WHEN OrderStatus='Delivered' THEN 1
ELSE 0
END)*100.0
)/COUNT(*),2) AS Delivered_Percentage
FROM orders;

-- ============================================
-- Most Popular Payment Method
-- ============================================

SELECT
PaymentMethod,
COUNT(*) AS Total_Orders
FROM orders
GROUP BY PaymentMethod
ORDER BY Total_Orders DESC
LIMIT 1;

-- ============================================
-- Revenue Generated by Each Product
-- ============================================

SELECT
Product,
SUM(TotalPrice) AS Revenue
FROM orders
GROUP BY Product
ORDER BY Revenue DESC;

-- ============================================
-- Customer Purchase Frequency
-- ============================================

SELECT
CustomerID,
COUNT(OrderID) AS Number_of_Orders
FROM orders
GROUP BY CustomerID
ORDER BY Number_of_Orders DESC;

-- ============================================
-- Rank Customers by Total Spending
-- Using DENSE_RANK()
-- ============================================

SELECT
    CustomerID,
    SUM(TotalPrice) AS Total_Spent,
    DENSE_RANK() OVER (
        ORDER BY SUM(TotalPrice) DESC
    ) AS Customer_Rank
FROM orders
GROUP BY CustomerID;

-- ============================================
-- Find Latest Order of Each Customer
-- Using ROW_NUMBER()
-- ============================================

SELECT *
FROM
(
    SELECT
        OrderID,
        CustomerID,
        Date,
        TotalPrice,
        ROW_NUMBER() OVER(
            PARTITION BY CustomerID
            ORDER BY Date DESC
        ) AS Row_Num
    FROM orders
) AS Latest_Order
WHERE Row_Num = 1;

-- ============================================
-- Products Generating Above Average Revenue
-- ============================================

SELECT
    Product,
    SUM(TotalPrice) AS Revenue
FROM orders
GROUP BY Product
HAVING SUM(TotalPrice) >
(
    SELECT AVG(TotalPrice)
    FROM orders
)
ORDER BY Revenue DESC;

-- ============================================
-- Running Total Revenue
-- ============================================

SELECT
    Date,
    SUM(TotalPrice) AS Daily_Revenue,
    SUM(SUM(TotalPrice))
    OVER(
        ORDER BY Date
    ) AS Running_Revenue
FROM orders
GROUP BY Date
ORDER BY Date;

-- ============================================
-- Revenue Contribution by Product
-- ============================================

SELECT
    Product,
    SUM(TotalPrice) AS Revenue,

    ROUND(
        SUM(TotalPrice) * 100 /
        (SELECT SUM(TotalPrice) FROM orders),
        2
    ) AS Revenue_Percentage

FROM orders
GROUP BY Product
ORDER BY Revenue DESC;