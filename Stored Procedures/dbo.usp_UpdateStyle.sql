SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateStyle]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (StyleID VARCHAR(10), StyleName VARCHAR(100))
	INSERT INTO @table(StyleID, StyleName)
	Select StyleID, StyleName
	from OpenXml(@xdoc, '/ChurchStyle/*')
	with (
	StyleID VARCHAR(10) './StyleID',
	StyleName VARCHAR(100) './StyleName') WHERE StyleID <> 'New';		
	
	UPDATE dbo.tb_Style SET dbo.tb_Style.StyleName = a.StyleName
	from @table AS a WHERE a.StyleID <> 'New' AND dbo.tb_Style.StyleID = a.StyleID; 
	
	DELETE FROM @table WHERE StyleID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Style 
				WHERE StyleID IN (SELECT DISTINCT Style FROM dbo.tb_Users)
				AND StyleID NOT IN (Select StyleID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_Style (StyleName)
		Select StyleName
		from OpenXml(@xdoc, '/ChurchStyle/*')
		with (
		StyleID VARCHAR(10) './StyleID',
		StyleName VARCHAR(100) './StyleName') WHERE StyleID = 'New';
	
		SELECT 'Unable to delete, Style still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Style 
		WHERE StyleID NOT IN (SELECT DISTINCT ISNULL(Style,0) FROM dbo.tb_Users)
		AND StyleID NOT IN (Select StyleID FROM @table)
		
		INSERT INTO dbo.tb_Style (StyleName)
		Select StyleName
		from OpenXml(@xdoc, '/ChurchStyle/*')
		with (
		StyleID VARCHAR(10) './StyleID',
		StyleName VARCHAR(100) './StyleName') WHERE StyleID = 'New';
		
		SELECT 'Style updated.' AS Result
	END

SET NOCOUNT OFF;
GO
