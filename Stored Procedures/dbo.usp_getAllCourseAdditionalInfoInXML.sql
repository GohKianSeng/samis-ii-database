SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllCourseAdditionalInfoInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select AgreementID, AgreementType, AgreementHTML from dbo.tb_course_agreement FOR XML PATH('AdditionalInfo'), ROOT('ChurchAdditionalInfo'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;

GO
