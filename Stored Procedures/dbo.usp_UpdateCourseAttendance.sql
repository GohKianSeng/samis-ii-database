SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCourseAttendance]
(@courseid INT,
 @nric VARCHAR(20),
 @DATE DATE)
AS
SET NOCOUNT ON;

DECLARE @AttendanceTable TABLE ([Date] DATE)
DECLARE @name VARCHAR(50);
DECLARE @coursename VARCHAR(100);

INSERT INTO @AttendanceTable ([Date])
SELECT CONVERT(DATE, ITEMS, 103) FROM dbo.udf_Split((SELECT CourseStartDate FROM dbo.tb_course WHERE courseID = @courseid), ',');

IF EXISTS(SELECT 1 FROM @AttendanceTable WHERE [Date] in (SELECT @DATE))
BEGIN
	IF EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE courseID = @courseid AND NRIC = @nric)
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM dbo.tb_course_Attendance WHERE courseID = @courseid AND NRIC = @nric AND [Date] = @DATE)
		BEGIN
			 INSERT INTO dbo.tb_course_Attendance(CourseID, NRIC, [Date])
			 SELECT @courseid, @nric, @DATE;
			
			  SELECT @name = ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName), @coursename = E.CourseName FROM dbo.tb_course_participant AS A
			  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
			  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
			  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
			  INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
			  WHERE A.courseID = @courseid AND A.NRIC = @nric
			
			  SELECT 'Welcome ' + @name + ', thank you for attending, ' + @coursename AS Result;
		END
		ELSE
		BEGIN
			  SELECT @name = ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName), @coursename = E.CourseName FROM dbo.tb_course_participant AS A
			  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
			  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
			  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
			  INNER JOIN dbo.tb_course AS E ON E.courseID = A.courseID
			  WHERE A.courseID = @courseid AND A.NRIC = @nric
			
			  SELECT 'Welcome ' + @name + ', your attendance registered, ' + @coursename AS Result;
		END
	END
	ELSE
	BEGIN
		SELECT 'Sorry you are not registered.' AS Result;
	END
END
ELSE
BEGIN
	SELECT @coursename = CourseName FROM dbo.tb_course WHERE courseID = @courseid
	SELECT 'Sorry, there no class for, ' + @coursename AS Result;
END

SET NOCOUNT OFF;
GO
