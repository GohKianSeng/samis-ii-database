SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllPostalAreaInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select District, PostalAreaName, PostalDigit from dbo.tb_postalArea FOR XML PATH('Postal'), ROOT('ChurchPostal'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;
GO
