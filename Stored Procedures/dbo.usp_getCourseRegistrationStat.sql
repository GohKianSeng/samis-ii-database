SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseRegistrationStat]
(@FromYear VARCHAR(4), @FromMonth VARCHAR(100))
AS
SET NOCOUNT ON;

SELECT B.CourseName, COUNT(NRIC) AS Registered  FROM  [dbo].[tb_course] AS B
LEFT OUTER JOIN [dbo].[tb_course_participant] AS A ON A.courseID = B.courseID
WHERE B.courseID IN (
	SELECT DISTINCT C.courseID FROM [dbo].[tb_course] AS C 
	CROSS APPLY(
		SELECT  CONVERT(DATE, items, 103) AS CourseDate from [dbo].[udf_Split]([CourseStartDate], ',')
	) AS A
	WHERE (Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear OR Year([dbo].[udf_getEndDate]([CourseStartDate])) = @FromYear)
	AND Month(A.CourseDate) IN (SELECT items FROM [dbo].[udf_Split](@FromMonth, ','))
)
GROUP BY B.courseID, B.CourseName
ORDER BY B.CourseName

SET NOCOUNT OFF;
GO
