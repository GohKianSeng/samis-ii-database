CREATE TABLE [dbo].[tb_Roles_Users]
(
[RoleID] [int] NOT NULL,
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Roles_Users] ADD CONSTRAINT [PK_tb_Roles_Users] PRIMARY KEY CLUSTERED  ([RoleID], [UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Roles_Users] ADD CONSTRAINT [FK_tb_Roles_Users_tb_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
ALTER TABLE [dbo].[tb_Roles_Users] ADD CONSTRAINT [FK_tb_Roles_Users_tb_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[tb_Users] ([UserID])
GO
