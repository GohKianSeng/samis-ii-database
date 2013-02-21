SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateDialect]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (DialectID VARCHAR(10), DialectName VARCHAR(100))
	INSERT INTO @table(DialectID, DialectName)
	Select DialectID, DialectName
	from OpenXml(@xdoc, '/ChurchDialect/*')
	with (
	DialectID VARCHAR(10) './DialectID',
	DialectName VARCHAR(100) './DialectName') WHERE DialectID <> 'New';		
	
	UPDATE dbo.tb_dialect SET dbo.tb_dialect.DialectName = a.DialectName
	from @table AS a WHERE a.DialectID <> 'New' AND dbo.tb_dialect.DialectID = a.DialectID; 
	
	DELETE FROM @table WHERE DialectID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_dialect 
				WHERE DialectID IN (SELECT DISTINCT Dialect FROM dbo.tb_members)
				AND DialectID NOT IN (Select DialectID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_dialect 
				WHERE DialectID IN (SELECT DISTINCT Dialect FROM dbo.tb_members_temp)
				AND DialectID NOT IN (Select DialectID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_dialect (DialectName)
		Select DialectName
		from OpenXml(@xdoc, '/ChurchDialect/*')
		with (
		DialectID VARCHAR(10) './DialectID',
		DialectName VARCHAR(100) './DialectName') WHERE DialectID = 'New';
	
		SELECT 'Unable to delete, dialect still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_dialect 
		WHERE DialectID NOT IN (SELECT DISTINCT Dialect FROM dbo.tb_members)
		AND DialectID NOT IN (SELECT DISTINCT Dialect FROM dbo.tb_members_temp)
		AND DialectID NOT IN (Select DialectID FROM @table)
		
		INSERT INTO dbo.tb_dialect (DialectName)
		Select DialectName
		from OpenXml(@xdoc, '/ChurchDialect/*')
		with (
		DialectID VARCHAR(10) './DialectID',
		DialectName VARCHAR(100) './DialectName') WHERE DialectID = 'New';
		
		SELECT 'Dialect updated.' AS Result
	END

SET NOCOUNT OFF;
GO
