SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCourseReminderRecipients]
AS
SET NOCOUNT ON;

DECLARE @DaysBeforeStart INT = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'CourseSendReminderDays');
DECLARE @CourseDate DATE = DATEADD(DAY, @DaysBeforeStart, GETDATE());

DECLARE @Table TABLE(CourseID INT);

INSERT INTO @Table(CourseID)
SELECT [courseID]
FROM [dbo].[tb_course] 
WHERE dbo.udf_getStartDate([CourseStartDate]) <= @CourseDate AND SendReminder = 1 AND ReminderSent = 0;

SELECT ISNULL(ISNULL(C.Email, D.Email), E.Email) AS Email, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name 
	   ,B.CourseName, F.AreaName, B.CourseStartTime, B.CourseEndTime, B.CourseStartDate
FROM dbo.tb_course_participant AS A
INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
LEFT OUTER JOIN dbo.tb_members AS C ON C.NRIC = A.NRIC
LEFT OUTER JOIN dbo.tb_members_temp AS D ON D.NRIC = A.NRIC
LEFT OUTER JOIN dbo.tb_visitors AS E ON E.NRIC = A.NRIC
LEFT OUTER JOIN dbo.tb_churchArea AS F ON F.AreaID = B.CourseLocation
WHERE A.courseID IN (SELECT courseID FROM @Table);

UPDATE [dbo].[tb_course] SET ReminderSent = 1
WHERE courseID IN(SELECT courseID FROM @Table);

SET NOCOUNT OFF;


GO
