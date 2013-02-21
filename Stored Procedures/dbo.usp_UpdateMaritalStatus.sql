SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateMaritalStatus]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (MaritalStatusID VARCHAR(10), MaritalStatusName VARCHAR(100))
	INSERT INTO @table(MaritalStatusID, MaritalStatusName)
	Select MaritalStatusID, MaritalStatusName
	from OpenXml(@xdoc, '/ChurchMaritalStatus/*')
	with (
	MaritalStatusID VARCHAR(10) './MaritalStatusID',
	MaritalStatusName VARCHAR(100) './MaritalStatusName') WHERE MaritalStatusID <> 'New';		
	
	UPDATE dbo.tb_maritalstatus SET dbo.tb_maritalstatus.MaritalStatusName = a.MaritalStatusName
	from @table AS a WHERE a.MaritalStatusID <> 'New' AND dbo.tb_maritalstatus.MaritalStatusID = a.MaritalStatusID; 
	
	DELETE FROM @table WHERE MaritalStatusID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_maritalstatus 
				WHERE MaritalStatusID IN (SELECT DISTINCT MaritalStatus FROM tb_members)
				AND MaritalStatusID NOT IN (Select MaritalStatusID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_maritalstatus 
				WHERE MaritalStatusID IN (SELECT DISTINCT MaritalStatus FROM tb_members_temp)
				AND MaritalStatusID NOT IN (Select MaritalStatusID FROM @table))							
	BEGIN
			
		INSERT INTO dbo.tb_maritalstatus (MaritalStatusName)
		Select MaritalStatusName
		from OpenXml(@xdoc, '/ChurchMaritalStatus/*')
		with (
		MaritalStatusID VARCHAR(10) './MaritalStatusID',
		MaritalStatusName VARCHAR(100) './MaritalStatusName') WHERE MaritalStatusID = 'New';
	
		SELECT 'Unable to delete, Marital Status still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_maritalstatus 
		WHERE MaritalStatusID NOT IN (SELECT DISTINCT MaritalStatus FROM tb_members)
		AND MaritalStatusID NOT IN (SELECT DISTINCT MaritalStatus FROM tb_members_temp)
		AND MaritalStatusID NOT IN (Select MaritalStatusID FROM @table)
		
		INSERT INTO dbo.tb_maritalstatus (MaritalStatusName)
		Select MaritalStatusName
		from OpenXml(@xdoc, '/ChurchMaritalStatus/*')
		with (
		MaritalStatusID VARCHAR(10) './MaritalStatusID',
		MaritalStatusName VARCHAR(100) './MaritalStatusName') WHERE MaritalStatusID = 'New';
		
		SELECT 'MaritalStatus updated.' AS Result
	END

SET NOCOUNT OFF;
GO
