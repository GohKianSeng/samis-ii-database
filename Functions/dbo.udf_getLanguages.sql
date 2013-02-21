SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getLanguages]
(
	-- Add the parameters for the function here
	@languages VARCHAR(1000)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @returnlanguage VARCHAR(MAX)
	SET @returnlanguage = ''
	
	SELECT @returnlanguage = @returnlanguage + B.LanguageName + ', ' FROM dbo.udf_Split(@languages, ',') AS A
	JOIN dbo.tb_language AS B ON B.LanguageID = A.Items

	RETURN @returnlanguage
END
GO
