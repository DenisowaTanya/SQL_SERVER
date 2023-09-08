USE [WideWorldImporters]

--Исходный запрос

set statistics time on;
SET STATISTICS IO ON;

Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID) --можно дать имена (для удобства)
FROM Sales.Orders AS ord
JOIN Sales.OrderLines AS det
ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv
ON Inv.OrderID = ord.OrderID
JOIN Sales.CustomerTransactions AS Trans
ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItemTransactions AS ItemTrans
ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
AND (Select SupplierId --можно соединить в основном запросе join
FROM Warehouse.StockItems AS It
Where It.StockItemID = det.StockItemID) = 12
AND (SELECT SUM(Total.UnitPrice*Total.Quantity)--можно вынести в сте
FROM Sales.OrderLines AS Total
Join Sales.Orders AS ordTotal
On ordTotal.OrderID = Total.OrderID
WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0--можно убрать формулу, и приравнять
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID



----ДАНННЫЕ ИСХОДНОГО ЗАПРОСА

--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 203 мс, истекшее время = 282 мс.

--(затронуто строк: 3619)
--Таблица "StockItemTransactions". Сканирований 1, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 66, физических операций чтения LOB 1, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 130, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItemTransactions". Считано сегментов 1, пропущено 0.
--Таблица "OrderLines". Сканирований 4, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 518, физических операций чтения LOB 5, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 795, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "OrderLines". Считано сегментов 2, пропущено 0.
--Таблица "Worktable". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "CustomerTransactions". Сканирований 5, логических операций чтения 261, физических операций чтения 4, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 253, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Orders". Сканирований 2, логических операций чтения 883, физических операций чтения 4, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 877, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Invoices". Сканирований 1, логических операций чтения 72992, физических операций чтения 2, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 8481, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItems". Сканирований 1, логических операций чтения 2, физических операций чтения 1, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.

--(затронуто строк: 33)

--(затронута одна строка)

-- Время работы SQL Server:
--   Время ЦП = 1375 мс, затраченное время = 2790 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.


DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS


WITH Filter_CTE AS
		(
		SELECT ordTotal.CustomerID 
		FROM Sales.OrderLines AS Total
		JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		GROUP BY ordTotal.CustomerID
		HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000
		)
SELECT ord.CustomerID, --ID покупателя
	   det.StockItemID, --ID товара
	   SUM(det.UnitPrice) AS UnitPrice, --сумма цен по заказам
	   SUM(det.Quantity) AS Quantity, --сумма количества по заказам
	   COUNT(ord.OrderID) AS CountOrderID -- количество заказов
FROM Sales.Orders AS ord -- таблица заказов
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID AND Inv.InvoiceDate= ord.OrderDate
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItems AS It on It.StockItemID = det.StockItemID
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = It.StockItemID
JOIN Filter_CTE AS F_CTE ON F_CTE.CustomerID = Inv.CustomerID
WHERE Inv.BillToCustomerID != ord.CustomerID
      AND It.SupplierId = 12
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID 




--ДАННЫЕ ИСПРАВЛЕННОГО ЗАПРОСА (ВАРИАНТ1)


--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 187 мс, истекшее время = 218 мс.

--(затронуто строк: 3619)
--Таблица "StockItemTransactions". Сканирований 1, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 66, физических операций чтения LOB 1, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 130, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItemTransactions". Считано сегментов 1, пропущено 0.
--Таблица "OrderLines". Сканирований 4, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 518, физических операций чтения LOB 5, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 795, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "OrderLines". Считано сегментов 2, пропущено 0.
--Таблица "Worktable". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "CustomerTransactions". Сканирований 5, логических операций чтения 261, физических операций чтения 4, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 253, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Orders". Сканирований 1, логических операций чтения 47088, физических операций чтения 21, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 860, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Invoices". Сканирований 1, логических операций чтения 73150, физических операций чтения 2, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 8481, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItems". Сканирований 1, логических операций чтения 2, физических операций чтения 1, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.

--(затронуто строк: 30)

--(затронута одна строка)

-- Время работы SQL Server:
--   Время ЦП = 1579 мс, затраченное время = 2124 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

--Затраченое время меньше, вермя ЦП больше, логических чтений в таблице Orders в 53 раза больше
--Попробуем это устранить, вернем DATEDIFF

--(ВАРИАНТ2)


DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS


WITH Filter_CTE AS
		(
		SELECT ordTotal.CustomerID 
		FROM Sales.OrderLines AS Total
		JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		GROUP BY ordTotal.CustomerID
		HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000
		)
SELECT ord.CustomerID, --ID покупателя
	   det.StockItemID, --ID товара
	   SUM(det.UnitPrice) AS UnitPrice, --сумма цен по заказам
	   SUM(det.Quantity) AS Quantity, --сумма количества по заказам
	   COUNT(ord.OrderID) AS CountOrderID -- количество заказов
FROM Sales.Orders AS ord -- таблица заказов
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID AND Inv.InvoiceDate= ord.OrderDate
JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
JOIN Warehouse.StockItems AS It on It.StockItemID = det.StockItemID
JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = It.StockItemID
JOIN Filter_CTE AS F_CTE ON F_CTE.CustomerID = Inv.CustomerID
WHERE Inv.BillToCustomerID != ord.CustomerID
      AND It.SupplierId = 12
	  AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID 


--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 218 мс, истекшее время = 254 мс.

--(затронуто строк: 3619)
--Таблица "StockItemTransactions". Сканирований 1, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 66, физических операций чтения LOB 1, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 130, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItemTransactions". Считано сегментов 1, пропущено 0.
--Таблица "OrderLines". Сканирований 4, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 518, физических операций чтения LOB 5, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 795, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "OrderLines". Считано сегментов 2, пропущено 0.
--Таблица "Worktable". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "CustomerTransactions". Сканирований 5, логических операций чтения 261, физических операций чтения 4, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 253, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Orders". Сканирований 2, логических операций чтения 883, физических операций чтения 4, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 877, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Invoices". Сканирований 1, логических операций чтения 73180, физических операций чтения 2, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 8481, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItems". Сканирований 1, логических операций чтения 2, физических операций чтения 1, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.

--(затронуто строк: 33)

--(затронута одна строка)

-- Время работы SQL Server:
--   Время ЦП = 1391 мс, затраченное время = 2247 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

--получилось практически также, как в исходном запросе, попробуем другие варианты


--(ВАРИАНТ3)
--попробуем  внести в соединение данные из условий

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

WITH Filter_CTE AS
		(
		SELECT ordTotal.CustomerID 
		FROM Sales.OrderLines AS Total 
		JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		GROUP BY ordTotal.CustomerID
		HAVING SUM(Total.UnitPrice*Total.Quantity) > 250000
		)
SELECT ord.CustomerID, --ID покупателя
	   det.StockItemID, --ID товара
	   SUM(det.UnitPrice) AS UnitPrice, --сумма цен по заказам
	   SUM(det.Quantity) AS Quantity, --сумма количества по заказам
	   COUNT(ord.OrderID) AS CountOrderID -- количество заказов
FROM Sales.Orders AS ord -- таблица заказов
JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID AND Inv.BillToCustomerID != ord.CustomerID and Inv.InvoiceDate=ord.OrderDate
JOIN Sales.CustomerTransactions AS Trans   ON Trans.InvoiceID = Inv.InvoiceID 
JOIN Warehouse.StockItems AS It on It.StockItemID = det.StockItemID
JOIN Warehouse.StockItemTransactions AS ItemTrans  ON ItemTrans.StockItemID = It.StockItemID
JOIN Filter_CTE AS F_CTE ON F_CTE.CustomerID = Inv.CustomerID
WHERE It.SupplierId = 12	  
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID 


--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 141 мс, истекшее время = 209 мс.

--(затронуто строк: 3619)
--Таблица "StockItemTransactions". Сканирований 1, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 66, физических операций чтения LOB 1, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 130, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItemTransactions". Считано сегментов 1, пропущено 0.
--Таблица "OrderLines". Сканирований 4, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 518, физических операций чтения LOB 5, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 795, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "OrderLines". Считано сегментов 2, пропущено 0.
--Таблица "Worktable". Сканирований 0, логических операций чтения 0, физических операций чтения 0, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "CustomerTransactions". Сканирований 5, логических операций чтения 261, физических операций чтения 4, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 253, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Orders". Сканирований 1, логических операций чтения 47131, физических операций чтения 32, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 849, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "Invoices". Сканирований 1, логических операций чтения 72919, физических операций чтения 2, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 8481, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.
--Таблица "StockItems". Сканирований 1, логических операций чтения 2, физических операций чтения 1, операций чтения страничного сервера 0, операций чтения, выполненных с упреждением 0, операций чтения страничного сервера, выполненных с упреждением 0, логических операций чтения LOB 0, физических операций чтения LOB 0, операций чтения LOB страничного сервера 0, операций чтения LOB, выполненных с упреждением 0, операций чтения LOB страничного сервера, выполненных с упреждением 0.

--(затронуто строк: 30)

--(затронута одна строка)

-- Время работы SQL Server:
--   Время ЦП = 1703 мс, затраченное время = 3748 мс.
--Время синтаксического анализа и компиляции SQL Server: 
-- время ЦП = 0 мс, истекшее время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.

-- Время работы SQL Server:
--   Время ЦП = 0 мс, затраченное время = 0 мс.


--Затраченное вреvя возросло

--ДЕЙСТВИЯ НЕ ДАЛИ РЕЗУЛЬТАТОВ, оптимизатор отлично справился с первым запрососм

--Использовала различные хинты для соединений, но улучшения не увидела
--При принудительном соединении 2х больших таблиц через INNER Hash, увеличилось резко время
--Пробовала использовать не колоночные индексы - улучшений не было, force order, maxdop1 - тоже не улучшили ситуацию
