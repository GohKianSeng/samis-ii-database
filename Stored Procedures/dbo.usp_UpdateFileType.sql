SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateFileType]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (FileTypeID VARCHAR(10), FileTypeName VARCHAR(200))
	INSERT INTO @table(FileTypeID, FileTypeName)
	Select FileTypeID, FileTypeName
	from OpenXml(@xdoc, '/FileType/*')
	with (
	FileTypeID VARCHAR(10) './FileTypeID',
	FileTypeName VARCHAR(200) './FileTypeName') WHERE FileTypeID <> 'New';		
	
	UPDATE dbo.tb_File_Type SET dbo.tb_File_Type.FileType = a.FileTypeName
	from @table AS a WHERE a.FileTypeID <> 'New' AND dbo.tb_File_Type.FileTypeID = a.FileTypeID; 
	
	DELETE FROM @table WHERE FileTypeID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_File_Type 
				WHERE FileTypeID IN (SELECT DISTINCT FileType FROM dbo.tb_members_attachments)
				AND FileTypeID NOT IN (Select FileTypeID FROM @table))			
	BEGIN
			
		INSERT INTO dbo.tb_File_Type (FileType)
		Select FileTypeName
		from OpenXml(@xdoc, '/FileType/*')
		with (
		FileTypeID VARCHAR(10) './FileTypeID',
		FileTypeName VARCHAR(200) './FileTypeName') WHERE FileTypeID = 'New';
	
		SELECT 'Unable to delete, FileType still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_File_Type 
		WHERE FileTypeID NOT IN (SELECT DISTINCT FileType FROM dbo.tb_members_attachments)
		AND FileTypeID NOT IN (Select FileTypeID FROM @table)
		
		INSERT INTO dbo.tb_File_Type (FileType)
		Select FileTypeName
		from OpenXml(@xdoc, '/FileType/*')
		with (
		FileTypeID VARCHAR(10) './FileTypeID',
		FileTypeName VARCHAR(200) './FileTypeName') WHERE FileTypeID = 'New';
		
		SELECT 'FileType updated.' AS Result
	END

SET NOCOUNT OFF;
GO
