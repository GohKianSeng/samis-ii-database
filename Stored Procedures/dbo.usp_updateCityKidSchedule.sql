SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_updateCityKidSchedule]
(@CourseID INT,
@Schedule VARCHAR(MAX))
AS
SET NOCOUNT ON;

DECLARE @schTable TABLE([Date] DATE)
INSERT INTO @schTable([Date])
SELECT CONVERT(DATE, ITEMS, 103) FROM dbo.udf_Split(@Schedule, ',')

DELETE FROM dbo.tb_course_schedule WHERE [Date] NOT IN (SELECT DISTINCT [Date] FROM dbo.tb_course_Attendance WHERE CourseID = @CourseID) AND [Date] NOT IN(SELECT [Date] FROM @schTable) AND [Date] >= CONVERT(DATE, GETDATE()) AND CourseID = @CourseID

INSERT INTO dbo.tb_course_schedule([Date], CourseID)
SELECT [DATE], @CourseID FROM @schTable WHERE [Date] NOT IN(SELECT [Date] FROM dbo.tb_course_schedule WHERE CourseID = @CourseID AND [Date] >= CONVERT(DATE, GETDATE()))

SET NOCOUNT OFF;
GO
