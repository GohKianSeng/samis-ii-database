SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getPeriodicAttendanceReport]
(@FromYear VARCHAR(4), @ToYear VARCHAR(4), @FromMonth VARCHAR(2), @ToMonth VARCHAR(2))
AS
SET NOCOUNT ON;

DECLARE @StartDate DATE = CONVERT(DATE, '1/' + @FromMonth + '/' + @FromYear, 103);
DECLARE @dtDate VARCHAR(10) = @ToMonth +'/1/' + @ToYear;
DECLARE @EndDate DATE = CONVERT(DATE, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@dtDate)+1,0)));
DECLARE @CourseMainTable TABLE(MinCompleteAttendance INT, courseID INT, NumberOfDays INT);
DECLARE @AttendanceMainTable TABLE(courseID INT, NRIC VARCHAR(20), Attendance INT);
DECLARE @AttendanceAttended TABLE(CourseID INT, NumberOfAttendee INT);
DECLARE @AttendanceCompleted TABLE(CourseID INT, NumberOfAttendee INT);

INSERT INTO @CourseMainTable
SELECT [MinCompleteAttendance], courseID, (SELECT COUNT(1) FROM dbo.udf_Split([CourseStartDate], ',')) NumberOfDays FROM [dbo].[tb_course]
WHERE [dbo].[udf_getStartDate]([CourseStartDate]) >= @StartDate 
AND [dbo].[udf_getStartDate]([CourseStartDate]) <= @EndDate
AND [dbo].[udf_getEndDate]([CourseStartDate]) >= @StartDate
AND [dbo].[udf_getEndDate]([CourseStartDate]) <= @EndDate;
  
INSERT INTO @AttendanceMainTable
SELECT A.CourseID, A.NRIC, COUNT(1) AS Attendance FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN @CourseMainTable AS B ON B.CourseID = A.courseID
GROUP BY A.CourseID, A.NRIC ORDER BY A.CourseID

INSERT INTO @AttendanceAttended
SELECT A.CourseID, COUNT(1) FROM @AttendanceMainTable AS A
INNER JOIN @CourseMainTable AS B ON A.courseID = B.courseID
GROUP BY A.CourseID;

INSERT INTO @AttendanceCompleted
SELECT  A.CourseID, COUNT(1) FROM @AttendanceMainTable AS A
INNER JOIN @CourseMainTable AS B ON A.courseID = B.courseID
WHERE Attendance >= MinCompleteAttendance
GROUP BY A.CourseID;

SELECT D.CourseID, (C.CourseName) AS CourseName, ISNULL(A.NumberOfAttendee,0) AS AttendanceCompleted, ISNULL(B.NumberOfAttendee,0) AS AttendanceAttended 
FROM @CourseMainTable AS D
LEFT OUTER JOIN @AttendanceCompleted AS A on D.courseID = A.CourseID
LEFT OUTER JOIN @AttendanceAttended AS B ON D.CourseID = B.CourseID
INNER JOIN [dbo].[tb_course] AS C ON D.CourseID = C.courseID
Order By LEN(C.CourseName) ASC

SET NOCOUNT OFF;
GO
