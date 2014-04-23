
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseIndividualAttendanceReport]
(@FromYear VARCHAR(4), @NumberOfCourse INT, @Church VARCHAR(1), @NRIC VARCHAR(20))
AS
SET NOCOUNT ON;

DECLARE @CurentParish INT = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish')
DECLARE @OtherChurchID INT = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'OtherChurchParish')
DECLARE @AttendedTable TABLE (NRIC VARCHAR(20),NumberOfCourse INT, CourseName VARCHAR(MAX));
DECLARE @CompletedTable TABLE (NRIC VARCHAR(20),NumberOfCourse INT, CourseName VARCHAR(MAX));

DECLARE @attendanceTable table (NRIC VARCHAR(20), CourseID INT, CourseName VARCHAR(100));

INSERT INTO @attendanceTable
SELECT NRIC, A.courseID, B.CourseName FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
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
FROM @attendanceTable AS Results
WHERE courseID IN (
		SELECT DISTINCT C.courseID FROM [dbo].[tb_course] AS C 
		CROSS APPLY(
			SELECT  CONVERT(DATE, items, 103) AS CourseDate from [dbo].[udf_Split]([CourseStartDate], ',')
		) AS A
		WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
	)
GROUP BY NRIC;

DECLARE @CompletedattendanceTable table (NRIC VARCHAR(20), CourseID INT, Attended INT);

INSERT INTO @CompletedattendanceTable
SELECT A.NRIC, A.CourseID, COUNT(1) FROM [dbo].[tb_course_Attendance] AS A
INNER JOIN [dbo].[tb_course] AS B ON B.courseID = A.CourseID
WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
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
		WHERE Year([dbo].[udf_getStartDate]([CourseStartDate])) = @FromYear
	)
GROUP BY NRIC;

IF(LEN(@NRIC) > 0)
BEGIN
	DELETE FROM @AttendedTable WHERE NRIC <> @NRIC;
	DELETE FROM @CompletedTable WHERE NRIC <> @NRIC;
END

ELSE IF(@Church = 'C')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @CurentParish OR G.ParishID <> @CurentParish;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @CurentParish OR G.ParishID <> @CurentParish;
END
ELSE IF(@Church = 'A')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @CurentParish OR G.ParishID = @CurentParish OR F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @CurentParish OR G.ParishID = @CurentParish OR F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
END
ELSE IF(@Church = 'B')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID = @OtherChurchID OR G.ParishID = @OtherChurchID;
END
ELSE IF(@Church = 'O')
BEGIN
	DELETE @CompletedTable 
	FROM @CompletedTable AS B
	LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @OtherChurchID OR G.ParishID <> @OtherChurchID;
	
	DELETE @AttendedTable 
	FROM @AttendedTable AS A
	LEFT OUTER JOIN @CompletedTable AS B ON B.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
	LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
	LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
	WHERE F.ParishID <> @OtherChurchID OR G.ParishID <> @OtherChurchID;
END

SELECT ISNULL(C.NRIC,'') AS Member, ISNULL(D.NRIC,'') AS TempMember, ISNULL(E.NRIC,'') AS Visitor, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name, ISNULL(A.NRIC, B.NRIC) AS NRIC, ISNULL(B.NumberOfCourse, 0) AS CompletedNumberOfCourse, ISNULL(B.CourseName, '') AS CompletedCourseName
	   ,A.NumberOfCourse AS AttendedNumberOfCourse, A.CourseName AS AttendedCourseName, ISNULL(G.ParishName, F.ParishName) AS ChurchName, ISNULL(E.ChurchOthers,'') AS OtherChurchName,
	   ISNULL((CASE WHEN(ISNULL(ISNULL(E.Church, C.CurrentParish), D.CurrentParish) = @CurentParish) THEN (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @CurentParish) 
			 WHEN(ISNULL(ISNULL(E.Church, C.CurrentParish), D.CurrentParish) = @OtherChurchID) THEN 'Others' 
			 ELSE 'Anglican 'END), '')  AS Parish
FROM @CompletedTable AS B
LEFT OUTER JOIN @AttendedTable AS A ON B.NRIC = A.NRIC
LEFT OUTER JOIN [dbo].[tb_members] AS C ON C.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN [dbo].[tb_members_temp] AS D ON D.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN [dbo].[tb_visitors] AS E ON E.NRIC = ISNULL(A.NRIC, B.NRIC)
LEFT OUTER JOIN dbo.tb_parish AS F ON F.ParishID = E.Church
LEFT OUTER JOIN dbo.tb_parish AS G ON G.ParishID = ISNULL(C.CurrentParish, D.CurrentParish)
WHERE B.NumberOfCourse >= @NumberOfCourse;

SET NOCOUNT OFF;
GO
