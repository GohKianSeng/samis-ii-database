CREATE TABLE [dbo].[tb_App_Config]
(
[ConfigID] [int] NOT NULL IDENTITY(1, 1),
[ConfigName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[value] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_App_Config] ADD CONSTRAINT [PK_tb_App_Config] PRIMARY KEY CLUSTERED  ([ConfigID]) ON [PRIMARY]
GO
