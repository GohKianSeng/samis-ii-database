SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getGender]
(
	-- Add the parameters for the function here
	@gender VARCHAR(1)
)
RETURNS VARCHAR(6)
AS
BEGIN

IF(@gender = 'M')
BEGIN
	RETURN 'Male'
END
ELSE
BEGIN
	RETURN 'Female'
END

RETURN ''
END
GO
