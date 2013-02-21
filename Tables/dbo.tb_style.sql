CREATE TABLE [dbo].[tb_style]
(
[styleID] [int] NOT NULL IDENTITY(1, 1),
[styleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_style] ADD CONSTRAINT [PK_tb_appointment] PRIMARY KEY CLUSTERED  ([styleID]) ON [PRIMARY]
GO
