SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_isCourseStillRunning]
(
	@startdate VARCHAR(2000),
	@todayDate DATETIME
)
RETURNS INT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM dbo.udf_Split(@startdate, ',') WHERE CONVERT(DATETIME, ITEMS, 103) >= @todayDate)
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
