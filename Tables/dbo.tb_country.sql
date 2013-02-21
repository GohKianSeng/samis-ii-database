CREATE TABLE [dbo].[tb_country]
(
[CountryID] [tinyint] NOT NULL IDENTITY(1, 1),
[CountryName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_country] ADD CONSTRAINT [PK_tb_country] PRIMARY KEY CLUSTERED  ([CountryID]) ON [PRIMARY]
GO
