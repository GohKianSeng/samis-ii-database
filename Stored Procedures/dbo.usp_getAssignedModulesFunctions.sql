SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAssignedModulesFunctions]
(@RoleID AS INT)
AS
SET NOCOUNT ON;

SELECT (SELECT CONVERT(XML,ISNULL((SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID = @RoleID FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules')),'<AllModules />')),
CONVERT(XML, ISNULL((SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE RoleID = @RoleID FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions')),'<AllFunctions />')) FOR XML PATH(''), ELEMENTS, ROOT('All')) AS XML

SET NOCOUNT OFF;
GO
