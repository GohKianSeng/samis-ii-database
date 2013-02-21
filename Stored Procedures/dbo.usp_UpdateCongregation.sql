SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCongregation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (CongregationID VARCHAR(10), CongregationName VARCHAR(100))
	INSERT INTO @table(CongregationID, CongregationName)
	Select CongregationID, CongregationName
	from OpenXml(@xdoc, '/ChurchCongregation/*')
	with (
	CongregationID VARCHAR(10) './CongregationID',
	CongregationName VARCHAR(100) './CongregationName') WHERE CongregationID <> 'New';		
	
	UPDATE dbo.tb_congregation SET dbo.tb_congregation.CongregationName = a.CongregationName
	from @table AS a WHERE a.CongregationID <> 'New' AND dbo.tb_congregation.CongregationID = a.CongregationID; 
	
	---------------------------------------
	--- update Module function ------------
	---------------------------------------	
	UPDATE
		dbo.tb_ModulesFunctions
	SET
		dbo.tb_ModulesFunctions.functionName = 'Congregation:' + Convert(VARCHAR(3),B.CongregationID) + ', ' + B.CongregationName
	FROM dbo.tb_ModulesFunctions AS A
	INNER JOIN dbo.tb_congregation AS B ON B.CongregationID = dbo.udf_getCongregationIDFromModuleFunction(A.functionName)
	where A.Module = 'Congregation'
	---------------------------------------
	---------------------------------------
	---------------------------------------
	
	DELETE FROM @table WHERE CongregationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_congregation 
				WHERE CongregationID IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo)
				AND CongregationID NOT IN (Select CongregationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_congregation 
				WHERE CongregationID IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo_temp)
				AND CongregationID NOT IN (Select CongregationID FROM @table))
	BEGIN
		
		INSERT INTO dbo.tb_congregation (CongregationName)
		Select CongregationName
		from OpenXml(@xdoc, '/ChurchCongregation/*')
		with (
		CongregationID VARCHAR(10) './CongregationID',
		CongregationName VARCHAR(100) './CongregationName') WHERE CongregationID = 'New';
		
		---------------------------------------
		--- insert Module function ------------
		---------------------------------------
		INSERT INTO dbo.tb_ModulesFunctions(Module, functionName)
		SELECT 'Congregation', 'Congregation:' + CONVERT(VARCHAR(3), CongregationID) + ', ' + CongregationName FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT dbo.udf_getCongregationIDFromModuleFunction(functionName) FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation')
		---------------------------------------
		---------------------------------------
		---------------------------------------
		
		SELECT 'Unable to delete, congregation still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_congregation 
		WHERE CongregationID NOT IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo)
		AND CongregationID NOT IN (SELECT DISTINCT Congregation FROM dbo.tb_membersOtherInfo_temp)
		AND CongregationID NOT IN (Select CongregationID FROM @table)
		
		---------------------------------------
		--- delete Module function ------------
		---------------------------------------
		DELETE FROM dbo.tb_Roles_ModulesFunctionsAccessRight WHERE functionID IN (
		SELECT functionID
		FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation' AND dbo.udf_getCongregationIDFromModuleFunction(functionName) NOT IN (SELECT CongregationID FROM dbo.tb_congregation)
		AND LEN(dbo.udf_getCongregationIDFromModuleFunction(functionName)) <> 0)

		DELETE
		FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation' AND dbo.udf_getCongregationIDFromModuleFunction(functionName) NOT IN (SELECT CongregationID FROM dbo.tb_congregation)
		AND LEN(dbo.udf_getCongregationIDFromModuleFunction(functionName)) <> 0
		---------------------------------------
		---------------------------------------
		---------------------------------------
		
		
		INSERT INTO dbo.tb_congregation (CongregationName)
		Select CongregationName
		from OpenXml(@xdoc, '/ChurchCongregation/*')
		with (
		CongregationID VARCHAR(10) './CongregationID',
		CongregationName VARCHAR(100) './CongregationName') WHERE CongregationID = 'New';
		
		---------------------------------------
		--- insert Module function ------------
		---------------------------------------
		INSERT INTO dbo.tb_ModulesFunctions(Module, functionName)
		SELECT 'Congregation', 'Congregation:' + CONVERT(VARCHAR(3), CongregationID) + ', ' + CongregationName FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT dbo.udf_getCongregationIDFromModuleFunction(functionName) FROM dbo.tb_ModulesFunctions WHERE Module = 'Congregation')
		---------------------------------------
		---------------------------------------
		---------------------------------------
		
		SELECT 'Congregation updated.' AS Result
	END

SET NOCOUNT OFF;
GO
