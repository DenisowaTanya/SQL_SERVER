/*1. �������� ����������� (Application.People), ������� �������� ������������ (IsSalesPerson), 
� �� ������� �� ����� ������� 04 ���� 2015 ����. 
������� �� ���������� � ��� ������ ���. ������� �������� � ������� Sales.Invoices.*/
USE [WideWorldImporters]
--���
;WITH Invoice_CTE ([SalespersonPersonID])
AS (SELECT [SalespersonPersonID]
            FROM [Sales].[Invoices]
			Where  [InvoiceDate]='2015-07-04')
SELECT [PersonID],
	   [FullName]
FROM [Application].[People] t1 
LEFT JOIN Invoice_CTE t2 on t1.PersonID=t2.SalespersonPersonID
WHERE [IsSalesperson]=1 and t2.SalespersonPersonID is null

--���������
SELECT [PersonID],
	   [FullName]
FROM [Application].[People] t1
LEFT JOIN  (SELECT [SalespersonPersonID]
            FROM [Sales].[Invoices]
			Where  [InvoiceDate]='2015-07-04')t2 on t1.PersonID=t2.SalespersonPersonID
WHERE [IsSalesperson]=1 and t2.SalespersonPersonID is null

/*2. �������� ������ � ����������� ����� (�����������). 
�������� ��� �������� ����������. �������: �� ������, ������������ ������, ����.*/

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

--���������1
SElECT [StockItemID],
       [StockItemName],
       [UnitPrice]
FROM [Warehouse].[StockItems] 
WHERE [UnitPrice]= (SELECT MIN([UnitPrice])
					FROM [Warehouse].[StockItems] )

--���������2
SElECT [StockItemID],
       [StockItemName],
       [UnitPrice]
FROM [Warehouse].[StockItems] 
WHERE [UnitPrice]= (SELECT top 1 [UnitPrice]
					FROM [Warehouse].[StockItems]
					ORDER BY [UnitPrice])

/*3.�������� ���������� �� ��������, ������� �������� �������� ���� ������������ �������� �� Sales.CustomerTransactions. 
����������� ��������� �������� (� ��� ����� � CTE).*/

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

/*4. �������� ������ (�� � ��������), � ������� ���� ���������� ������, �������� � ������ ����� ������� �������, 
� ����� ��� ����������, ������� ����������� �������� ������� (PackedByPersonID).*/

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

/*�����������
���������, ��� ������ � ������������� ������:
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
����� ��������� ��� � ������� ��������� ������������� �������, ��� � � ������� ��������� �����\���������. 
�������� ������������������ �������� ����� ����� SET STATISTICS IO, TIME ON. 
���� ������� � ������� ��������, �� ����������� �� (����� � ������� ����� ��������� �����). 
�������� ���� ����������� �� ������ �����������.*/

--SET STATISTICS IO, TIME ON;
--SET STATISTICS PROFILE ON
--SET STATISTICS XML ON;

SELECT
Invoices.InvoiceID, --ID �������
Invoices.InvoiceDate,--���� �������
   (SELECT People.FullName
    FROM Application.People
    WHERE People.PersonID = Invoices.SalespersonPersonID
    ) AS SalesPersonName,--�������, ���������� �������
SalesTotals.TotalSumm AS TotalSummByInvoice,
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) --����� ��� ������ � �������� �������, �������� ��������� ���������� ������ �� ����
       FROM Sales.OrderLines
 WHERE OrderLines.OrderId = (SELECT Orders.OrderId
                             FROM Sales.Orders
                             WHERE Orders.PickingCompletedWhen IS NOT NULL-- ������ �� ��� �������, ��� ������ ������ ���������
                             AND Orders.OrderId = Invoices.OrderId)--������ �� ��� �������, �� ��������� ������� ����������� ����
) AS TotalSummForPickedItems --����� �� ���������� �������
FROM Sales.Invoices --�� ������� ������
JOIN-- ��������� � �������� ID ������� � ����� �������
  (SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm-- ����� �������� ������ ����� ��� �� ������������ ������ (�� ��������) ��� ������
    FROM Sales.InvoiceLines
     GROUP BY InvoiceId --����������  ��� �� ID ������� (�����)
     HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals --����� ������ ����� ����� �� �������� ����� 27000 
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC-- ��������� �� �������� ��� ����� ������


/*������ ��������� ������ ������ (ID ������� � ����), ����� ������ ����� ������ (��� ������)
� ����� ������ �� ��������� �������. ������� ��������� ������ ��, � ������� ������ ����� ������ 27000.
����� ��������� ������ ��� ��������, �������������� �������*/


--������������ ������:
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

/* ������ ������, �� ��� ������ �������� ����� �������,
� ��� ����������� 8 �����. ��� ����������� � ���������� ��������.
�� ����� ������ ������ ������ ������� 48%, � � ������  - 52%.
�� ������������ ������� �� ����� ������
������������ : SET STATISTICS IO, TIME ON
�� ������ ������:  
����� ������ SQL Server:
����� �� = 219 ��, ����������� ����� = 211 ��.
����� ��������������� ������� � ���������� SQL Server: 
����� �� = 0 ��, �������� ����� = 0 ��.

�� ������ ������: 
����� ������ SQL Server:
����� �� = 250 ��, ����������� ����� = 316 ��.
����� ��������������� ������� � ���������� SQL Server: 
����� �� = 0 ��, �������� ����� = 0 ��.

������ ������ ���������� ����������� ������ ������� �� ���������.*/



