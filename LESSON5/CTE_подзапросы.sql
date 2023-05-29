/*1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. Продажи смотреть в таблице Sales.Invoices.*/
USE [WideWorldImporters]
--сте
;WITH Invoice_CTE ([SalespersonPersonID])
AS (SELECT [SalespersonPersonID]
            FROM [Sales].[Invoices]
			Where  [InvoiceDate]='2015-07-04')
SELECT [PersonID],
	   [FullName]
FROM [Application].[People] t1 
LEFT JOIN Invoice_CTE t2 on t1.PersonID=t2.SalespersonPersonID
WHERE [IsSalesperson]=1 and t2.SalespersonPersonID is null

--подзапрос
SELECT [PersonID],
	   [FullName]
FROM [Application].[People] t1
LEFT JOIN  (SELECT [SalespersonPersonID]
            FROM [Sales].[Invoices]
			Where  [InvoiceDate]='2015-07-04')t2 on t1.PersonID=t2.SalespersonPersonID
WHERE [IsSalesperson]=1 and t2.SalespersonPersonID is null

/*2. Выберите товары с минимальной ценой (подзапросом). 
Сделайте два варианта подзапроса. Вывести: ИД товара, наименование товара, цена.*/

--CTE
;WITH StockItems_CTE ([UnitPrice],[StockItemID],[StockItemName])
 AS
(SELECT MIN([UnitPrice]),
         [StockItemID],
         [StockItemName]
 FROM [Warehouse].[StockItems]
 GROUP BY [StockItemID],[StockItemName] )
SElECT top 1 [StockItemID],
             [StockItemName],
             [UnitPrice]
FROM StockItems_CTE 
ORDER BY  [UnitPrice]

--Подзапрос1
SElECT [StockItemID],
       [StockItemName],
       [UnitPrice]
FROM [Warehouse].[StockItems] 
WHERE [UnitPrice]= (SELECT MIN([UnitPrice])
					FROM [Warehouse].[StockItems] )

--Подзапрос2
SElECT [StockItemID],
       [StockItemName],
       [UnitPrice]
FROM [Warehouse].[StockItems] 
WHERE [UnitPrice]= (SELECT top 1 [UnitPrice]
					FROM [Warehouse].[StockItems]
					ORDER BY [UnitPrice])

/*3.Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE).*/

With MaxPay_CTE ([CustomerID],[TransactionAmount])
AS (SELECT TOP 5 [CustomerID],[TransactionAmount]
	FROM [Sales].[CustomerTransactions]
	ORDER BY [TransactionAmount] DESC)
SELECT t1.[CustomerID],
       [CustomerName],
	   t2.TransactionAmount
FROM [Sales].[Customers] t1
JOIN MaxPay_CTE t2 on t1.CustomerID=t2.CustomerID

SELECT t1.[CustomerID],
       [CustomerName],
	   t2.TransactionAmount
FROM [Sales].[Customers] t1
JOIN (SELECT TOP 5 [CustomerID],[TransactionAmount]
	FROM [Sales].[CustomerTransactions]
	ORDER BY [TransactionAmount] DESC)  t2 on t1.CustomerID=t2.CustomerID

SElECT TOP 5
       t1.[CustomerID],
       [CustomerName],
	   t2.TransactionAmount
FROM [Sales].[Customers] t1
JOIN [Sales].[CustomerTransactions] t2 on t1.CustomerID=t2.CustomerID
ORDER BY t2.TransactionAmount DESC

/*4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, 
а также имя сотрудника, который осуществлял упаковку заказов (PackedByPersonID).*/

WITH Expen_CTE ([StockItemID],[StockItemName])
AS 
(SELECT TOP 3 [StockItemID],[StockItemName]
 FROM[Warehouse].[StockItems]
 ORDER BY [UnitPrice] DESC)
SELECT DISTINCT t1.[CityID],[CityName],t6.FullName
FROM [Application].[Cities] t1
JOIN [Sales].[Customers] t2 on t1.CityID=t2.DeliveryCityID
JOIN [Sales].[Invoices] t3 on t2.CustomerID=t3.CustomerID
JOIN [Sales].[InvoiceLines] t4 on t4.InvoiceID=t3.InvoiceID
JOIN Expen_CTE t5 on t4.StockItemID=t5.StockItemID
JOIN [Application].[People] t6 on t3.PackedByPersonID=t6.PersonID


SELECT DISTINCT t1.[CityID],[CityName],t6.FullName
FROM [Application].[Cities] t1
JOIN [Sales].[Customers] t2 on t1.CityID=t2.DeliveryCityID
JOIN [Sales].[Invoices] t3 on t2.CustomerID=t3.CustomerID
JOIN [Sales].[InvoiceLines] t4 on t4.InvoiceID=t3.InvoiceID
JOIN (SELECT TOP 3 [StockItemID],[StockItemName]
      FROM[Warehouse].[StockItems]
      ORDER BY [UnitPrice] DESC) t5 on t4.StockItemID=t5.StockItemID
