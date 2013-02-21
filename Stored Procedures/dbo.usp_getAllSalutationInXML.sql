SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSalutationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select SalutationID, SalutationName from dbo.tb_Salutation FOR XML PATH('Salutation'), ROOT('ChurchSalutation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
