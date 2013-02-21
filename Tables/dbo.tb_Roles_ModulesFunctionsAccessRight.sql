CREATE TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight]
(
[RoleID] [int] NOT NULL,
[functionID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight] ADD CONSTRAINT [PK_tb_Roles_ModulesFunctionsAccessRight] PRIMARY KEY CLUSTERED  ([RoleID], [functionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight] ADD CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_ModulesFunctions] FOREIGN KEY ([functionID]) REFERENCES [dbo].[tb_ModulesFunctions] ([functionID])
GO
ALTER TABLE [dbo].[tb_Roles_ModulesFunctionsAccessRight] ADD CONSTRAINT [FK_tb_Roles_ModulesFunctionsAccessRight_tb_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[tb_Roles] ([RoleID])
GO
