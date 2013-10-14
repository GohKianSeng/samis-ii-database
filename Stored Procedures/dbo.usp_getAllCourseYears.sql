SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCourseYears]

AS
SET NOCOUNT ON;

	  DECLARE @allDate VARCHAR(MAX) = ''
	  SELECT @allDate = @allDate + [CourseStartDate] + ',' FROM [dbo].[tb_course]
      SELECT DISTINCT YEAR(CONVERT(DATE, items, 103)) AS Year FROM [dbo].[udf_Split](@allDate,',')
	

SET NOCOUNT OFF;
GO
