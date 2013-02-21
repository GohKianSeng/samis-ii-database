SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateParish]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ParishID VARCHAR(10), ParishName VARCHAR(100))
	INSERT INTO @table(ParishID, ParishName)
	Select ParishID, ParishName
	from OpenXml(@xdoc, '/ChurchParish/*')
	with (
	ParishID VARCHAR(10) './ParishID',
	ParishName VARCHAR(100) './ParishName') WHERE ParishID <> 'New';		
	
	UPDATE dbo.tb_parish SET dbo.tb_parish.ParishName = a.ParishName
	from @table AS a WHERE a.ParishID <> 'New' AND dbo.tb_Parish.ParishID = a.ParishID; 
	
	DELETE FROM @table WHERE ParishID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_parish 
				WHERE ParishID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
				AND ParishID NOT IN (Select ParishID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_Parish 
				WHERE ParishID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members_temp FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
				AND ParishID NOT IN (Select ParishID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_parish (ParishName)
		Select ParishName
		from OpenXml(@xdoc, '/ChurchParish/*')
		with (
		ParishID VARCHAR(10) './ParishID',
		ParishName VARCHAR(100) './ParishName') WHERE ParishID = 'New';
	
		SELECT 'Unable to delete, Parish still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_parish 
		WHERE ParishID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members_temp FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
		AND ParishID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((select ConfirmChurch AS x, BaptismChurch AS y, PreviousChurch AS z from tb_members FOR XML PATH('a'), ELEMENTS), '</x><y>', ','), '</y><z>', ','), '</z></a><a><x>', ','), '<a><x>', ''), '</z></a>', ''), ','))
		AND ParishID NOT IN (Select ParishID FROM @table)
		
		INSERT INTO dbo.tb_parish (ParishName)
		Select ParishName
		from OpenXml(@xdoc, '/ChurchParish/*')
		with (
		ParishID VARCHAR(10) './ParishID',
		ParishName VARCHAR(100) './ParishName') WHERE ParishID = 'New';
		
		SELECT 'Parish updated.' AS Result
	END

SET NOCOUNT OFF;
GO
