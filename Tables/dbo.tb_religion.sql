CREATE TABLE [dbo].[tb_religion]
(
[ReligionID] [tinyint] NOT NULL IDENTITY(1, 1),
[ReligionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_religion] ADD CONSTRAINT [PK_tb_religion] PRIMARY KEY CLUSTERED  ([ReligionID]) ON [PRIMARY]
GO
