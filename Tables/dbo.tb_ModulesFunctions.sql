CREATE TABLE [dbo].[tb_ModulesFunctions]
(
[functionID] [int] NOT NULL IDENTITY(1, 1),
[Module] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[functionName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_ModulesFunctions_Description] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_ModulesFunctions] ADD CONSTRAINT [PK_tb_ModulesFunctions] PRIMARY KEY CLUSTERED  ([functionID]) ON [PRIMARY]
GO
