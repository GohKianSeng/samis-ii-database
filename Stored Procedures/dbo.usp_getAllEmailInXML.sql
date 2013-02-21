SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllEmailInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select EmailID, EmailType, EmailContent from dbo.tb_emailContent FOR XML PATH('Email'), ROOT('ChurchEmail'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;	

SET NOCOUNT OFF;

GO
