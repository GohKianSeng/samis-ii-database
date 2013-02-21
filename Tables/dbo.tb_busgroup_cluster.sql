CREATE TABLE [dbo].[tb_busgroup_cluster]
(
[BusGroupClusterID] [tinyint] NOT NULL IDENTITY(1, 1),
[BusGroupClusterName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_busgroup_cluster] ADD CONSTRAINT [PK_tb_busgroup_cluster] PRIMARY KEY CLUSTERED  ([BusGroupClusterID]) ON [PRIMARY]
GO
