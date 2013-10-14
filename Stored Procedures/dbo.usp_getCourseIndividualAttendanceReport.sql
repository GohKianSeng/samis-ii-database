SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseIndividualAttendanceReport]
(@FromYear VARCHAR(4), @NumberOfCourse INT)
AS
SET NOCOUNT ON;

DECLARE @AttendedTable TABLE (NRIC VARCHAR(20),NumberOfCourse INT, CourseName VARCHAR(MAX));
DECLARE @CompletedTable TABLE (NRIC VARCHAR(20),NumberOfCourse INT, CourseName VARCHAR(MAX));

DECLARE @attendanceTable table (NRIC VARCHAR(20), CourseID INT, CourseName VARCHAR(100));

INSERT INTO @attendanceTable
SELECT NRIC, A.courseID, B.CourseName FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
GROUP BY NRIC, A.courseID, B.CourseName;

INSERT INTO @AttendedTable
SELECT 
  NRIC, COUNT(1),
  STUFF((
    SELECT CourseName + '||'
    FROM @attendanceTable 
    WHERE (NRIC = Results.NRIC) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,0,'') AS NameValues
FROM @attendanceTable Results
WHERE courseID IN (
		SELECT DISTINCT C.courseID FROM [dbo].[tb_course] AS C 
		CROSS APPLY(
			SELECT  CONVERT(DATE, items, 103) AS CourseDate from [dbo].[udf_Split]([CourseStartDate], ',')
		) AS A
		WHERE (Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear OR Year([dbo].[udf_getEndDate]([CourseStartDate])) = @FromYear)
	)
GROUP BY NRIC;


DECLARE @CompletedattendanceTable table (NRIC VARCHAR(20), CourseID INT, Attended INT);

INSERT INTO @CompletedattendanceTable
SELECT A.NRIC, A.CourseID, COUNT(1) FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
GROUP BY A.NRIC, A.CourseID;

DELETE FROM @attendanceTable;
INSERT INTO @attendanceTable
SELECT NRIC, A.courseID, B.CourseName FROM @CompletedattendanceTable AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
WHERE A.Attended >= B.MinCompleteAttendance;

INSERT INTO @CompletedTable
SELECT 
  NRIC, COUNT(1),
  STUFF((
    SELECT CourseName + '||'
    FROM @attendanceTable 
    WHERE (NRIC = Results.NRIC) 
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,0,'') AS NameValues
FROM @attendanceTable Results
WHERE courseID IN (
		SELECT DISTINCT C.courseID FROM [dbo].[tb_course] AS C 
		CROSS APPLY(
			SELECT  CONVERT(DATE, items, 103) AS CourseDate from [dbo].[udf_Split]([CourseStartDate], ',')
		) AS A
		WHERE (Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear OR Year([dbo].[udf_getEndDate]([CourseStartDate])) = @FromYear)
	)
GROUP BY NRIC;

SELECT ISNULL(C.NRIC,'') AS Member, ISNULL(D.NRIC,'') AS TempMember, ISNULL(E.NRIC,'') AS Visitor, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name, ISNULL(A.NRIC, B.NRIC) AS NRIC, ISNULL(A.NumberOfCourse, 0) AS CompletedNumberOfCourse, ISNULL(A.CourseName, '') AS CompletedCourseName
	   ,B.NumberOfCourse AS AttendedNumberOfCourse, B.CourseName AS AttendedCourseName
FROM @AttendedTable AS B
LEFT OUTER JOIN @CompletedTable AS A ON B.NRIC = A.NRIC
LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
WHERE B.NumberOfCourse >= @NumberOfCourse OR A.NumberOfCourse >= @NumberOfCourse;

SET NOCOUNT OFF;
GO
