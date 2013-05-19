
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseParticipantInformation]
(@courseid INT,
@nric VARCHAR(20))
AS
SET NOCOUNT ON;

DECLARE @AttendanceTable TABLE ([Date] DATE, Attended VARCHAR(3));

INSERT INTO @AttendanceTable ([Date], Attended)
SELECT CONVERT(DATE, ITEMS, 103), '-' FROM dbo.udf_Split((SELECT CourseStartDate FROM dbo.tb_course WHERE courseID = @courseid), ',');
UPDATE @AttendanceTable SET Attended = 'Yes' WHERE [Date] IN (SELECT [Date] FROM dbo.tb_course_Attendance WHERE CourseID = @courseid AND NRIC = @nric);
UPDATE @AttendanceTable SET Attended = '??' WHERE [Date] > GETDATE();

DECLARE @TotalDayConducted NUMERIC(4,2) = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended <> '??');
DECLARE @TotalDayAttended NUMERIC(4,2) = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended = 'Yes');
DECLARE @AttandancePercentage NUMERIC(6,2) = 0;
IF(@TotalDayConducted > 0)
BEGIN
	SET @AttandancePercentage  = (SELECT @TotalDayAttended / @TotalDayConducted * 100);
END

DECLARE @xml XML = (SELECT [Date], Attended, @AttandancePercentage AS AttendancePercentage FROM @AttendanceTable Order by [Date] ASC FOR XML PATH('ATT'), ROOT('Attendance'));

SELECT @xml AS Attendance, AdditionalInformation, A.NRIC, ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName) AS EnglishName, courseID, feePaid, materialReceived FROM dbo.tb_course_participant AS A
  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
  WHERE A.courseID = @courseid AND A.NRIC = @nric;


SET NOCOUNT OFF;
GO
