SELECT [StockItemName]
FROM [WideWorldImporters].[Warehouse].[StockItems]
WHERE [StockItemName] like'%urgent%' or [StockItemName] like 'Animal%';

SELECT [SupplierName]
FROM [WideWorldImporters].[Purchasing].[Suppliers] t1
LEFT JOIN [WideWorldImporters].[Purchasing].[PurchaseOrders] t2 on t1.SupplierID=t2.SupplierID
WHERE t2.SupplierID is null;

SELECT distinct t2.[OrderID]
FROM [WideWorldImporters].[Sales].[OrderLines] t2
JOIN [WideWorldImporters].[Warehouse].[StockItems] t3 on t2.StockItemID=t3.StockItemID
Where t3.UnitPrice>100 or ([Quantity]>20 and t2.[PickingCompletedWhen] is not null);

SELECT t1.[PurchaseOrderID],
[DeliveryMethodName]
FROM [WideWorldImporters].[Purchasing].[PurchaseOrders] t1
JOIN [WideWorldImporters].[Application].[DeliveryMethods] t2 on t1.DeliveryMethodID=t2.DeliveryMethodID
WHERE [DeliveryMethodName] in ('Air Freight','Refrigerated Air Freight') and [IsOrderFinalized]=1;

SELECT TOP 10 t1.[InvoiceID],
t1.InvoiceDate,
t2.CustomerName,
t3.FullName
FROM [WideWorldImporters].[Sales].[Invoices] t1
JOIN [WideWorldImporters].[Sales].[Customers] t2 on t1.CustomerID=t2.CustomerID
JOIN [WideWorldImporters].[Application].[People] t3 on t1.SalespersonPersonID=t3.PersonID
ORDER BY t1.InvoiceDate desc;

SELECT t1.[CustomerID],
t1.[CustomerName],
t1.[PhoneNumber]
FROM [WideWorldImporters].[Sales].[Customers] t1
JOIN [WideWorldImporters].[Sales].[Invoices] t2 on t1.CustomerID=t2.CustomerID
JOIN [WideWorldImporters].[Sales].[InvoiceLines] t3 on t2.InvoiceID=t3.InvoiceID
JOIN [WideWorldImporters].[Warehouse].[StockItems] t4 on t3.StockItemID=t4.StockItemID
Where t4.StockItemName ='Chocolate frogs 250g';
