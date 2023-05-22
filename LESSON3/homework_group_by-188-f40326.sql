/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT Year(t3.InvoiceDate) as [Год],
	  month(t3.InvoiceDate) as [Месяц],
      avg(t1.[UnitPrice]) as [Средняя цена],
      sum(t1.[ExtendedPrice]) as [Сумма за месяц]
FROM [WideWorldImporters].[Sales].[InvoiceLines] t1
JOIN [WideWorldImporters].[Warehouse].[StockItems] t2 on t1.StockItemID=t2.StockItemID
JOIN [WideWorldImporters].[Sales].[Invoices] t3 on t1.InvoiceID=t3.InvoiceID
Group by   Year(t3.InvoiceDate),
	       month(t3.InvoiceDate)
Order by [Год], [Месяц]

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

Select Year(t3.InvoiceDate) as [Год],
	   month(t3.InvoiceDate) as [Месяц],
	   SUM(t1.[ExtendedPrice]) as [Сумма за месяц]
FROM [WideWorldImporters].[Sales].[InvoiceLines] t1
JOIN [WideWorldImporters].[Sales].[Invoices] t3 on t1.InvoiceID=t3.InvoiceID
Group by Year(t3.InvoiceDate),
	     month(t3.InvoiceDate)
Having SUM(t1.[ExtendedPrice])>4600000
Order by [Год],[Месяц]

/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT Year(t3.InvoiceDate) as [Год],
	   month(t3.InvoiceDate) as [Месяц],
	   t2.StockItemName as [Наименование товара],
	   min(t3.InvoiceDate) as [Первая дата продажи],
	   sum(t1.Quantity) as [Количество за месяц],
       sum(t1.[ExtendedPrice]) as [Сумма за месяц]
FROM [WideWorldImporters].[Sales].[InvoiceLines] t1
JOIN [WideWorldImporters].[Warehouse].[StockItems] t2 on t1.StockItemID=t2.StockItemID
JOIN [WideWorldImporters].[Sales].[Invoices] t3 on t1.InvoiceID=t3.InvoiceID
Group by   Year(t3.InvoiceDate),
	       month(t3.InvoiceDate),
		   t2.StockItemName
Having sum(t1.Quantity)<50
Order by  [Год], [Месяц], t2.StockItemName

-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
Select Year(t3.InvoiceDate) as [Год],
	   month(t3.InvoiceDate) as [Месяц],
	   IIF(SUM(t1.[ExtendedPrice])>4600000, SUM(t1.[ExtendedPrice]), 0) as [Сумма за месяц]
FROM [WideWorldImporters].[Sales].[InvoiceLines] t1
JOIN [WideWorldImporters].[Sales].[Invoices] t3 on t1.InvoiceID=t3.InvoiceID
Group by Year(t3.InvoiceDate),
	     month(t3.InvoiceDate)
Order by [Год],[Месяц]

SELECT Year(t3.InvoiceDate) as [Год],
	   month(t3.InvoiceDate) as [Месяц],
	   t2.StockItemName as   [Наименование товара],
	   IIF (sum(t1.Quantity)<50, min(t3.InvoiceDate),null) as [Первая дата продажи],
	   IIF(sum(t1.Quantity)<50,sum(t1.Quantity),0) as [Количество за месяц],
       IIF (sum(t1.Quantity)<50,sum(t1.[ExtendedPrice]),0) as [Сумма за месяц]
FROM [WideWorldImporters].[Sales].[InvoiceLines] t1
JOIN [WideWorldImporters].[Warehouse].[StockItems] t2 on t1.StockItemID=t2.StockItemID
JOIN [WideWorldImporters].[Sales].[Invoices] t3 on t1.InvoiceID=t3.InvoiceID
Group by t2.StockItemID,
       	   t2.StockItemName,
	       Year(t3.InvoiceDate),
	       month(t3.InvoiceDate)
Order by [Год], [Месяц], t2.StockItemName