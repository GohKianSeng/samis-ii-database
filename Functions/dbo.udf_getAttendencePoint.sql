SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_getAttendencePoint]
(	
	@NRIC VARCHAR(10), 
	@CourceID INT
)
RETURNS INT 
AS

BEGIN
	
	/* retrieve CITY KIDS Settings*/
	DECLARE @BasePoint INT = (SELECT CONVERT(INT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'CityKidBaseAttendancePoint')
	DECLARE @ContinualAttendance INT = (SELECT CONVERT(INT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'CityKidContinualAttendance')
	
	/* Initail Award Point is 10 */
	DECLARE @iAwardPoint int = 10, @iCount int = 1, @iCheckAttendance int = 0;
	DECLARE @dtCheckDate date;
	
	/* Create first cursor to get last 6 course schedule dates */
	DECLARE ScheduleCursor CURSOR FOR 
	SELECT [DOS].[dbo].[tb_course_schedule].[Date]
	FROM [DOS].[dbo].[tb_course_schedule] WHERE [DOS].[dbo].[tb_course_schedule].[Date] <= CONVERT(date, GETDATE())
	ORDER BY [DOS].[dbo].[tb_course_schedule].[Date] DESC
	
	OPEN ScheduleCursor
	
	/* put schedule date result into @dtCheckDate */
	FETCH NEXT FROM ScheduleCursor
	INTO @dtCheckDate
	
	/* if @dtCheckDate data is available */
	WHILE @@FETCH_STATUS = 0
	BEGIN
		/* Find the attendance record in the tb_course_Attendance by using @dtChkDate */
		SET @iCheckAttendance = 0;
		
		/* Create second cursor to check in tb_course_Attendance table */
		DECLARE CheckAttendanceCursor CURSOR FOR 
		SELECT 1
		FROM dbo.tb_course_Attendance
		WHERE dbo.tb_course_Attendance.NRIC = @NRIC AND dbo.tb_course_Attendance.CourseID = 13 AND dbo.tb_course_Attendance.Date = @dtCheckDate
		
		/* put search result into @iCheckAttendance */
		OPEN CheckAttendanceCursor;
		FETCH NEXT FROM CheckAttendanceCursor INTO @iCheckAttendance
		
		/* put search result into @iCheckAttendance */
		IF @iCheckAttendance = 1
		BEGIN
			/* if search result is 1, then increase Award Point and increase @iCount by 1 */
			IF (@iCount % @ContinualAttendance) = 0
				SET @iAwardPoint = @ContinualAttendance * @BasePoint
			ELSE
				SET @iAwardPoint = (@iCount % @ContinualAttendance) * @BasePoint;
			SET @iCount = @iCount + 1;
			/* Close the cursor for next search */
			CLOSE CheckAttendanceCursor;
			DEALLOCATE CheckAttendanceCursor;
		END
		ELSE
		BEGIN
			/* Close the cursor for next search */
			CLOSE CheckAttendanceCursor;
			DEALLOCATE CheckAttendanceCursor;
			/* break while loop and stop searching */
			BREAK;
		END
		
		FETCH NEXT FROM ScheduleCursor
		INTO @dtCheckDate
	END
	
	CLOSE ScheduleCursor;
	DEALLOCATE ScheduleCursor;
	
	RETURN @iAwardPoint;
END
GO
