CREATE TABLE [dbo].[tb_occupation]
(
[OccupationID] [int] NOT NULL IDENTITY(1, 1),
[OccupationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_occupation] ADD CONSTRAINT [PK_tb_occupation] PRIMARY KEY CLUSTERED  ([OccupationID]) ON [PRIMARY]
GO
