CREATE TABLE [dbo].[tb_Roles_AMF_AccessRights]
(
[RoleID] [int] NOT NULL,
[AppModFuncID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights] ADD CONSTRAINT [PK_tb_Roles_AMF_AccessRights] PRIMARY KEY CLUSTERED  ([RoleID], [AppModFuncID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights] ADD CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_AppModFunc] FOREIGN KEY ([AppModFuncID]) REFERENCES [dbo].[tb_AppModFunc] ([AppModFuncID])
GO
ALTER TABLE [dbo].[tb_Roles_AMF_AccessRights] ADD CONSTRAINT [FK_tb_Roles_AMF_AccessRights_tb_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
