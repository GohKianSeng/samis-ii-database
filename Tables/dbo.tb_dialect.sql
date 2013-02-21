CREATE TABLE [dbo].[tb_dialect]
(
[DialectID] [int] NOT NULL IDENTITY(1, 1),
[DialectName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_dialect] ADD CONSTRAINT [PK_tb_dialect] PRIMARY KEY CLUSTERED  ([DialectID]) ON [PRIMARY]
GO
