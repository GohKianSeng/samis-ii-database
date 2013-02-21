SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getListofCourseParticipants]
(@courseID INT)
AS
SET NOCOUNT ON;

  SELECT A.NRIC, ISNULL(ISNULL(D.EnglishName,C.EnglishName), B.EnglishName) AS EnglishName, courseID, feePaid, materialReceived,
  dbo.udf_getAttendancePercentage(A.NRIC, @courseID, 'percentage') AS Percentage, dbo.udf_getAttendancePercentage(A.NRIC, @courseID, '') AS Attendance
  FROM dbo.tb_course_participant AS A
  LEFT OUTER JOIN dbo.tb_members AS B ON A.NRIC = B.NRIC
  LEFT OUTER JOIN dbo.tb_members_temp AS C ON A.NRIC = C.NRIC
  LEFT OUTER JOIN dbo.tb_visitors AS D ON A.NRIC = D.NRIC
  WHERE courseID = @courseid

SET NOCOUNT OFF;
GO
