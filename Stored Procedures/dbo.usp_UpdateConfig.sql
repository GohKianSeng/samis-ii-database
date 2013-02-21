SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateConfig]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (ConfigID VARCHAR(10), value VARCHAR(1000))
	INSERT INTO @table(ConfigID, value)
	Select ConfigID, value
	from OpenXml(@xdoc, '/ChurchConfig/*')
	with (
	ConfigID VARCHAR(10) './ConfigID',
	value VARCHAR(1000) './value');		
	
	UPDATE dbo.tb_App_Config SET dbo.tb_App_Config.value = A.value
	FROM @table AS A
	WHERE A.ConfigID = dbo.tb_App_Config.ConfigID
	
	SELECT 'Config updated.' AS Result

SET NOCOUNT OFF;
GO
