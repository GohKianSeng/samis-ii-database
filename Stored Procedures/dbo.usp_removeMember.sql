SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_removeMember]
(@NRIC VARCHAR(20), @Type VARCHAR(10))
AS
SET NOCOUNT ON;

IF(@Type = 'Actual')
BEGIN
	DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_members_attachments WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_membersOtherInfo WHERE NRIC = @NRIC;
	DELETE FROM tb_members WHERE NRIC = @NRIC;
END
ELSE IF(@Type = 'Temp')
BEGIN
    DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_members_attachments WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @NRIC;
	DELETE FROM tb_members_temp WHERE NRIC = @NRIC;
END

ELSE IF(@Type = 'Visitor')
BEGIN
    DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @NRIC;
	DELETE FROM dbo.tb_visitors WHERE NRIC = @NRIC;
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