JOIN [Application].[People] t6 on t3.PackedByPersonID=t6.PersonID

/*ОПЦИОНАЛЬНО
Объясните, что делает и оптимизируйте запрос:
SELECT
Invoices.InvoiceID,
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice,
(SELECT SUM(OrderLines.PickedQuantityOrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL
AND Orders.OrderId = Invoices.OrderId)
) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN
(SELECT InvoiceId, SUM(QuantityUnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC
Можно двигаться как в сторону улучшения читабельности запроса, так и в сторону упрощения плана\ускорения. 
Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
Напишите ваши рассуждения по поводу оптимизации.*/

SET STATISTICS IO, TIME ON;
--SET STATISTICS PROFILE ON
--SET STATISTICS XML ON;

SELECT
Invoices.InvoiceID, --ID продажи
Invoices.InvoiceDate,--Дата продажи
   (SELECT People.FullName
    FROM Application.People
    WHERE People.PersonID = Invoices.SalespersonPersonID
    ) AS SalesPersonName,--человек, оформивший продажу
SalesTotals.TotalSumm AS TotalSummByInvoice,
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) --здесь уже работа с таблицей заказов, умножаем выбранное количество товара на цену
       FROM Sales.OrderLines
 WHERE OrderLines.OrderId = (SELECT Orders.OrderId
                             FROM Sales.Orders
                             WHERE Orders.PickingCompletedWhen IS NOT NULL-- только по тем заказам, где сборка заказа завершена
                             AND Orders.OrderId = Invoices.OrderId)--только по тем заказам, на основании которых сформирован счет
) AS TotalSummForPickedItems --сумма по выбрананым товарам
FROM Sales.Invoices --из таблицы продаж
JOIN-- соединяем с таблицей ID продажи и сумма продажи
  (SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm-- здесь выбираем полную сумму уже по выставленным счетам (по продажам) без налога
    FROM Sales.InvoiceLines
     GROUP BY InvoiceId --группируем  все по ID продажи (счета)
     HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals --берем только общую сумму по продажам более 27000 
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC-- сортируем по убыванию обе суммы продаж


/*Запрос формирует список продаж (ID продажи и дата), также полную сумму продаж (без налога)
и сумме продаж по выбранным товарам. ПРодажи выводятся только те, в которых полная сумма больше 27000.
Также выводится полное имя человека, осуществившего продажу*/


--Исправленный запрос:
;WITH my_cte (InvoiceID,InvoiceDate, OrderID, SalespersonPersonID,TotalSummByInvoice)
AS 
(SELECT t1.InvoiceID,
        t1.InvoiceDate,
		t1.OrderID,
		t1.SalespersonPersonID,
       SUM(t2.Quantity*t2.UnitPrice) as TotalSummByInvoice
FROM [Sales].[Invoices] t1
JOIN [Sales].[InvoiceLines] t2 on t1.InvoiceID=t2.InvoiceID
GROUP by t1.InvoiceID,t1.InvoiceDate,t1.OrderID,t1.SalespersonPersonID
HAVING SUM(t2.Quantity*t2.UnitPrice)>27000)
SELECT  t1.InvoiceID,
	    t1.InvoiceDate,
		t5.FullName,
		t1.TotalSummByInvoice,
		SUM (t4.PickedQuantity*t4.UnitPrice) as TotalSummForPickedItems
FROM my_cte t1
JOIN [Sales].[Orders] t3 on t1.OrderID=t3.OrderID
JOIN [Sales].[OrderLines] t4 on t3.OrderID=t4.OrderID
JOIN [Application].[People] t5 on t1.SalespersonPersonID=t5.PersonID
GROUP BY t1.InvoiceID,
	    t1.InvoiceDate,
		t5.FullName,
		t1.TotalSummByInvoice
ORDER BY t1.TotalSummByInvoice desc
--OPTION (MAXDOP 1)

/* Второй запрос, на мой взгляд выглядит лучше первого,
В сте вычисляется 8 строк. Они соединяются с остальными строками.
По плану второй запрос слегка получше 48%, а в первом  - 52%.
ПО затреченному времени не очень поняла
Использовала : SET STATISTICS IO, TIME ON
На первый запрос:  
Время работы SQL Server:
Время ЦП = 219 мс, затраченное время = 211 мс.
Время синтаксического анализа и компиляции SQL Server: 
время ЦП = 0 мс, истекшее время = 0 мс.

На второй запрос: 
Время работы SQL Server:
Время ЦП = 250 мс, затраченное время = 316 мс.
Время синтаксического анализа и компиляции SQL Server: 
время ЦП = 0 мс, истекшее время = 0 мс.

Второй запрос получается задействует больше времени на обработку.*/

