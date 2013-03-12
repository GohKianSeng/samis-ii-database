
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllEducationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select EducationID AS ID, EducationName AS Name from dbo.tb_education FOR XML PATH('Type'), ROOT('ChurchEducation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;

GO
