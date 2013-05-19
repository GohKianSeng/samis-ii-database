SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateAdditionalInfo]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (AgreementID VARCHAR(10), AgreementType VARCHAR(100), AgreementHTML VARCHAR(MAX))
	INSERT INTO @table(AgreementID, AgreementType, AgreementHTML)
	Select AgreementID, AgreementType, AgreementHTML
	from OpenXml(@xdoc, '/ChurchAdditionalInfo/*')
	with (
	AgreementID VARCHAR(10) './AgreementID',
	AgreementType VARCHAR(100) './AgreementType',
	AgreementHTML VARCHAR(MAX) './AgreementHTML');		
	
	UPDATE dbo.tb_course_agreement SET AgreementHTML = A.AgreementHTML, AgreementType = A.AgreementType
	FROM @table AS A
	WHERE A.AgreementID = dbo.tb_course_agreement.AgreementID
	
	SELECT 'Additional Information updated.' AS Result

SET NOCOUNT OFF;

GO
