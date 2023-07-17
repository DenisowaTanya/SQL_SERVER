--Создать базу данных
CREATE DATABASE [DWH]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DWH', FILENAME = N'D:\MyBase\DWH.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10% )
 LOG ON 
( NAME = N'DWH_log', FILENAME = N'D:\MyBase\DWH_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 10% )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

--3-4 основные таблицы для своего проекта.

USE [DWH]
GO

CREATE TABLE [SecondarySales].[ChikagoAgents]
   ([ChikagoAgentID] bigint NOT NULL,
	[ChikagoNameAgent] nvarchar(255) NOT NULL,
	[AgentID] int NULL
	CONSTRAINT [PK__Agents] PRIMARY KEY ([ChikagoAgentID]));


CREATE TABLE [SecondarySales].[ChikagoTradePoints]
   ([ChikagoTPID] bigint NOT NULL,
	[ChikagoTPName] nvarchar(255) NULL,
	[ChikagoTPBanner] nvarchar(255) NULL,
	[ChikagoTPAddress] nvarchar(300) NULL,
	[ChikagoTPDistrChanell] nvarchar(100) NULL,
	[CreateDate] datetime NULL,
	[TradePointID] int NULL,
	[ChikagoTPNameTrue] nvarchar(255) NULL
	CONSTRAINT [PK_ChikagoTradePoints] PRIMARY KEY ([ChikagoTPID]));

CREATE TABLE [SecondarySales].[ChikagoNom]
   ([IDChikagoNom] bigint NOT NULL,
	[FulllNameChikagoNom] nvarchar(255) NULL,
	[WeightChikagoNom] decimal(15, 6) NULL,
	[LevelChikagoNom] nvarchar(255) NULL,
	[GroupChikagoNom] nvarchar(255) NULL,
	[TradeMarkChikagoNom] nvarchar(255) NULL,
	[CreateDateChikagoNom] datetime NULL,
	[IDNomenclature] int NULL,
	[ChikagoBrand] nvarchar(255) NULL,
	[NameTrueChikagoNom] nvarchar(255) NULL
	CONSTRAINT [PK_ChikagoNom] PRIMARY KEY ([IDChikagoNom]));

CREATE TABLE [SecondarySales].[ChikagoSalesHd]
   ([IDDoc] bigint NOT NULL,
	[IDSalesRepres] bigint NOT NULL,
	[IDFirm] bigint NOT NULL,
	[IDDistributor] bigint NOT NULL,
	[IDTradePoint] bigint NOT NULL,
	[SRID] int NULL,
	[TradePointID] int NULL,
	[AgentID] int NULL,
	[DateID] int NULL,
	[SVID] int NULL,
	[CreateDate] datetime NULL
	CONSTRAINT [PK_ChikagoSalesHd] PRIMARY KEY ([IDDoc]));

CREATE TABLE [SecondarySales].[ChikagoSalesLines](
	[IDLines] bigint NOT NULL,
	[IDDoc] bigint NOT NULL,
	[IDChikagoNom] bigint NOT NULL,
	[NomenclatureID] int NULL,
	[Amount] decimal(15, 4) NULL,
	[Quantity] decimal(15, 6) NULL,
	[AmountDiscount] decimal(15, 4) NULL,
	[CreateDate] datetime NULL,
   CONSTRAINT [PK_ChikagoSalesLines] PRIMARY KEY ([IDLines])); 

CREATE TABLE [SecondarySales].[ChikagoDocJournal](
	[ID] bigint NOT NULL,
	[DateDocChikago] datetime NOT NULL,
	[IdStatus] bigint NULL,
	[Deleted] bit NOT NULL,
   CONSTRAINT [PK_ChikagoDocJournal] PRIMARY KEY([ID]);


--Первичные и внешние ключи для всех созданных таблиц

 ALTER TABLE [SecondarySales].[ChikagoClassifiers] 
 ADD  CONSTRAINT [PK_ChikagoClassifiers] PRIMARY KEY ([IDClassifier]);

 ALTER TABLE [SecondarySales].[ChikagoSalesLines]
 ADD CONSTRAINT FK_ChikagoSalesLines_ChikagoNom FOREIGN KEY ([IDChikagoNom]) 
 REFERENCES [SecondarySales].[ChikagoNom] ([IDChikagoNom]);

 ALTER TABLE [SecondarySales].[ChikagoSalesLines]   
 ADD  CONSTRAINT [FK_ChikagoSalesLines_ChikagoDocJournal] FOREIGN KEY([IDDoc])
 REFERENCES [SecondarySales].[ChikagoDocJournal] ([ID]);

 ALTER TABLE [SecondarySales].[ChikagoSalesHd]  
 ADD  CONSTRAINT [FK_ChikagoSalesHd_ChikagoAgents1] FOREIGN KEY([IDDistributor])
 REFERENCES [SecondarySales].[ChikagoAgents] ([ChikagoAgentID]);

 ALTER TABLE [SecondarySales].[ChikagoSalesHd]  
 ADD  CONSTRAINT [FK_ChikagoSalesHd_ChikagoTradePoints1] FOREIGN KEY([IDTradePoint])
 REFERENCES [SecondarySales].[ChikagoTradePoints] ([ChikagoTPID]);

 ALTER TABLE [SecondarySales].[ChikagoSalesHd]  
 ADD  CONSTRAINT [FK_ChikagoSalesHd_ChikagoDocJournal] FOREIGN KEY([IDDoc])
 REFERENCES [SecondarySales].[ChikagoDocJournal] ([ID]);

 ALTER TABLE [SecondarySales].[ChikagoSalesHd] 
 ADD  CONSTRAINT [FK_ChikagoSalesHd_ChikagoAgents1] FOREIGN KEY([IDDistributor])
 REFERENCES [SecondarySales].[ChikagoAgents] ([ChikagoAgentID]);

 ALTER TABLE [SecondarySales].[ChikagoSalesHd]  
 ADD  CONSTRAINT [FK_ChikagoSalesHd_ChikagoAgents1] FOREIGN KEY([IDDistributor])
 REFERENCES [SecondarySales].[ChikagoAgents] ([ChikagoAgentID]);

 --1-2 индекса на таблицы
 CREATE NONCLUSTERED INDEX [Tp_Name_Address] 
 ON [SecondarySales].[ChikagoTradePoints]
([ChikagoTPName],[ChikagoTPAddress]);

--Наложите по одному ограничению в каждой таблице на ввод данных.

ALTER TABLE [SecondarySales].[ChikagoAgents]
ADD  CONSTRAINT [Uniq_ChikagoAgentID] UNIQUE ([ChikagoAgentID]);

ALTER TABLE [SecondarySales].[ChikagoTradePoints]
ADD CONSTRAINT [Uniq_ChikagoTPID] UNIQUE ([ChikagoTPID]);

ALTER TABLE [SecondarySales].[ChikagoNom]
ADD CONSTRAINT [Uniq_ChikagoNom] UNIQUE ([IDChikagoNom]);

ALTER TABLE [SecondarySales].[ChikagoDocJournal]
ADD CONSTRAINT [Uniq_DocID] UNIQUE ([ID]);

ALTER TABLE [SecondarySales].[ChikagoSalesHd]
ADD CONSTRAINT [DF_SVID] DEFAULT 1 FOR [SVID] 
