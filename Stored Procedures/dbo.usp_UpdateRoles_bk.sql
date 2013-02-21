SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRoles_bk]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (RolesID VARCHAR(10), RolesName VARCHAR(100))
	INSERT INTO @table(RolesID, RolesName)
	Select RolesID, RolesName
	from OpenXml(@xdoc, '/ChurchRole/*')
	with (
	RolesID VARCHAR(10) './RoleID',
	RolesName VARCHAR(100) './RoleName') WHERE RolesID <> 'New';		
	
	UPDATE dbo.tb_roles SET dbo.tb_Roles.RoleName = a.RolesName
	from @table AS a WHERE a.RolesID <> 'New' AND dbo.tb_roles.RoleID = a.RolesID; 
	
	DELETE FROM @table WHERE RolesID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_roles 
				WHERE RoleID IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_AMF_AccessRights)
				AND RoleID NOT IN (Select RolesID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_Roles (RoleName)
		Select RolesName
		from OpenXml(@xdoc, '/ChurchRole/*')
		with (
		RolesID VARCHAR(10) './RoleID',
		RolesName VARCHAR(100) './RoleName') WHERE RolesID = 'New';
	
		SELECT 'Unable to delete, Roles still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Roles 
		WHERE RoleID NOT IN (SELECT DISTINCT RoleID FROM dbo.tb_Roles_AMF_AccessRights)
		AND RoleID NOT IN (Select RolesID FROM @table)
		
		INSERT INTO dbo.tb_Roles (RoleName)
		Select RolesName
		from OpenXml(@xdoc, '/ChurchRoles/*')
		with (
		RolesID VARCHAR(10) './RolesID',
		RolesName VARCHAR(100) './RolesName') WHERE RolesID = 'New';
		
		SELECT 'Roles updated.' AS Result
	END

SET NOCOUNT OFF;
GO
