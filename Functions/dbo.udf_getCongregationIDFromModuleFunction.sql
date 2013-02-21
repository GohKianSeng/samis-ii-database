SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getCongregationIDFromModuleFunction]
(
	-- Add the parameters for the function here
	@string VARCHAR(100)
)
RETURNS VARCHAR(3)
AS
BEGIN

return SUBSTRING(@string, CHARINDEX(':', @string)+1, CHARINDEX(',', @string) - CHARINDEX(':', @string)-1);

END
GO
