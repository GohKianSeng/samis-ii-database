CREATE TABLE [dbo].[tb_parish]
(
[ParishID] [tinyint] NOT NULL IDENTITY(1, 1),
[ParishName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_parish] ADD CONSTRAINT [PK_tb_parish] PRIMARY KEY CLUSTERED  ([ParishID]) ON [PRIMARY]
GO
