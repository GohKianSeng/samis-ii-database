CREATE TABLE [dbo].[tb_language]
(
[LanguageID] [int] NOT NULL IDENTITY(1, 1),
[LanguageName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_language] ADD CONSTRAINT [PK_tb_language] PRIMARY KEY CLUSTERED  ([LanguageID]) ON [PRIMARY]
GO
