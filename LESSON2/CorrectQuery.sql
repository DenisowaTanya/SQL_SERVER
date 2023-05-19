/*Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
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

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.*/

USE WideWorldImporters

SELECT distinct t2.[OrderID],
FORMAT(OrderDate,'dd.MM.yyyy') as [FormatOrderDate],
DATENAME(month,OrderDate) as [MonthName],
DATEPART(quarter,OrderDate) as [Quarter],
CASE WHEN month(OrderDate)<=4 THEN 1
	WHEN month(OrderDate) between 5 and 8 THEN 2
	WHEN month(OrderDate)>=8 THEN 3
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