SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_ManualUpdateAttendance]
(@courseid INT,
 @nric VARCHAR(20),
 @date DATETIME,
 @attendance VARCHAR(10))
AS
SET NOCOUNT ON;

IF(@attendance = 'yes')
BEGIN
	EXEC dbo.usp_UpdateCourseAttendance @courseid, @nric, @date;
	SELECT 'Attendance added.' AS Result;
END
ELSE IF(@attendance = 'no')
BEGIN
	DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @nric AND CourseID = @courseid AND [Date] = @date
	SELECT 'Attendance removed.' AS Result;
END

SET NOCOUNT OFF;
GO
