--Переписала 1 запрос через оператор CASE

USE WideWorldImporters

SELECT distinct t2.[OrderID],
FORMAT(OrderDate,'dd.MM.yyyy') as [FormatOrderDate],
DATENAME(month,OrderDate) as [MonthName],
DATEPART(quarter,OrderDate) as [Quarter],
CASE WHEN month(OrderDate)<=4 THEN 1
	WHEN month(OrderDate) between 5 and 8 THEN 2
	WHEN month(OrderDate)>=9 THEN 3
END as [Part],
t5.CustomerName
FROM [Sales].[OrderLines] t2
JOIN [Warehouse].[StockItems] t3 on t2.StockItemID=t3.StockItemID
JOIN [Sales].[Orders] t4 on t2.OrderID=t4.OrderID
JOIN [Sales].[Customers] t5 on t4.CustomerID=t5.CustomerID
Where t2.[PickingCompletedWhen] is not null and (t3.UnitPrice>100 or [Quantity]>20)
ORDER by [Quarter],[Part],[FormatOrderDate]
OFFSET 1000 row
Fetch First 100 Rows Only
