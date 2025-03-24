-- 1. Monthly Sales

SELECT 
    YEAR(OrderDate) AS Year, 
    MONTH(OrderDate) AS Month, 
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

 /* This query retrieves that the Sales peaked at $123,799 in April 1998 and dropped sharply to $18,334 by May 1998. 
 The overall sales trend shows Periodic fluctuations, significant growth, and a steep final decline.*/


-- 2. Top Selling Products in Each Month 

WITH MonthlySales AS (
    SELECT 
        YEAR(o.OrderDate) AS Year,
        MONTH(o.OrderDate) AS Month,
        p.ProductName,
        SUM(od.Quantity) AS TotalQuantitySold,
        RANK() OVER (PARTITION BY YEAR(o.OrderDate), MONTH(o.OrderDate) ORDER BY SUM(od.Quantity) DESC) AS Rank
    FROM Orders o
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), p.ProductName
)
SELECT Year, Month, ProductName, TotalQuantitySold
FROM MonthlySales
WHERE Rank = 1;

/* The Product Named 'Chang' is identified as the top selling product in the year 1996 with 105 Quantity sold.*/


-- 3. Monthly Sales Comparison by Product Category
SELECT 
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), c.CategoryName
ORDER BY Year, Month, TotalSales DESC;

/*The output displays the total sales for each category by year and month, sorted in descending order by total sales*/


-- 4. Monthly Customer Order Analysis

SELECT 
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS NumberOfOrders
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY YEAR(OrderDate), MONTH(OrderDate), c.CustomerID, c.CompanyName
ORDER BY Year, Month, NumberOfOrders DESC;

/* The output showcases the number of orders placed by each customer per month. 
Upon further data visualization we can find that most number of orders were placed in the year 1997 with over 400+ orders. */

