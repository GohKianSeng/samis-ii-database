CREATE TABLE [dbo].[tb_ministry]
(
[MinistryID] [tinyint] NOT NULL IDENTITY(1, 1),
[MinistryName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MinistryInCharge] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MinistryDescription] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_tb_ministry_Deleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_ministry] ADD CONSTRAINT [PK_tb_ministry] PRIMARY KEY CLUSTERED  ([MinistryID]) ON [PRIMARY]
GO
