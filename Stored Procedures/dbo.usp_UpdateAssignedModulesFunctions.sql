SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateAssignedModulesFunctions]
(@XML AS XML, @RoleID AS INT)
 
AS
SET NOCOUNT ON;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
	
	DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID
	
	INSERT INTO dbo.tb_Roles_AMF_AccessRights(RoleID, AppModFuncID)
	SELECT @RoleID, ModuleID
	FROM OPENXML(@idoc, '/All/AllModules/*')
	WITH (
	ModuleID VARCHAR(50)'./ModuleID');
	
	DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID
	
	INSERT INTO dbo.tb_Roles_ModulesFunctionsAccessRight
	SELECT @RoleID, FunctionID
	FROM OPENXML(@idoc, '/All/AllFunctions/*')
	WITH (
	FunctionID VARCHAR(50)'./FunctionID');
	
	SELECT RoleName + ' updated.' AS Result FROM dbo.tb_Roles where RoleID = @RoleID

SET NOCOUNT OFF;
GO
