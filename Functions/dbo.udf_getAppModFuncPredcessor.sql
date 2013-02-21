SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getAppModFuncPredcessor]
(
	-- Add the parameters for the function here
	@text_to_count VARCHAR(20)
)
RETURNS VARCHAR(20)
AS
BEGIN
	
DECLARE
@delim as VARCHAR(1) = '.',
@pos AS INT = 0,
@contains AS INT = 1, 
@last_count AS INT = 0,
@returnMessage AS VARCHAR(20);
WHILE @pos < LEN(@text_to_count)
BEGIN
  SET @contains = CHARINDEX(@delim, @text_to_count, @pos + 1); 
  
  IF @contains > 0
  BEGIN
	SET @last_count = @contains;
  end
  SET @pos = @pos + 1;
  
END
IF @last_count = 0
Begin
	set @returnMessage = NULL;
END
ELSE
	set @returnMessage =  SUBSTRING (@text_to_count, 1, @last_count-1);

return @returnMessage;

END
GO
