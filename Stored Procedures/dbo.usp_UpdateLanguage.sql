SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateLanguage]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (LanguageID VARCHAR(10), LanguageName VARCHAR(100))
	INSERT INTO @table(LanguageID, LanguageName)
	Select LanguageID, LanguageName
	from OpenXml(@xdoc, '/ChurchLanguage/*')
	with (
	LanguageID VARCHAR(10) './LanguageID',
	LanguageName VARCHAR(100) './LanguageName') WHERE LanguageID <> 'New';		
	
	UPDATE dbo.tb_language SET dbo.tb_language.LanguageName = a.LanguageName
	from @table AS a WHERE a.LanguageID <> 'New' AND dbo.tb_language.LanguageID = a.LanguageID; 
	
	DELETE FROM @table WHERE LanguageID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_language 
				WHERE LanguageID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
				AND LanguageID NOT IN (Select LanguageID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_language 
				WHERE LanguageID IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members_temp FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
				AND LanguageID NOT IN (Select LanguageID FROM @table))							
	BEGIN
			
		INSERT INTO dbo.tb_language (LanguageName)
		Select LanguageName
		from OpenXml(@xdoc, '/ChurchLanguage/*')
		with (
		LanguageID VARCHAR(10) './LanguageID',
		LanguageName VARCHAR(100) './LanguageName') WHERE LanguageID = 'New';
	
		SELECT 'Unable to delete, Language still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Language 
		WHERE LanguageID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
		AND LanguageID NOT IN (SELECT DISTINCT ITEMS FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((SELECT [Language] AS a FROM dbo.tb_members_temp FOR XML PATH('b'), ELEMENTS), '<b>' , ''), '</b>', ''), '</a><a>', ','), '<a>', ''), '</a>' ,''), ','))
		AND LanguageID NOT IN (Select LanguageID FROM @table)
		
		INSERT INTO dbo.tb_Language (LanguageName)
		Select LanguageName
		from OpenXml(@xdoc, '/ChurchLanguage/*')
		with (
		LanguageID VARCHAR(10) './LanguageID',
		LanguageName VARCHAR(100) './LanguageName') WHERE LanguageID = 'New';
		
		SELECT 'Language updated.' AS Result
	END

SET NOCOUNT OFF;
GO
