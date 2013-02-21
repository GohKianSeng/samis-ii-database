CREATE TABLE [dbo].[tb_churchArea]
(
[AreaID] [tinyint] NOT NULL IDENTITY(1, 1),
[AreaName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_churchArea] ADD CONSTRAINT [PK_tb_churchArea] PRIMARY KEY CLUSTERED  ([AreaID]) ON [PRIMARY]
GO
