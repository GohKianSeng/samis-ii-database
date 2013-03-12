SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateExternalDB]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ExternalDBID INT, ExternalDBName VARCHAR(200), ExternalDBIP VARCHAR(200))
	DECLARE @newtable AS TABLE (ExternalDBID INT, ExternalDBName VARCHAR(200), ExternalDBIP VARCHAR(200))
	
	INSERT INTO @table(ExternalDBID, ExternalDBName, ExternalDBIP)
	Select ExternalDBID, ExternalDBName, ExternalDBIP
	from OpenXml(@xdoc, '/ChurchExternalDB/*')
	with (
	ExternalDBID VARCHAR(10) './ExternalDBID',
	ExternalDBIP VARCHAR(200) './ExternalDBIP',
	ExternalDBName VARCHAR(200) './ExternalDBName') WHERE ExternalDBID <> 'New';		
	
	UPDATE dbo.tb_ExternalDB SET dbo.tb_ExternalDB.ExternalDBIP = A.ExternalDBIP, dbo.tb_ExternalDB.ExternalSiteName = A.ExternalDBName
	FROM @table AS A
	WHERE A.ExternalDBID = dbo.tb_ExternalDB.ExternalDBID 
	
	DELETE FROM dbo.tb_ExternalDB WHERE ExternalDBID NOT IN (SELECT ExternalDBID FROM @table)
	
	INSERT INTO dbo.tb_ExternalDB(ExternalSiteName, ExternalDBIP)
	Select ExternalDBName, ExternalDBIP
	from OpenXml(@xdoc, '/ChurchExternalDB/*')
	with (
	ExternalDBID VARCHAR(10) './ExternalDBID',
	ExternalDBIP VARCHAR(200) './ExternalDBIP',
	ExternalDBName VARCHAR(200) './ExternalDBName') WHERE ExternalDBID = 'New';
	
	SELECT 'External DB updated.' AS Result

SET NOCOUNT OFF;

GO
