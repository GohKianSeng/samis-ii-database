CREATE TABLE [dbo].[tb_cellgroup]
(
[CellgroupID] [tinyint] NOT NULL IDENTITY(1, 1),
[CellgroupName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CellgroupLeader] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PostalCode] [int] NOT NULL,
[StreetAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BLKHouse] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Unit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_cellgroup_Unit] DEFAULT (''),
[Deleted] [bit] NOT NULL CONSTRAINT [DF_tb_cellgroup_Deleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_cellgroup] ADD CONSTRAINT [PK_tb_cellgroup] PRIMARY KEY CLUSTERED  ([CellgroupID]) ON [PRIMARY]
GO
