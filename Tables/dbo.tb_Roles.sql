CREATE TABLE [dbo].[tb_Roles]
(
[RoleID] [int] NOT NULL IDENTITY(1, 1),
[RoleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Roles] ADD CONSTRAINT [PK_tb_Roles] PRIMARY KEY CLUSTERED  ([RoleID]) ON [PRIMARY]
GO
