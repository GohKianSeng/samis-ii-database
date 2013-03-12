SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllExternalDBInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML AS XML = (select ExternalDBID, ExternalSiteName, ExternalDBIP from dbo.tb_ExternalDB FOR XML PATH('Site'), ROOT('ExternalDB'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	
SET NOCOUNT OFF;

GO
