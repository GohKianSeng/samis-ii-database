SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllParishInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select ParishID, ParishName from dbo.tb_parish FOR XML PATH('Parish'), ROOT('ChurchParish'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
