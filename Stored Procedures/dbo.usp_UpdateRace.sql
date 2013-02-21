SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRace]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (RaceID VARCHAR(10), RaceName VARCHAR(100))
	INSERT INTO @table(RaceID, RaceName)
	Select RaceID, RaceName
	from OpenXml(@xdoc, '/Race/*')
	with (
	RaceID VARCHAR(10) './RaceID',
	RaceName VARCHAR(100) './RaceName') WHERE RaceID <> 'New';		
	
	UPDATE dbo.tb_Race SET dbo.tb_Race.RaceName = a.RaceName
	from @table AS a WHERE a.RaceID <> 'New' AND dbo.tb_Race.RaceID = a.RaceID; 
	
	DELETE FROM @table WHERE RaceID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Race 
				WHERE RaceID IN (SELECT DISTINCT Race FROM dbo.tb_ccc_kids)
				AND RaceID NOT IN (Select RaceID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_Race (RaceName)
		Select RaceName
		from OpenXml(@xdoc, '/Race/*')
		with (
		RaceID VARCHAR(10) './RaceID',
		RaceName VARCHAR(100) './RaceName') WHERE RaceID = 'New';
	
		SELECT 'Unable to delete, Race still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Race 
		WHERE RaceID NOT IN (SELECT DISTINCT Race FROM dbo.tb_ccc_kids)
		AND RaceID NOT IN (Select RaceID FROM @table)
		
		INSERT INTO dbo.tb_Race (RaceName)
		Select RaceName
		from OpenXml(@xdoc, '/Race/*')
		with (
		RaceID VARCHAR(10) './RaceID',
		RaceName VARCHAR(100) './RaceName') WHERE RaceID = 'New';
		
		SELECT 'Race updated.' AS Result
	END

SET NOCOUNT OFF;
GO
