SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_FileType]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./FileTypeID[1]','int'), T2.Loc.value('./FileTypeName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllFileType/*') as T2(Loc)

UPDATE dbo.tb_file_type SET dbo.tb_file_type.FileType = A.Value1
FROM @Table AS A WHERE dbo.tb_file_type.FileTypeID = A.ID

SET IDENTITY_INSERT dbo.tb_file_type ON

INSERT INTO dbo.tb_file_type(FileTypeID, FileType)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT FileTypeID FROM dbo.tb_file_type)

SET IDENTITY_INSERT dbo.tb_file_type OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_file_type WHERE FileTypeID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
