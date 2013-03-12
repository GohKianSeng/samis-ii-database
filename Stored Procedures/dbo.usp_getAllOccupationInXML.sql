
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllOccupationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select OccupationID AS ID, OccupationName AS Name from dbo.tb_occupation FOR XML PATH('Type'), ROOT('ChurchOccupation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;

GO
