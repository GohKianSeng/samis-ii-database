SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Language]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./LanguageID[1]','int'), T2.Loc.value('./LanguageName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllLanguage/*') as T2(Loc)

UPDATE dbo.tb_language SET dbo.tb_language.LanguageName = A.Value1
FROM @Table AS A WHERE dbo.tb_language.LanguageID = A.ID

SET IDENTITY_INSERT dbo.tb_language ON

INSERT INTO dbo.tb_language(LanguageID, LanguageName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT LanguageID FROM dbo.tb_language)

SET IDENTITY_INSERT dbo.tb_language OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_language WHERE LanguageID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
