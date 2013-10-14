SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getStartDate]
(
	-- Add the parameters for the function here
	@date VARCHAR(MAX)
)
RETURNS DATE
AS
BEGIN

DECLARE @myDate DATE = (
	SELECT TOP 1 CONVERT(DATE, items, 103) AS MyDate FROM [dbo].[udf_Split](@date, ',')
	ORDER BY MyDate ASC);

RETURN @myDate;
END
GO
