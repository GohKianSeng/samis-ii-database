CREATE TABLE [dbo].[tb_AppModFunc]
(
[AppModFuncID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AppModFuncName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[URL] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NULL,
[Description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__tb_AppMod__Descr__477199F1] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_AppModFunc] ADD CONSTRAINT [PK_tb_AppModFunc] PRIMARY KEY CLUSTERED  ([AppModFuncID]) ON [PRIMARY]
GO
