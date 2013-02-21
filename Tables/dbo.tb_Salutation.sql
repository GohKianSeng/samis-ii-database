CREATE TABLE [dbo].[tb_Salutation]
(
[SalutationID] [tinyint] NOT NULL IDENTITY(1, 1),
[SalutationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Salutation] ADD CONSTRAINT [PK_tb_Salutation] PRIMARY KEY CLUSTERED  ([SalutationID]) ON [PRIMARY]
GO
