
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllCongregationInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML AS XML = (select CongregationID AS ID, CongregationName AS Name from dbo.tb_congregation FOR XML PATH('Type'), ROOT('ChurchCongregation'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;

GO
