SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateEducation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (EducationID VARCHAR(10), EducationName VARCHAR(100))
	INSERT INTO @table(EducationID, EducationName)
	Select EducationID, EducationName
	from OpenXml(@xdoc, '/ChurchEducation/*')
	with (
	EducationID VARCHAR(10) './EducationID',
	EducationName VARCHAR(100) './EducationName') WHERE EducationID <> 'New';		
	
	UPDATE dbo.tb_education SET dbo.tb_education.EducationName = a.EducationName
	from @table AS a WHERE a.EducationID <> 'New' AND dbo.tb_education.EducationID = a.EducationID; 
	
	DELETE FROM @table WHERE EducationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_education 
				WHERE EducationID IN (SELECT DISTINCT Education FROM dbo.tb_members)
				AND EducationID NOT IN (Select EducationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_education 
				WHERE EducationID IN (SELECT DISTINCT Education FROM dbo.tb_members_temp)
				AND EducationID NOT IN (Select EducationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_education 
				WHERE EducationID IN (SELECT DISTINCT Education FROM dbo.tb_visitors)
				AND EducationID NOT IN (Select EducationID FROM @table))							
	BEGIN
			
		INSERT INTO dbo.tb_education (EducationName)
		Select EducationName
		from OpenXml(@xdoc, '/ChurchEducation/*')
		with (
		EducationID VARCHAR(10) './EducationID',
		EducationName VARCHAR(100) './EducationName') WHERE EducationID = 'New';
	
		SELECT 'Unable to delete, Education still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_education 
		WHERE EducationID NOT IN (SELECT DISTINCT Education FROM dbo.tb_members)
		AND EducationID NOT IN (SELECT DISTINCT Education FROM dbo.tb_members_temp)
		AND EducationID NOT IN (SELECT DISTINCT Education FROM dbo.tb_visitors)
		AND EducationID NOT IN (Select EducationID FROM @table)
		
		INSERT INTO dbo.tb_education (EducationName)
		Select EducationName
		from OpenXml(@xdoc, '/ChurchEducation/*')
		with (
		EducationID VARCHAR(10) './EducationID',
		EducationName VARCHAR(100) './EducationName') WHERE EducationID = 'New';
		
		SELECT 'Education updated.' AS Result
	END

SET NOCOUNT OFF;
GO
