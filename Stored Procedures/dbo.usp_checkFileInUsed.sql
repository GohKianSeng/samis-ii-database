SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_checkFileInUsed]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	
	
	DECLARE @table AS TABLE ([Filename] VARCHAR(1000), [Type] VARCHAR(100));
	INSERT INTO @table([Filename], [Type])
	Select [Filename], [Type]
	from OpenXml(@xdoc, '/Files/*')
	with (
	[Type] VARCHAR(100) './Type',
	[Filename] VARCHAR(1000) './Filename');
	
	DELETE FROM @table WHERE [Type] = 'icphotolocation' AND [Filename] IN (SELECT ICPhoto FROM dbo.tb_members WHERE LEN(ICPhoto) > 0);
	DELETE FROM @table WHERE [Type] = 'CityKidsPhotolocation' AND [Filename] IN (SELECT Photo FROM dbo.tb_ccc_kids WHERE LEN(Photo) > 0);
	DELETE FROM @table WHERE [Type] = 'temp_uploadfilesavedlocation' AND [Filename] IN (SELECT ICPhoto FROM dbo.tb_members_temp WHERE LEN(ICPhoto) > 0);
	
	DECLARE @res AS XML = (SELECT [Type], [Filename] FROM @table FOR XML PATH('File'), ELEMENTS, ROOT('Files'));
	SELECT ISNULL(@res,'<Files />') AS Res;

SET NOCOUNT OFF;
GO
