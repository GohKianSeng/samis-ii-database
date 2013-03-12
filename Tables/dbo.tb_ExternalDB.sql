CREATE TABLE [dbo].[tb_ExternalDB]
(
[ExternalDBID] [int] NOT NULL IDENTITY(1, 1),
[ExternalSiteName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__tb_Extern__Exter__4959E263] DEFAULT (''),
[ExternalDBIP] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
