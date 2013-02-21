SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getEducation]
(
	-- Add the parameters for the function here
	@education INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN

DECLARE @res VARCHAR(100)
SELECT @res = EducationName FROM dbo.tb_education WHERE EducationID = @education

RETURN @res
END
GO
