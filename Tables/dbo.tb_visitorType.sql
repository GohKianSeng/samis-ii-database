CREATE TABLE [dbo].[tb_visitorType]
(
[VisitorTypeID] [tinyint] NOT NULL IDENTITY(1, 1),
[VisitorTypeName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_visitorType] ADD CONSTRAINT [PK_tb_visitorType] PRIMARY KEY CLUSTERED  ([VisitorTypeID]) ON [PRIMARY]
GO
