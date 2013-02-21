SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getStafforMemberName]
(
	-- Add the parameters for the function here
	@nric VARCHAR(10)
)
RETURNS VARCHAR(100)
AS
BEGIN
DECLARE @name VARCHAR(100)

IF EXISTS(SELECT * FROM dbo.tb_Users WHERE Nric = @nric)
BEGIN
	SELECT @name = RTRIM(LTRIM(ISNULL(B.StyleName,'') + ' ' + Name)) FROM dbo.tb_Users AS A
	LEFT OUTER JOIN dbo.tb_style AS B ON A.Style = B.StyleID
	WHERE A.NRIC = @nric
END
ELSE
BEGIN
	SELECT @name = SalutationName + ' ' + EnglishName FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_Salutation AS B ON A.Salutation = B.SalutationID
	WHERE NRIC = @nric
END

RETURN @name
END
GO
