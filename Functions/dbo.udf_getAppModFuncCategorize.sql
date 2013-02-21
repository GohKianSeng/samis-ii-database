SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getAppModFuncCategorize]
(
	-- Add the parameters for the function here
	@text_to_count VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
	
DECLARE
@last_count AS INT = 0,
@returnMessage AS VARCHAR(20);

SELECT @last_count = COUNT(*) FROM dbo.udf_Split(@text_to_count, '.')
SET @last_count = @last_count - 1


IF @last_count = 0
Begin
	set @returnMessage = NULL;
END

ELSE IF @last_count = 1
BEGIN
	set @returnMessage =  'top';
END

ELSE IF @last_count = 2
BEGIN
	set @returnMessage =  'sub';
END

ELSE
	set @returnMessage =  'fly';
	
return @returnMessage;

END
GO
