SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllEducationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select EducationID, EducationName from dbo.tb_education FOR XML PATH('Education'), ROOT('ChurchEducation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
