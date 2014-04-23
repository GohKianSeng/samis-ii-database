SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_isCourseConductedInYear]
(
	@startdate VARCHAR(2000),
	@Year INT
)
RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT 1 WHERE DATEPART(YEAR, CONVERT(DATE, (SELECT TOP 1 CONVERT(DATE, items, 103) FROM dbo.udf_Split(@startdate, ',') ORDER BY CONVERT(DATE, items, 103) ASC), 103)) = @Year)
	BEGIN
		return 1;
	END
	ELSE
	BEGIN
		RETURN 0;
	END
	RETURN 0;
END


GO
