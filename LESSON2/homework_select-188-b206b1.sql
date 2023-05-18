/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, JOIN".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД WideWorldImporters можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

SELECT [StockItemName]
FROM [Warehouse].[StockItems]
WHERE [StockItemName] like'%urgent%' or [StockItemName] like 'Animal%'

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

SELECT t1.SupplierID,
	   [SupplierName]
FROM [Purchasing].[Suppliers] t1
LEFT JOIN [Purchasing].[PurchaseOrders] t2 on t1.SupplierID=t2.SupplierID
WHERE t2.SupplierID is null

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

SELECT distinct t2.[OrderID],
FORMAT(OrderDate,'dd.MM.yyyy') as [FormatOrderDate],
DATENAME(month,OrderDate) as [MonthName],
DATEPART(quarter,OrderDate) as [Quarter],
IIF(month(OrderDate)<=4,1,IIF(month(OrderDate)<=8,2,3)) as [Part],
t5.CustomerName
FROM [Sales].[OrderLines] t2
JOIN [Warehouse].[StockItems] t3 on t2.StockItemID=t3.StockItemID
JOIN [Sales].[Orders] t4 on t2.OrderID=t4.OrderID
JOIN [Sales].[Customers] t5 on t4.CustomerID=t5.CustomerID
Where t2.[PickingCompletedWhen] is not null and (t3.UnitPrice>100 or [Quantity]>20)

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

SELECT [DeliveryMethodName],
	t1.ExpectedDeliveryDate,
	t3.SupplierName,
	t4.FullName
FROM [Purchasing].[PurchaseOrders] t1
JOIN [Application].[DeliveryMethods] t2 on t1.DeliveryMethodID=t2.DeliveryMethodID
JOIN [Purchasing].[Suppliers] t3 on t1.SupplierID=t3.SupplierID
JOIN [Application].[People] t4 on t1.ContactPersonID=t4.PersonID
WHERE [DeliveryMethodName] in ('Air Freight','Refrigerated Air Freight') and [IsOrderFinalized]=1 and 
t1.ExpectedDeliveryDate between '2013-01-01' and '2013-01-31'

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/
SELECT TOP 10 t1.[InvoiceID],
t1.InvoiceDate,
t2.CustomerName as ClientName,
t3.FullName as SalespersonName
FROM [WideWorldImporters].[Sales].[Invoices] t1
JOIN [WideWorldImporters].[Sales].[Customers] t2 on t1.CustomerID=t2.CustomerID
JOIN [WideWorldImporters].[Application].[People] t3 on t1.SalespersonPersonID=t3.PersonID
ORDER BY t1.InvoiceDate desc

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

SELECT t1.[CustomerID],
t1.[CustomerName],
t1.[PhoneNumber]
FROM [WideWorldImporters].[Sales].[Customers] t1
JOIN [WideWorldImporters].[Sales].[Invoices] t2 on t1.CustomerID=t2.CustomerID
JOIN [WideWorldImporters].[Sales].[InvoiceLines] t3 on t2.InvoiceID=t3.InvoiceID
JOIN [WideWorldImporters].[Warehouse].[StockItems] t4 on t3.StockItemID=t4.StockItemID
Where t4.StockItemName ='Chocolate frogs 250g'