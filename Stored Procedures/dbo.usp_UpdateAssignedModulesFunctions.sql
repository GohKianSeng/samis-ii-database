
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateAssignedModulesFunctions]
(@XML AS XML, @Verifier VARCHAR(50))
AS
BEGIN

BEGIN TRY
SET NOCOUNT ON;


DECLARE @idoc int;
EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
	
DECLARE @RequestTable TABLE(ID INT IDENTITY(1,1), RoleID VARCHAR(10), RoleName VARCHAR(50), RoleDeleted BIT, AllModules XML, AllFunctions XML)	
	
INSERT INTO @RequestTable(RoleID, RoleName, RoleDeleted, AllModules, AllFunctions)
Select RoleID, RoleName, RoleDeleted, AllModules, AllFunctions
from OpenXml(@idoc, '/All/*') with (
	RoleID VARCHAR(10) './RoleID',
	RoleName VARCHAR(50) './RoleName',
	RoleDeleted BIT './RoleDeleted',
	AllModules XML './AllModules',
	AllFunctions XML './AllFunctions'
)

DECLARE @NewRole TABLE(RoleID INT, RoleName VARCHAR(50), AllModules XML, ALLFunctions XML)
DECLARE @ExistingRole TABLE(RoleID INT, OriginalRoleName VARCHAR(50), RoleName VARCHAR(50), Deleted BIT, AddedModules XML, RemovedModules XML, AddedFunctions XML, RemovedFunctions XML, [Status] VARCHAR(100))

