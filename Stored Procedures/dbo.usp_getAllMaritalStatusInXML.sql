
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllMaritalStatusInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select MaritalStatusID AS ID, MaritalStatusName AS Name from dbo.tb_maritalstatus FOR XML PATH('Type'), ROOT('ChurchMaritalStatus'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;

GO
