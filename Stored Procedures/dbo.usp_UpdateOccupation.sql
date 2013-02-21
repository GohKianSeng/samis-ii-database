SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateOccupation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (OccupationID VARCHAR(10), OccupationName VARCHAR(100))
	INSERT INTO @table(OccupationID, OccupationName)
	Select OccupationID, OccupationName
	from OpenXml(@xdoc, '/ChurchOccupation/*')
	with (
	OccupationID VARCHAR(10) './OccupationID',
	OccupationName VARCHAR(100) './OccupationName') WHERE OccupationID <> 'New';		
	
	UPDATE dbo.tb_occupation SET dbo.tb_Occupation.OccupationName = a.OccupationName
	from @table AS a WHERE a.OccupationID <> 'New' AND dbo.tb_Occupation.OccupationID = a.OccupationID; 
	
	DELETE FROM @table WHERE OccupationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_occupation 
				WHERE OccupationID IN (SELECT DISTINCT Occupation FROM dbo.tb_members)
				AND OccupationID NOT IN (Select OccupationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_occupation 
				WHERE OccupationID IN (SELECT DISTINCT Occupation FROM dbo.tb_members_temp)
				AND OccupationID NOT IN (Select OccupationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_occupation 
				WHERE OccupationID IN (SELECT DISTINCT Occupation FROM dbo.tb_visitors)
				AND OccupationID NOT IN (Select OccupationID FROM @table))				
	BEGIN
		
		INSERT INTO dbo.tb_occupation (OccupationName)
		Select OccupationName
		from OpenXml(@xdoc, '/ChurchOccupation/*')
		with (
		OccupationID VARCHAR(10) './OccupationID',
		OccupationName VARCHAR(100) './OccupationName') WHERE OccupationID = 'New';
	
		SELECT 'Unable to delete, Occupation still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_occupation 
		WHERE OccupationID NOT IN (SELECT DISTINCT Occupation FROM dbo.tb_members)
		AND OccupationID NOT IN (SELECT DISTINCT Occupation FROM dbo.tb_members_temp)
		AND OccupationID NOT IN (SELECT DISTINCT Occupation FROM dbo.tb_visitors)
		AND OccupationID NOT IN (Select OccupationID FROM @table)
		
		INSERT INTO dbo.tb_occupation (OccupationName)
		Select OccupationName
		from OpenXml(@xdoc, '/ChurchOccupation/*')
		with (
		OccupationID VARCHAR(10) './OccupationID',
		OccupationName VARCHAR(100) './OccupationName') WHERE OccupationID = 'New';
		
		SELECT 'Occupation updated.' AS Result
	END

SET NOCOUNT OFF;
GO
