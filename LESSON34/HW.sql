--Для своей базы я считаю, что разбивать на части пока не нужно,
--поскольку есть много общих запросов, не помесячных
--но в качестве примера возьму копию таблицы [SecondarySales].[ChikagoDocJournal]
--буду разбивать по месяцам (месяц-год, возьмем поле [DateDocChikago])

--Скрипт таблицы
USE SEC

CREATE TABLE [SecondarySales].[ChikagoDocJournal](
	[ID] [bigint] NOT NULL,
	[DateDocChikago] [datetime] NOT NULL,
	[IdStatus] [bigint] NULL,
	[Deleted] [bit] NOT NULL,
	[IDSR] [bigint] NULL,
 CONSTRAINT [PK_ChikagoDocJournal] PRIMARY KEY CLUSTERED  ( [ID] ASC )  ON [PRIMARY] ) 
 ON [PRIMARY]
GO

--В таблице 1630348 строк

--добавляем файловую группу
ALTER DATABASE [SEC] ADD FILEGROUP [fgDocJournDateCopy] 
GO

--добавляем файл БД
ALTER DATABASE [SEC] ADD FILE 
( NAME = N'DocJournDateCopy', FILENAME = N'D:\Data\DocJournDateCopy.ndf' , 
SIZE = 65536KB , FILEGROWTH = 32768KB ) TO FILEGROUP [fgDocJournDateCopy]
GO

--создаем функцию партиционирования по месяцам (ниже 22 года не берем, поскольку эти данные нужны очень редко)
CREATE PARTITION FUNCTION [fnDocJournDateCopy](DATETIME) AS RANGE RIGHT FOR VALUES
('2022-01-01T00:00:00.000','2022-02-01T00:00:00.000','2022-03-01T00:00:00.000','2022-04-01T00:00:00.000',
'2022-05-01T00:00:00.000', '2022-06-01T00:00:00.000', '2022-07-01T00:00:00.000', '2022-08-01T00:00:00.000',
'2022-09-01T00:00:00.000', '2022-10-01T00:00:00.000','2022-11-01T00:00:00.000', '2022-12-01T00:00:00.000',
'2023-01-01T00:00:00.000','2023-02-01T00:00:00.000','2023-03-01T00:00:00.000','2023-04-01T00:00:00.000',
'2023-05-01T00:00:00.000', '2023-06-01T00:00:00.000', '2023-07-01T00:00:00.000', '2023-08-01T00:00:00.000',
'2023-09-01T00:00:00.000', '2023-10-01T00:00:00.000','2023-11-01T00:00:00.000', '2023-12-01T00:00:00.000');																																																									
GO--

--партиционируем
CREATE PARTITION SCHEME [shcmDocJournDateCopy] AS PARTITION [fnDocJournDateCopy]
ALL TO ([fgDocJournDateCopy] )
GO

--создаем партиционированные таблицы
SELECT * INTO [SecondarySales].[ChikagoDocJournalCopy]
FROM [SecondarySales].[ChikagoDocJournal];

--добавляем кластерный индекс в таблицу
ALTER TABLE [SecondarySales].[ChikagoDocJournalCopy] ADD CONSTRAINT PK_DJCopy_DateDoc 
PRIMARY KEY CLUSTERED  ([DateDocChikago],[ID])
ON [shcmDocJournDateCopy] ([DateDocChikago]);

--проверяем, как распределились данные
SELECT  $PARTITION.fnDocJournDateCopy(DateDocChikago) AS Partition
		, COUNT(*) AS [COUNT]
		, MIN(DateDocChikago) as [Start]
		,MAX(DateDocChikago)  as [End]
FROM [SecondarySales].[ChikagoDocJournalCopy]s
GROUP BY $PARTITION.fnDocJournDateCopy(DateDocChikago)
ORDER BY Partition ;  

--Partition	COUNT	Start					          End
--1	    427150	1900-01-01 00:00:00.000	  2021-12-31 00:00:00.000
--2	    25753	2022-01-01 00:00:00.000	    2022-01-31 00:00:00.000
--3	    29198	2022-02-01 00:00:00.000	    2022-02-28 00:00:00.000
--4  	  33029	2022-03-01 00:00:00.000	    2022-03-31 00:00:00.000
--5	    32506	2022-04-01 00:00:00.000	    2022-04-30 00:00:00.000
--6	    34985	2022-05-01 00:00:00.000	    2022-05-31 00:00:00.000
--7	    38391	2022-06-01 00:00:00.000	    2022-06-30 00:00:00.000
--8	    37178	2022-07-01 00:00:00.000	    2022-07-31 00:00:00.000
--9	    40585	2022-08-01 00:00:00.000	    2022-08-31 00:00:00.000
--10	  35836	2022-09-01 00:00:00.000	    2022-09-30 00:00:00.000
--11	  34308	2022-10-01 00:00:00.000	    2022-10-31 00:00:00.000
--12	  34455	2022-11-01 00:00:00.000	    2022-11-30 00:00:00.000
--13	  32516	2022-12-01 00:00:00.000	    2022-12-31 00:00:00.000
--14	  29540	2023-01-01 00:00:00.000	    2023-01-31 00:00:00.000
--15	  42067	2023-02-01 00:00:00.000	    2023-02-28 12:00:00.000
--16	  49861	2023-03-01 00:00:00.000	    2023-03-31 12:00:01.000
--17	  44369	2023-04-01 00:00:00.000	    2023-04-30 00:00:00.000
--18	  51729	2023-05-01 00:00:00.000	    2023-05-31 10:35:48.000
--19	  109229	2023-06-01 00:00:00.000	  2023-06-30 13:34:53.000
--20	  160656	2023-07-01 00:00:00.000	  2023-07-31 17:58:31.000
--21	  200856	2023-08-01 00:00:00.000	  2023-08-31 19:24:53.000
--22	  109263	2023-09-01 00:00:00.000	  2023-09-30 20:36:18.000
--23	  7044	2023-10-01 00:00:00.000	    2023-10-04 07:08:12.000
