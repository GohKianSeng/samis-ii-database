
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_addNewCourse]
(@Speaker VARCHAR(100),
 @SendReminder BIT,
 @coursename VARCHAR(100),
 @startdate VARCHAR(2000),
 @starttime VARCHAR(5),
 @endtime VARCHAR(5),
 @incharge VARCHAR(10),
 @location INT,
 @fee DECIMAL(5, 2),
 @AdditionalQuestion INT,
 @LastRegistration DateTime,
 @MinCompleteAttendance INT)
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_course (Speaker, SendReminder, MinCompleteAttendance, AdditionalQuestion, LastRegistrationDate, Fee, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation)
SELECT @Speaker, @SendReminder, @MinCompleteAttendance, @AdditionalQuestion, @LastRegistration, @fee, @coursename, @startdate, @starttime, @endtime, @incharge, @location

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;


GO
