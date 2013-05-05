CREATE TABLE [dbo].[tb_ExternalDB]
(
[ExternalDBID] [int] NOT NULL IDENTITY(1, 1),
[ExternalSiteName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_ExternalDB_ExternalSiteName] DEFAULT (''),
[ExternalDBIP] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
