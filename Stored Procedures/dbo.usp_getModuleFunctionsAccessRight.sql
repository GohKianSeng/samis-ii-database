SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getModuleFunctionsAccessRight]
(@UserID VARCHAR(50))
 
AS
SET NOCOUNT ON;
DECLARE @xml AS XML;
DECLARE @count AS INT;
SELECT @count = COUNT(*) FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
JOIN dbo.tb_ModulesFunctions ON dbo.tb_ModulesFunctions.functionID = dbo.tb_Roles_ModulesFunctionsAccessRight.functionID
WHERE RoleID IN (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID) OR RoleID = -1;

IF (@count = 0)
BEGIN
	SET @xml = '<FunctionAccessRight></FunctionAccessRight>';
END
ELSE
BEGIN
	SET @xml = (SELECT CONVERT (XML, (SELECT functionName FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
	JOIN dbo.tb_ModulesFunctions ON dbo.tb_ModulesFunctions.functionID = dbo.tb_Roles_ModulesFunctionsAccessRight.functionID
	WHERE Module <> 'Congregation' AND RoleID IN (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID) OR RoleID = -1
	FOR XML RAW('AccessTo'), ELEMENTS)) FOR XML RAW('FunctionAccessRight'), ELEMENTS);
	
END
SELECT @xml AS FunctionAccessRight;
SET NOCOUNT OFF;
GO
