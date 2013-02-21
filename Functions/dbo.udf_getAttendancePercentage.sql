SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_getAttendancePercentage]
(@NRIC VARCHAR(20),
@CourseID INT,
@type VARCHAR(10))
RETURNS VARCHAR(50)
AS
BEGIN
	
	DECLARE @AttendanceTable TABLE ([Date] DATE, Attended VARCHAR(3));

	INSERT INTO @AttendanceTable ([Date], Attended)
	SELECT CONVERT(DATE, ITEMS, 103), '-' FROM dbo.udf_Split((SELECT CourseStartDate FROM dbo.tb_course WHERE courseID = @courseid), ',');
	UPDATE @AttendanceTable SET Attended = 'Yes' WHERE [Date] IN (SELECT [Date] FROM dbo.tb_course_Attendance WHERE CourseID = @courseid AND NRIC = @nric);
	UPDATE @AttendanceTable SET Attended = '??' WHERE [Date] > GETDATE();

	DECLARE @TotalDayConducted INT = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended <> '??');
	DECLARE @TotalDayAttended INT = (SELECT COUNT(*) FROM @AttendanceTable WHERE Attended = 'Yes');
	DECLARE @AttandancePercentage NUMERIC(6,2) = 0;
	IF(@TotalDayConducted > 0)
	BEGIN
		SET @AttandancePercentage  = (SELECT CONVERT(NUMERIC(4,2), @TotalDayAttended) / CONVERT(NUMERIC(4,2), @TotalDayConducted) * 100);
	END
	
	IF(@type = 'percentage')
	BEGIN
		return CONVERT(VARCHAR(10),@AttandancePercentage)+'%';
	END
	ELSE
	BEGIN
		return CONVERT(VARCHAR(10),@TotalDayAttended)+ '/' + CONVERT(VARCHAR(10),@TotalDayConducted);
	END
	
	return '';
END
GO