DECLARE @X INT = 1;
DECLARE @COUNT INT = (SELECT COUNT(1) FROM @RequestTable)
WHILE(@COUNT >= @X)
BEGIN
	DECLARE @RoleID VARCHAR(10), @RoleName VARCHAR(50), @RoleDeleted BIT, @AllModules XML, @AllFunctions XML;
	DECLARE @OrigRoleName VARCHAR(50);	
	SELECT @RoleID = RoleID, @RoleName = RoleName, @RoleDeleted = RoleDeleted, @AllModules = AllModules, @AllFunctions = AllFunctions FROM	@RequestTable WHERE ID = @X;
	SELECT @OrigRoleName = RoleName FROM dbo.tb_Roles WHERE CONVERT(VARCHAR(10), RoleID) = @RoleID
	IF(@RoleID LIKE 'New%.%')
	BEGIN		
		INSERT INTO dbo.tb_Roles (RoleName)
		SELECT @RoleName;		
		SELECT @RoleID = SCOPE_IDENTITY();
		
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllModules;		
		INSERT INTO dbo.tb_Roles_AMF_AccessRights(RoleID, AppModFuncID)
		Select @RoleID, ModuleID		
		from OpenXml(@idoc, '/AllModules/*') with (
			ModuleID VARCHAR(10) './ModuleID'
		);
		
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllFunctions;
		INSERT INTO dbo.tb_Roles_ModulesFunctionsAccessRight(RoleID, FunctionID)
		Select @RoleID, FunctionID		
		from OpenXml(@idoc, '/AllFunctions/*') with (
			FunctionID VARCHAR(10) './FunctionID'
		);
		
		INSERT INTO @NewRole(RoleID, RoleName, AllModules, ALLFunctions)
		SELECT @RoleID, @RoleName, @AllModules.query('//AllModules/*'), @AllFunctions.query('//AllFunctions/*');
	END
	ELSE IF(@RoleDeleted = 1)
	BEGIN
		IF EXISTS(SELECT 1 FROM dbo.tb_Roles_Users WHERE RoleID = @RoleID)
		BEGIN
			INSERT INTO @ExistingRole (RoleID, RoleName, Deleted, [Status])
			SELECT @RoleID, @RoleName, @RoleDeleted, 'Unable to delete. Users exists in rows.';
		END
		ELSE
		BEGIN
			DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID;
			DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID;
			DELETE FROM dbo.tb_Roles WHERE RoleID = @RoleID;
			INSERT INTO @ExistingRole (RoleID, RoleName, Deleted, [Status])
			SELECT @RoleID, @RoleName, @RoleDeleted, 'Role deleted.';
		END
	END
	ELSE
	BEGIN
		DECLARE @AddedModules XML, @RemovedModules XML, @AddedFunctions XML, @RemovedFunctions XML;
		IF(@OrigRoleName <> @RoleName)
		BEGIN
			UPDATE dbo.tb_Roles SET RoleName = @RoleName WHERE CONVERT(VARCHAR(10), RoleID) = @RoleID;			
		END
		
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllModules;
		
		SET @AddedModules = (
			Select ModuleID, ModuleName
			from OpenXml(@idoc, '/AllModules/*') with (
				ModuleID VARCHAR(10) './ModuleID', ModuleName VARCHAR(50) './ModuleName')
			WHERE ModuleID NOT IN (SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID)
			FOR XML PATH('Module'), ELEMENTS);
		
		INSERT INTO dbo.tb_Roles_AMF_AccessRights(RoleID, AppModFuncID)
		Select @RoleID, ModuleID
		from OpenXml(@idoc, '/AllModules/*') with (
			ModuleID VARCHAR(10) './ModuleID', ModuleName VARCHAR(50) './ModuleName')
		WHERE ModuleID NOT IN (SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID);
			
		SET @RemovedModules = (	
			SELECT A.AppModFuncID AS ModuleID, B.AppModFuncName AS ModuleName FROM dbo.tb_Roles_AMF_AccessRights AS A
			INNER JOIN dbo.tb_AppModFunc AS B ON A.AppModFuncID = B.AppModFuncID
			WHERE A.AppModFuncID NOT IN (
				Select ModuleID from OpenXml(@idoc, '/AllModules/*') with (
				ModuleID VARCHAR(10) './ModuleID')
			) AND RoleID = @RoleID
			FOR XML PATH('Module'), ELEMENTS);
		
		DELETE FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID AND AppModFuncID IN (
			SELECT A.AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights AS A
			INNER JOIN dbo.tb_AppModFunc AS B ON A.AppModFuncID = B.AppModFuncID
			WHERE A.AppModFuncID NOT IN (
				Select ModuleID from OpenXml(@idoc, '/AllModules/*') with (
				ModuleID VARCHAR(10) './ModuleID')
			) AND RoleID = @RoleID
		);
			
		EXEC sp_xml_preparedocument @idoc OUTPUT, @AllFunctions;
		
		SET @AddedFunctions = (
			Select FunctionID, FunctionName
			from OpenXml(@idoc, '/AllFunctions/*') with (
				FunctionID VARCHAR(10) './FunctionID', FunctionName VARCHAR(50) './FunctionName')
			WHERE FunctionID NOT IN (SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID)
			FOR XML PATH('Function'), ELEMENTS);
		
		INSERT INTO dbo.tb_Roles_ModulesFunctionsAccessRight(RoleID, functionID)
		Select @RoleID, FunctionID
		from OpenXml(@idoc, '/AllFunctions/*') with (
			FunctionID VARCHAR(10) './FunctionID', FunctionName VARCHAR(50) './FunctionName')
		WHERE FunctionID NOT IN (SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID);
					
		SET @RemovedFunctions = (	
			SELECT A.FunctionID, B.FunctionName FROM dbo.tb_Roles_ModulesFunctionsAccessRight AS A
			INNER JOIN dbo.tb_ModulesFunctions AS B ON A.FunctionID = B.FunctionID
			WHERE A.FunctionID NOT IN (
				Select FunctionID from OpenXml(@idoc, '/AllFunctions/*') with (
				FunctionID VARCHAR(10) './FunctionID')) AND RoleID = @RoleID
			FOR XML PATH('Function'), ELEMENTS);
		
		DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID AND FunctionID IN (
			SELECT A.FunctionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight AS A
			INNER JOIN dbo.tb_ModulesFunctions AS B ON A.FunctionID = B.FunctionID
			WHERE A.FunctionID NOT IN (
				Select FunctionID from OpenXml(@idoc, '/AllFunctions/*') with (
				FunctionID VARCHAR(10) './FunctionID')) AND RoleID = @RoleID
		)
						
		INSERT INTO @ExistingRole(RoleID, OriginalRoleName, RoleName, Deleted, AddedModules, RemovedModules, AddedFunctions, RemovedFunctions)
		SELECT @RoleID, @OrigRoleName, @RoleName, 0, @AddedModules, @RemovedModules, @AddedFunctions, @RemovedFunctions
		
	END	
		
	SET @X = @X + 1;
END

DECLARE @LogID INT;
DECLARE @Changes XML = (
	SELECT 
		CONVERT(XML,(SELECT RoleID, OriginalRoleName, RoleName, Deleted, AddedModules, RemovedModules, AddedFunctions, RemovedFunctions, [Status] FROM @ExistingRole
		FOR XML PATH('Role'), ELEMENTS)) AS UpdateRole,
		CONVERT(XML,(SELECT RoleID, RoleName, AllModules, ALLFunctions FROM @NewRole
		FOR XML PATH('Role'), ELEMENTS)) AS NewRole
	FOR XML PATH('AllRoles'), ELEMENTS);
	
SELECT 'Roles updated' AS Result;
EXEC @LogID = dbo.usp_insertlogging 'I', @Verifier, 'usp_UpdateAssignedModulesFunctions', 'ModuleFunctionChanges', 1, 'NRIC', '', @Changes;


	
	
SET NOCOUNT OFF;
END TRY
BEGIN CATCH
	
	DECLARE @ErrorMSG XML;
	
	SET @ErrorMSG = (
	SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage FOR XML RAW, ELEMENTS)
	
	EXEC dbo.usp_insertlogging 'E', 'SQLERROR', '<SQLERROR />', 'usp_UpdateAssignedModulesFunctions', '<SQLERROR />', 1, 0, @ErrorMSG;
	SET NOCOUNT OFF;
	
END CATCH

END

GO
GO
