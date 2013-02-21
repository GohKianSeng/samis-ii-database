SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getDialect]
(
	-- Add the parameters for the function here
	@dialect tinyint
)
RETURNS VARCHAR(20)
AS
BEGIN

	DECLARE @res VARCHAR(100)
	SELECT @res = DialectName FROM dbo.tb_dialect WHERE DialectID = @dialect
	return @res
END
GO
