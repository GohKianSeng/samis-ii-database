SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllMaritalStatusInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select MaritalStatusID, MaritalStatusName from dbo.tb_maritalstatus FOR XML PATH('MaritalStatus'), ROOT('ChurchMaritalStatus'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
