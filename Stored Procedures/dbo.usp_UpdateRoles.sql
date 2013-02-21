SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRoles]
(@AllRoles AS XML)
AS

BEGIN
	
	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @AllRoles;
	DECLARE @oldRoles Table(RoleID INT, RoleName VARCHAR(50))
	DECLARE @newRoles Table(RoleName VARCHAR(50))
	DECLARE @RolesInUse Table(RoleName VARCHAR(50))
	DECLARE @RolesDeleted Table(RoleName VARCHAR(50))
	
	INSERT INTO @oldRoles(RoleID, RoleName)
	SELECT RoleID, RoleName
	FROM OPENXML(@idoc, '/AllRoles/*')
	WITH (
	RoleID VARCHAR(50)'./RoleID',
	RoleName VARCHAR(50)'./RoleName') WHERE RoleID <> 'new';
	
	INSERT INTO @newRoles(RoleName)
	SELECT RoleName
	FROM OPENXML(@idoc, '/AllRoles/*')
	WITH (
	RoleID VARCHAR(50)'./RoleID',
	RoleName VARCHAR(50)'./RoleName') WHERE RoleID = 'new';
	
	INSERT INTO @RolesInUse(RoleName)
	SELECT RoleName FROM dbo.tb_Roles WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)
	
	DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)
	DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)
	DELETE FROM dbo.tb_Roles OUTPUT DELETED.RoleName INTO @RolesDeleted WHERE RoleID NOT IN (SELECT RoleID FROM @oldRoles) AND RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_Users)	
	
	INSERT INTO dbo.tb_Roles (RoleName)
	SELECT RoleName FROM @newRoles
	
		SELECT ISNULL((SELECT RoleName FROM @newRoles
			FOR XML RAW(''), ELEMENTS, Root('AddedRoles')
			), '<AddedRoles />') AS AddedUsers,
		   ISNULL((SELECT RoleName FROM @RolesInUse
			FOR XML RAW(''), ELEMENTS, Root('FailedRole')
			), '<FailedRole />') AS FailedRole,
		   ISNULL((SELECT RoleName FROM @RolesDeleted
			FOR XML RAW(''), ELEMENTS, Root('DeletedUsers')
			), '<DeletedUsers />') AS DeletedUsers
	

SET NOCOUNT OFF;
END	

GO
