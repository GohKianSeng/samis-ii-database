CREATE TABLE [dbo].[tb_familytype]
(
[FamilyTypeID] [tinyint] NOT NULL IDENTITY(1, 1),
[FamilyType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_familytype] ADD CONSTRAINT [PK_tb_familytype] PRIMARY KEY CLUSTERED  ([FamilyTypeID]) ON [PRIMARY]
GO
