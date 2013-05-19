
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getListofCourse]
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT courseID, CourseName, REPLACE(CourseStartDate, ',', ', ')AS CourseStartDate, CourseEndDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name FROM dbo.tb_course AS A
LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
WHERE dbo.udf_isCourseStillRunning(CourseStartDate, @today) = 1 AND A.Deleted = 0 AND @today <= LastRegistrationDate
ORDER BY CourseName ASC;
SET NOCOUNT OFF;
GO
