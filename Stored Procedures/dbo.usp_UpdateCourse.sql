
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCourse]
(@courseid INT,
 @coursename VARCHAR(100),
 @startdate VARCHAR(2000),
 @starttime VARCHAR(5),
 @endtime VARCHAR(5),
 @incharge VARCHAR(10),
 @location INT,
 @AdditionalInformation INT,
 @LastRegistrationDate DATETIME)
AS
SET NOCOUNT ON;

UPDATE dbo.tb_course SET CourseName = @coursename, CourseStartDate = @startdate,
	   CourseStartTime = @starttime, CourseEndTime = @endtime, CourseInCharge = @incharge, CourseLocation = @location,
       AdditionalQuestion = @AdditionalInformation, LastRegistrationDate = @LastRegistrationDate
       WHERE courseID = @courseid;
SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
