SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateSchool]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (SchoolID VARCHAR(10), SchoolName VARCHAR(100))
	INSERT INTO @table(SchoolID, SchoolName)
	Select SchoolID, SchoolName
	from OpenXml(@xdoc, '/School/*')
	with (
	SchoolID VARCHAR(10) './SchoolID',
	SchoolName VARCHAR(100) './SchoolName') WHERE SchoolID <> 'New';		
	
	UPDATE dbo.tb_School SET dbo.tb_School.SchoolName = a.SchoolName
	from @table AS a WHERE a.SchoolID <> 'New' AND dbo.tb_School.SchoolID = a.SchoolID; 
	
	DELETE FROM @table WHERE SchoolID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_School 
				WHERE SchoolID IN (SELECT DISTINCT School FROM dbo.tb_ccc_kids)
				AND SchoolID NOT IN (Select SchoolID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_School (SchoolName)
		Select SchoolName
		from OpenXml(@xdoc, '/School/*')
		with (
		SchoolID VARCHAR(10) './SchoolID',
		SchoolName VARCHAR(100) './SchoolName') WHERE SchoolID = 'New';
	
		SELECT 'Unable to delete, School still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_School 
		WHERE SchoolID NOT IN (SELECT DISTINCT School FROM dbo.tb_ccc_kids)
		AND SchoolID NOT IN (Select SchoolID FROM @table)
		
		INSERT INTO dbo.tb_School (SchoolName)
		Select SchoolName
		from OpenXml(@xdoc, '/School/*')
		with (
		SchoolID VARCHAR(10) './SchoolID',
		SchoolName VARCHAR(100) './SchoolName') WHERE SchoolID = 'New';
		
		SELECT 'School updated.' AS Result
	END

SET NOCOUNT OFF;
GO
