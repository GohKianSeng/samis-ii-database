SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCityKidsAttendance]
(
	@NRIC VARCHAR(10),
	@CourseID INT
)
AS
SET NOCOUNT ON;

/* Convert input NRIC to upper case */
SET @NRIC = UPPER(@NRIC);

DECLARE @iAwardPoint INT = 0;
DECLARE @dtTodayDate date = CONVERT(date, GETDATE());

--IF NOT EXISTS(SELECT 1 FROM dbo.tb_course WHERE dbo.tb_course.courseID = @CourseID)
--BEGIN
--	/* return COURSE ID NOT FOUND if cannot locate the course id in [tb_course] */
--	SELECT	@NRIC AS NRIC, 'COURSE ID NOT FOUND' AS EnglishName, @iAwardPoint AS Point
--	RETURN;
--END
--ELSE 
IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_schedule WHERE dbo.tb_course_schedule.Date = @dtTodayDate AND CourseID = @CourseID)
BEGIN
	/* return NO SCHEDULED COURSE if cannot find today's date in [tb_course_schedule] */
	SELECT	@NRIC AS NRIC, 'COURSE SCHEDULE DATE NOT FOUND' AS EnglishName, @iAwardPoint AS Point, 0 AS Awarded
	RETURN;
END
ELSE IF EXISTS(SELECT 1 FROM dbo.tb_ccc_kids WHERE dbo.tb_ccc_kids.NRIC = @NRIC) /* first, find record in [tb_ccc_kids] */
BEGIN
	/* Search course attendance table look for double entry checking */
	IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_Attendance WHERE dbo.tb_course_Attendance.NRIC = @NRIC AND dbo.tb_course_Attendance.Date = CONVERT(date, GETDATE()))
	BEGIN
		/* Insert today's visit record in dbo.tb_course_Attendance table */
		INSERT INTO dbo.tb_course_Attendance ( dbo.tb_course_Attendance.NRIC, dbo.tb_course_Attendance.CourseID, dbo.tb_course_Attendance.Date) 
		VALUES ( @NRIC, @CourseID, @dtTodayDate)
		
		/* Check attendance history */
		SET @iAwardPoint = dbo.udf_getAttendencePoint(@NRIC, @CourseID);
		PRINT @iAwardPoint
		
		INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, [Description], DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference)
		SELECT 'I', 'BarcodeSystem',  'CityKidMembership', 'Update', 1, CONVERT(XML,'<Changes><FromTo><Changes><ElementName>Points Added</ElementName><From>0</From><To>' + CONVERT(VARCHAR(3),@iAwardPoint) + '</To></Changes><Changes><ElementName>Remarks</ElementName><From>0</From><To>Attendance Point</To></Changes></FromTo></Changes>'), GETDATE(), 'NRIC', @NRIC
		 
		/* Update point in dbo.tb_ccc_kids */
		UPDATE dbo.tb_ccc_kids SET dbo.tb_ccc_kids.Points = dbo.tb_ccc_kids.Points + @iAwardPoint WHERE dbo.tb_ccc_kids.NRIC = @NRIC						
	END
	/* reselect record data after update point*/
	SET @iAwardPoint = dbo.udf_getAttendencePoint(@NRIC, @CourseID);
	SELECT @NRIC AS NRIC, dbo.tb_ccc_kids.Name AS EnglishName, dbo.tb_ccc_kids.Points AS Point, @iAwardPoint AS Awarded FROM dbo.tb_ccc_kids WHERE dbo.tb_ccc_kids.NRIC = @NRIC
END
ELSE
BEGIN
	/* Record not found in [tb_ccc_kids] */
	SELECT	@NRIC AS NRIC, 'RECORD NOT FOUND' AS EnglishName, @iAwardPoint AS Point, 0 AS Awarded
END

SET NOCOUNT OFF;
GO
