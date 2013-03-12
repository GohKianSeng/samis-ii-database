
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllCountryInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select CountryID AS ID, CountryName AS Name from dbo.tb_country FOR XML PATH('Type'), ROOT('ChurchCountry'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;

GO
