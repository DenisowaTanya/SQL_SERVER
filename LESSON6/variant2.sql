/*1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом*/

USE WideWorldImporters
set statistics time, io on

;WITH SumMonth_CTE ([Year],[MonthNum],[SumMonth])
AS 
(SELECT YEAR(InvoiceDate) as  [Year], 
       MONTH (InvoiceDate) as [Month],
       SUM(TransactionAmount) as [SumMonth]
FROM [Sales].[CustomerTransactions] t1
JOIN [Sales].[Invoices] t2 on t1.InvoiceID=t2.InvoiceID
Where TransactionDate>='2015-01-01'
GROUP BY YEAR(InvoiceDate), MONTH (InvoiceDate))
SELECT T2.InvoiceID, T2.InvoiceDate,T4.CustomerName, SUM(T3.TransactionAmount) as SumInvoice
	,(SELECT SUM([SumMonth])
	  FROM SumMonth_CTE 
	  Where [Year]*100+[MonthNum] <=T1.[Year]*100 + T1.MonthNum) AS [Total]
FROM SumMonth_CTE as T1 
JOIN [Sales].[Invoices] as T2 on T1.MonthNum=month(T2.InvoiceDate) and
								 T1.Year=Year(t2.InvoiceDate)
JOIN [Sales].[CustomerTransactions] T3 on T2.InvoiceID=T3.InvoiceID
JOIN [Sales].[Customers] T4 on T2.CustomerID=T4.CustomerID
Group By [Year],[MonthNum],[SumMonth],T2.InvoiceID, T2.InvoiceDate, T4.CustomerName 
ORDER BY T2.InvoiceID

--Время работы SQL Server:
--Время ЦП = 3406 мс, затраченное время = 4093 мс.


Select distinct inv.InvoiceID, cas.CustomerName, inv.InvoiceDate, tr.TransactionAmount, win.Total
FROM (SELECT YEAR(InvoiceDate) as  [Year], 
             MONTH (InvoiceDate) as [Month],
             SUM(TransactionAmount) as [SumMonth],
             SUM(SUM (TransactionAmount)) OVER (ORDER BY  YEAR(InvoiceDate), MONTH (InvoiceDate) ) as [Total]
			 FROM [Sales].[CustomerTransactions] t1
			 JOIN [Sales].[Invoices] t2 on t1.InvoiceID=t2.InvoiceID
			 Where TransactionDate>='2015-01-01'
			 GROUP BY YEAR(InvoiceDate), MONTH (InvoiceDate), InvoiceDate ) AS WIN
JOIN [Sales].[Invoices] inv on MONTH(inv.InvoiceDate)=win.[Month] and  Year(inv.InvoiceDate)=win.[Year]
JOIn [Sales].[Customers] cas on inv.CustomerID=cas.CustomerID
JOIN [Sales].[CustomerTransactions] tr on inv.InvoiceID=tr.InvoiceID
Order by inv.InvoiceID

--Время работы SQL Server:
--Время ЦП = 1454 мс, затраченное время = 2377 мс.
