SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdatePostal]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (DISTRICT INT, PostalAreaName VARCHAR(200), PostalDigit VARCHAR(200))
	DECLARE @newtable AS TABLE (DISTRICT INT, PostalAreaName VARCHAR(200), PostalDigit VARCHAR(200))
	
	INSERT INTO @table(DISTRICT, PostalAreaName, PostalDigit)
	Select DISTRICT, PostalAreaName, PostalDigit
	from OpenXml(@xdoc, '/ChurchPostal/*')
	with (
	DISTRICT VARCHAR(10) './PostalID',
	PostalAreaName VARCHAR(200) './PostalName',
	PostalDigit VARCHAR(200) './Postalvalue') WHERE DISTRICT <> 'New';		
	
	UPDATE dbo.tb_postalArea SET dbo.tb_postalArea.PostalAreaName = A.PostalAreaName, dbo.tb_postalArea.PostalDigit = A.PostalDigit
	FROM @table AS A
	WHERE A.DISTRICT = dbo.tb_postalArea.District 
	
	DELETE FROM dbo.tb_postalArea WHERE District NOT IN (SELECT DISTRICT FROM @table)
	
	INSERT INTO dbo.tb_postalArea(PostalAreaName, PostalDigit)
	Select PostalAreaName, PostalDigit
	from OpenXml(@xdoc, '/ChurchPostal/*')
	with (
	DISTRICT VARCHAR(10) './PostalID',
	PostalAreaName VARCHAR(200) './PostalName',
	PostalDigit VARCHAR(200) './Postalvalue') WHERE DISTRICT = 'New';
	
	SELECT 'Postal updated.' AS Result

SET NOCOUNT OFF;
GO
