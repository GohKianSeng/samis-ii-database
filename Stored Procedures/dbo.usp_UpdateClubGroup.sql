SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateClubGroup]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ClubGroupID VARCHAR(10), ClubGroupName VARCHAR(100))
	INSERT INTO @table(ClubGroupID, ClubGroupName)
	Select ClubGroupID, ClubGroupName
	from OpenXml(@xdoc, '/ClubGroup/*')
	with (
	ClubGroupID VARCHAR(10) './ClubGroupID',
	ClubGroupName VARCHAR(100) './ClubGroupName') WHERE ClubGroupID <> 'New';		
	
	UPDATE dbo.tb_clubgroup SET dbo.tb_clubgroup.ClubGroupName = a.ClubGroupName
	from @table AS a WHERE a.ClubGroupID <> 'New' AND dbo.tb_clubgroup.ClubGroupID = a.ClubGroupID; 
	
	DELETE FROM @table WHERE ClubGroupID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_clubgroup 
				WHERE ClubGroupID IN (SELECT DISTINCT ClubGroup FROM dbo.tb_ccc_kids)
				AND ClubGroupID NOT IN (Select ClubGroupID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_clubgroup (ClubGroupName)
		Select ClubGroupName
		from OpenXml(@xdoc, '/ClubGroup/*')
		with (
		ClubGroupID VARCHAR(10) './ClubGroupID',
		ClubGroupName VARCHAR(100) './ClubGroupName') WHERE ClubGroupID = 'New';
	
		SELECT 'Unable to delete, ClubGroup still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_clubgroup 
		WHERE ClubGroupID NOT IN (SELECT DISTINCT ClubGroup FROM dbo.tb_ccc_kids)
		AND ClubGroupID NOT IN (Select ClubGroupID FROM @table)
		
		INSERT INTO dbo.tb_clubgroup (ClubGroupName)
		Select ClubGroupName
		from OpenXml(@xdoc, '/ClubGroup/*')
		with (
		ClubGroupID VARCHAR(10) './ClubGroupID',
		ClubGroupName VARCHAR(100) './ClubGroupName') WHERE ClubGroupID = 'New';
		
		SELECT 'ClubGroup updated.' AS Result
	END

SET NOCOUNT OFF;
GO
