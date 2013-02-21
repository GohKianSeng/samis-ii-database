SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateChurchArea]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (AreaID VARCHAR(10), AreaName VARCHAR(100))
	INSERT INTO @table(AreaID, AreaName)
	Select AreaID, AreaName
	from OpenXml(@xdoc, '/ChurchArea/*')
	with (
	AreaID VARCHAR(10) './AreaID',
	AreaName VARCHAR(100) './AreaName') WHERE AreaID <> 'New';		
	
	UPDATE dbo.tb_churchArea SET dbo.tb_churchArea.AreaName = a.AreaName
	from @table AS a WHERE a.AreaID <> 'New' AND dbo.tb_churchArea.AreaID = a.AreaID; 
	
	DELETE FROM @table WHERE AreaID = 'New'
	
	
	if EXISTS(SELECT 1 FROM dbo.tb_churchArea 
				WHERE AreaID IN (SELECT DISTINCT CourseLocation FROM dbo.tb_course)
				AND AreaID NOT IN (Select AreaID FROM @table))
	BEGIN
		
		INSERT INTO dbo.tb_churchArea (AreaName)
		Select AreaName
		from OpenXml(@xdoc, '/ChurchArea/*')
		with (
		AreaID VARCHAR(10) './AreaID',
		AreaName VARCHAR(100) './AreaName') WHERE AreaID = 'New';
	
		SELECT 'Unable to delete, area still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_churchArea 
		WHERE AreaID NOT IN (SELECT DISTINCT CourseLocation FROM dbo.tb_course)
		AND AreaID NOT IN (Select AreaID FROM @table)
		
		INSERT INTO dbo.tb_churchArea (AreaName)
		Select AreaName
		from OpenXml(@xdoc, '/ChurchArea/*')
		with (
		AreaID VARCHAR(10) './AreaID',
		AreaName VARCHAR(100) './AreaName') WHERE AreaID = 'New';
		
		SELECT 'Area updated.' AS Result
	END

SET NOCOUNT OFF;
GO
