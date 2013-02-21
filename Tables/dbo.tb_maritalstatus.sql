CREATE TABLE [dbo].[tb_maritalstatus]
(
[MaritalStatusID] [tinyint] NOT NULL IDENTITY(1, 1),
[MaritalStatusName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_maritalstatus] ADD CONSTRAINT [PK_tb_maritalstatus] PRIMARY KEY CLUSTERED  ([MaritalStatusID]) ON [PRIMARY]
GO
