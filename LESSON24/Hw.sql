
-- новые и старые


ALTER VIEW [SecondarySales].[vSalesDay]
AS
SELECT [DateID]
      ,[NomenclatureID]
      ,[AgentID]
      ,[TradePointID]
      ,[SalesRepresID]
      ,[SupervisorID]
      ,[SalesItem]
      ,[SalesVolume]
      ,[SalesValue]
	  ,[okb]
FROM [DWH].[SecondarySales].[SalesDay]
UNION ALL
SELECT [DateID]
      ,IDNomenclature
      ,[AgentID]
      ,[TradePointID]
      ,[SRID]
      ,[SVID]
      ,[Quantity]
      ,[SalesVolume]
      ,[Amount]
      ,[OKB]
  FROM [DWH].[SecondarySales].[vSalesChikago]

-- новые

ALTER VIEW [SecondarySales].[vGoodsReceipt]
AS
SELECT t4.DateID,
  t5.AgentID,
  t6.IDNomenclature,
  t2.Quantity*[UnitFactor] as SalesItem,
  t2.Price*t2.Quantity*[UnitFactor] as SalesValue,
  t2.Quantity*t6.WeightChikagoNom*[UnitFactor] as SalesVolume
  FROM [SecondarySales].[dhGoodsReceipt] t1
  JOIN [SecondarySales].[drGoodsReceipt] t2 on t1.IDDoc=t2.IDDoc
  JOIN [SecondarySales].[ChikagoDocJournal] t3 on t1.IDDoc=t3.ID
  JOIN [Calendar].[Calendar] t4 on CAST(t3.DateDocChikago as date)=t4.Date
  JOIN [SecondarySales].[ChikagoAgents] t5 on t1.IDDistributor=t5.ChikagoAgentID
  JOIN [SecondarySales].[ChikagoNom] t6 on t2.IDChikagoNom=t6.IDChikagoNom
  WHERE [Deleted]=0 and [IdStatus]=1 and t2.Quantity<>0 and t4.DateID>=20230703
  AND IDGoodsChikagoNom=0
