SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_CheckSAMIS1Name]
(
	-- Add the parameters for the function here
	@name VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
	
	IF(CHARINDEX('(', @name) = 1)
	BEGIN
		RETURN LTRIM(RTRIM(SUBSTRING(@name, CHARINDEX(')', @name)+1, 99)))
	END 
	
	return @name
	
END
GO
