SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllFamilyTypeInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select FamilyTypeID AS ID, FamilyType AS Name from dbo.tb_familytype FOR XML PATH('Type'), ROOT('FamilyType'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
