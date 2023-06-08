/*2. Выберите товары с минимальной ценой 

--CTE
;WITH StockItems_CTE ([UnitPrice],[StockItemID],[StockItemName])
 AS
(SELECT top(1) with ties 
            [UnitPrice],
            [StockItemID],
            [StockItemName]
FROM [Warehouse].[StockItems]
ORDER BY [UnitPrice])
SElECT  [StockItemID],
        [StockItemName],
        [UnitPrice]
FROM StockItems_CTE 
ORDER BY  [UnitPrice]

--либо так:

;WITH StockItems_CTE ([UnitPrice])
AS 
(SELECT min([UnitPrice])
FROM [Warehouse].[StockItems])
SELECT [StockItemID],
       [StockItemName],
       t1.[UnitPrice]
FROM [Warehouse].[StockItems] t1
JOIN StockItems_CTE t2 on t1.UnitPrice=t2.UnitPrice

