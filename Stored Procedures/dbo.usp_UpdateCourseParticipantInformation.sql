SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCourseParticipantInformation]
(@courseid INT,
 @nric VARCHAR(20),
 @feepaid VARCHAR(1),
 @materialreceived VARCHAR(1))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_course_participant SET feePaid = @feepaid, materialReceived = @materialreceived
WHERE courseID = @courseid AND NRIC = @nric

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
