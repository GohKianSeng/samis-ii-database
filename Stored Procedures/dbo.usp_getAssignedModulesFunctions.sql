
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAssignedModulesFunctions]
(@RoleID AS INT)
AS
SET NOCOUNT ON;

DECLARE @RoleName VARCHAR(50) = (SELECT RoleName FROM dbo.tb_Roles WHERE RoleID = @RoleID);

SELECT (SELECT CONVERT(XML,ISNULL((SELECT B.AppModFuncID, B.AppModFuncName, B.[Description] FROM dbo.tb_Roles_AMF_AccessRights AS A INNER JOIN dbo.tb_AppModFunc AS B ON A.AppModFuncID = B.AppModFuncID WHERE RoleID = @RoleID FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules')),'<AllModules />')),
CONVERT(XML, ISNULL((SELECT B.functionID, B.functionName, B.[Description] FROM dbo.tb_Roles_ModulesFunctionsAccessRight AS A INNER JOIN dbo.tb_ModulesFunctions AS B ON B.functionID = A.functionID WHERE RoleID = @RoleID FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions')),'<AllFunctions />')), @RoleName AS RoleName FOR XML PATH(''), ELEMENTS, ROOT('All')) AS XML;


SET NOCOUNT OFF;

GO
