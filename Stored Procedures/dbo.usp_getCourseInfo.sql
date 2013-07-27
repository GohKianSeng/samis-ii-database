
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getCourseInfo]
(@courseid int)
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT MinCompleteAttendance, LastRegistrationDate, AdditionalQuestion, Fee, CourseDay, courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, E.AreaName AS courseLocation, dbo.udf_getStafforMemberName(A.CourseInCharge) AS Name, A.CourseInCharge FROM dbo.tb_course AS A
LEFT OUTER JOIN dbo.tb_members AS B on A.CourseInCharge = B.NRIC
LEFT OUTER JOIN dbo.tb_Users AS C on A.CourseInCharge = C.NRIC
LEFT OUTER JOIN dbo.tb_style AS D ON C.Style = D.styleID
LEFT OUTER JOIN dbo.tb_churchArea AS E ON E.AreaID = A.courseLocation
WHERE courseID = @courseid

SET NOCOUNT OFF;

GO
