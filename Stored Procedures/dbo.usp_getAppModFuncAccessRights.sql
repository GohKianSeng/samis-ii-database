SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAppModFuncAccessRights]
(@UserID VARCHAR(50))
AS
SET NOCOUNT ON;
DECLARE @RoleTable AS TABLE(RoleID INT);
--DECLARE @MyOwnTable AS LocationTableType;
DECLARE @MyOwnTable AS TABLE(AppModFuncID VARCHAR(20))
DECLARE @MyOwnTableString VARCHAR(MAX)

INSERT INTO @RoleTable
SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID=@UserID;

IF NOT EXISTS(SELECT 1 FROM @RoleTable)
BEGIN
	INSERT INTO @RoleTable
	SELECT -1;
END

INSERT INTO @MyOwnTable (AppModFuncID)
SELECT AppModFuncID FROM dbo.tb_Roles_AMF_AccessRights WHERE RoleID IN(SELECT RoleID FROM @RoleTable);

SELECT @MyOwnTableString = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),(
	SELECT AppModFuncID AS a FROM @MyOwnTable FOR XML PATH('')
)), '</a><a>', ','), '</a>', ''), '<a>', '')


INSERT INTO @MyOwnTable
EXEC [dbo].[usp_getPredcessor] @MyOwnTableString;

SELECT dbo.udf_getAppModFuncPredcessor(AppModFuncID) AS PredcessorID, 
         dbo.udf_getAppModFuncCategorize(AppModFuncID) AS GroupID, 
         AppModFuncID, 
         AppModFuncName, 
         URL, 
         Sequence 
FROM dbo.tb_AppModFunc WHERE dbo.udf_getAppModFuncPredcessor(AppModFuncID) <> 'NULL' 
AND AppModFuncID IN (SELECT DISTINCT * FROM @MyOwnTable WHERE AppModFuncID <> 'NULL') 
ORDER BY PredcessorID, Sequence;
SET NOCOUNT OFF;
GO
