SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateFamilyType]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (FamilyTypeID VARCHAR(10), FamilyTypeName VARCHAR(200))
	INSERT INTO @table(FamilyTypeID, FamilyTypeName)
	Select FamilyTypeID, FamilyTypeName
	from OpenXml(@xdoc, '/FamilyType/*')
	with (
	FamilyTypeID VARCHAR(10) './FamilyTypeID',
	FamilyTypeName VARCHAR(200) './FamilyTypeName') WHERE FamilyTypeID <> 'New';		
	
	UPDATE dbo.tb_FamilyType SET dbo.tb_FamilyType.FamilyType = a.FamilyTypeName
	from @table AS a WHERE a.FamilyTypeID <> 'New' AND dbo.tb_FamilyType.FamilyTypeID = a.FamilyTypeID; 
	
	DELETE FROM @table WHERE FamilyTypeID = 'New'
	
	
	DELETE FROM dbo.tb_FamilyType 
	WHERE FamilyTypeID NOT IN (Select FamilyTypeID FROM @table)
	
	INSERT INTO dbo.tb_FamilyType (FamilyType)
	Select FamilyTypeName
	from OpenXml(@xdoc, '/FamilyType/*')
	with (
	FamilyTypeID VARCHAR(10) './FamilyTypeID',
	FamilyTypeName VARCHAR(200) './FamilyTypeName') WHERE FamilyTypeID = 'New';
	
	SELECT 'FamilyType updated.' AS Result
	

SET NOCOUNT OFF;
GO
