USE DWH

--для добавления в существующую базу будет использоваться следующий запрос:
INSERT INTO [SecondarySales].[Agents]
([AgentName],
[CreateDate],
[ChikagoName],
[ChikagoCode])
SELECT DISTINCT 
[ChikagoNameAgent],
GETDATE(),
[ChikagoNameAgent],
[ChikagoAgentID]
FROM [SecondarySales].[ChikagoAgents]
WHERE [AgentID] IS NULL;

--Используется Clustered Index Scan
--добавим индекс по [AgentID], поскольку в дальнейшем он чаще будет встречаться и добавим поле [ChikagoNameAgent] в INCLUDE

CREATE NONCLUSTERED INDEX [IDX_ChikagoNameAgent] 
ON [SecondarySales].[ChikagoAgents] ([AgentID])
INCLUDE ([ChikagoNameAgent])
--По плану запроса используется новый индекс. Происходит поиск в индексе.

insert into [SecondarySales].[Nomenclatures]
  ([NomenclatureName]
      ,[NomenclatureWeight]
      ,[CreateDate]
      ,[PrimaryName]
      ,[Level]
      ,[ProductGroup]
      ,[TradeMark])
SELECT DISTINCT [NameTrueChikagoNom]
      ,[WeightChikagoNom]
	  ,getdate()
	  ,[NameTrueChikagoNom]
      ,[LevelChikagoNom]
      ,[GroupChikagoNom]
      ,[TradeMarkChikagoNom]
FROM [SecondarySales].[ChikagoNom]
WHERE [IDNomenclature] is null;
--используется Clustered Index Scan
--Добавим индекс по полю IDNomenclature и остальные в include

CREATE NONCLUSTERED INDEX [IDX_ChikagoNom] 
ON [SecondarySales].[ChikagoNom] ([IDNomenclature])
INCLUDE ([NameTrueChikagoNom],[WeightChikagoNom],[LevelChikagoNom],[GroupChikagoNom],[TradeMarkChikagoNom])
--Используется новый индекс. Поскольку это будет происходить каждый день, возможно, его стоит оставить

--Делаем индексы по FK
CREATE NONCLUSTERED INDEX [IDX_IDDoc] 
ON [SecondarySales].[ChikagoSalesHd]([IDDoc] ASC);

CREATE NONCLUSTERED INDEX [IDX_IDSR] 
ON [SecondarySales].[ChikagoSalesHd]([IDSalesRepres] ASC);

CREATE NONCLUSTERED INDEX [IDX_IDFirm] 
ON [SecondarySales].[ChikagoSalesHd]([IDFirm] ASC);

CREATE NONCLUSTERED INDEX [IDX_IDDistributor] 
ON [SecondarySales].[ChikagoSalesHd]([IDDistributor] ASC);

CREATE NONCLUSTERED INDEX [IDX_IDTP] 
ON [SecondarySales].[ChikagoSalesHd]([TradePointID] ASC);

CREATE NONCLUSTERED INDEX [IDX_IDDocLines] 
ON [SecondarySales].[ChikagoSalesLines]([IDDoc] ASC);

CREATE NONCLUSTERED INDEX [IDX_IDNomLines] 
ON [SecondarySales].[ChikagoSalesLines]([IDChikagoNom] ASC);


--Даные из таблиц фактов будут участвовать в представлении:
--Представление будет

--ALTER VIEW [SecondarySales].[vSalesChikago] AS
SELECT t1.DateID,
t2.NomenclatureID,
t1.AgentID,
t1.TradePointID,
t1.SRID,
t1.SVID,
t2.Quantity,
t2.Quantity*t4.WeightChikagoNom as SalesVolume,
t2.Amount,
t5.[OKB]
FROM [SecondarySales].[ChikagoSalesHd] t1
JOIN [SecondarySales].[ChikagoSalesLines] t2 on t1.IDDoc=t2.IDDoc
JOIN [SecondarySales].[ChikagoDocJournal] t3 on t1.IDDoc=t3.ID
JOIN [SecondarySales].[ChikagoNom] t4 on t2.IDChikagoNom=t4.IDChikagoNom
LEFT JOIN [SecondarySales].[vActualOKB] t5 on t1.AgentID=t5.AgentID
Where t3.IdStatus=1 and t3.Deleted=0
and t1.DateID>=20230703

CREATE NONCLUSTERED INDEX [IDX_vChikagoSales] 
ON [SecondarySales].[ChikagoSalesHd] (DateID,AgentID,TradePointID,SRID,SVID)

--индекс используется, но я не уверена нужен ли он.
