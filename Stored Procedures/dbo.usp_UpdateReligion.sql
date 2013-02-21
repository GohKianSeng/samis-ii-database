SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateReligion]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ReligionID VARCHAR(10), ReligionName VARCHAR(100))
	INSERT INTO @table(ReligionID, ReligionName)
	Select ReligionID, ReligionName
	from OpenXml(@xdoc, '/Religion/*')
	with (
	ReligionID VARCHAR(10) './ReligionID',
	ReligionName VARCHAR(100) './ReligionName') WHERE ReligionID <> 'New';		
	
	UPDATE dbo.tb_Religion SET dbo.tb_Religion.ReligionName = a.ReligionName
	from @table AS a WHERE a.ReligionID <> 'New' AND dbo.tb_Religion.ReligionID = a.ReligionID; 
	
	DELETE FROM @table WHERE ReligionID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Religion 
				WHERE ReligionID IN (SELECT DISTINCT Religion FROM dbo.tb_ccc_kids)
				AND ReligionID NOT IN (Select ReligionID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_Religion (ReligionName)
		Select ReligionName
		from OpenXml(@xdoc, '/Religion/*')
		with (
		ReligionID VARCHAR(10) './ReligionID',
		ReligionName VARCHAR(100) './ReligionName') WHERE ReligionID = 'New';
	
		SELECT 'Unable to delete, Religion still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Religion 
		WHERE ReligionID NOT IN (SELECT DISTINCT Religion FROM dbo.tb_ccc_kids)
		AND ReligionID NOT IN (Select ReligionID FROM @table)
		
		INSERT INTO dbo.tb_Religion (ReligionName)
		Select ReligionName
		from OpenXml(@xdoc, '/Religion/*')
		with (
		ReligionID VARCHAR(10) './ReligionID',
		ReligionName VARCHAR(100) './ReligionName') WHERE ReligionID = 'New';
		
		SELECT 'Religion updated.' AS Result
	END

SET NOCOUNT OFF;
GO
