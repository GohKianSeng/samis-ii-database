SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseMemberParticipantAndAttendance]
(@NRIC VARCHAR(100),
 @courseid int)
AS
SET NOCOUNT ON;
DECLARE @today DATE = GETDATE();

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID)
		SELECT @NRIC, @courseid;
		
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_UpdateCourseAttendance @courseid, @NRIC, @today;
	END
END
ELSE
BEGIN
		SELECT 'SORRY Your are not yet registered.' AS Result
END

SET NOCOUNT OFF;
GO
