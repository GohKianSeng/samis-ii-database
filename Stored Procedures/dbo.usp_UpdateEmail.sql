SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateEmail]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (EmailID VARCHAR(10), EmailContent VARCHAR(MAX))
	INSERT INTO @table(EmailID, EmailContent)
	Select EmailID, EmailContent
	from OpenXml(@xdoc, '/ChurchEmail/*')
	with (
	EmailID VARCHAR(10) './EmailID',
	EmailContent VARCHAR(MAX) './EmailContent');		
	
	UPDATE dbo.tb_emailContent SET dbo.tb_emailContent.EmailContent = A.EmailContent
	FROM @table AS A
	WHERE A.EmailID = dbo.tb_emailContent.EmailID
	
	SELECT 'Email updated.' AS Result

SET NOCOUNT OFF;

GO
