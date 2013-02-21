SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getCityKidSchedule]
(@CourseID INT)
AS
SET NOCOUNT ON;

DECLARE @schedule VARCHAR(MAX) = '';
SELECT @schedule = @schedule + CONVERT(VARCHAR(10), [Date], 103) + ','      
FROM [DOS].[dbo].[tb_course_schedule] WHERE [Date] >= CONVERT(DATE, GETDATE()) AND CourseID = @CourseID

SELECT @schedule AS Schedule
	

SET NOCOUNT OFF;
GO
