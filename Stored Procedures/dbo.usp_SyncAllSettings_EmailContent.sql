SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_EmailContent]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(MAX))
INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./EmailID[1]','int'), T2.Loc.value('./EmailType[1]','VARCHAR(1000)'), T2.Loc.value('./EmailContent[1]','VARCHAR(MAX)')
FROM @XML.nodes('/All/AllChurchEmail/*') as T2(Loc)

UPDATE dbo.tb_emailContent SET dbo.tb_emailContent.EmailType = A.Value1, dbo.tb_emailContent.EmailContent = A.Value2
FROM @Table AS A WHERE dbo.tb_emailContent.EmailID = A.ID

SET IDENTITY_INSERT dbo.tb_emailContent ON

INSERT INTO dbo.tb_emailContent(EmailID, EmailType, EmailContent)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT EmailID FROM dbo.tb_emailContent)

SET IDENTITY_INSERT dbo.tb_emailContent OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_emailContent WHERE EmailID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
