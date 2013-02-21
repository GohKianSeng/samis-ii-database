SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_removeCourseParticipant]
(@CourseID INT,
@nric VARCHAR(20))
AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE courseID = @CourseID AND NRIC = @nric)
BEGIN
	DELETE FROM dbo.tb_course_participant WHERE courseID = @CourseID AND NRIC = @nric
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
