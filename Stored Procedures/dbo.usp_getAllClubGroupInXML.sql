SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllClubGroupInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select ClubGroupID AS ID, ClubGroupName AS Name from dbo.tb_clubgroup FOR XML PATH('Type'), ROOT('ClubGroup'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO