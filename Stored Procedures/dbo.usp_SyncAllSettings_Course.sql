SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Course]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Course TABLE (
	courseID [int] NOT NULL,
	CourseName [varchar](100) NOT NULL,
	CourseStartDate [varchar](2000) NOT NULL,
	CourseStartTime [time](7) NOT NULL,
	CourseEndTime [time](7) NOT NULL,
	CourseInCharge [varchar](20) NOT NULL,
	CourseLocation [tinyint] NOT NULL,
	Deleted [bit] NOT NULL,
	Fee [decimal](5, 2) NOT NULL)

DECLARE @idoc int;
EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;

INSERT INTO @Course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee)
SELECT courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee
	FROM OPENXML(@idoc, '/All/AllCourse/*')
	WITH (
		courseID int'./courseID',
		CourseName VARCHAR(100)'./CourseName',
		CourseStartDate VARCHAR(2000)'./CourseStartDate',
		CourseStartTime TIME'./CourseStartTime',
		CourseEndTime TIME'./CourseEndTime',
		CourseInCharge VARCHAR(20)'./CourseInCharge',
		CourseLocation tinyint'./CourseLocation',
		Deleted BIT'./Deleted',
		Fee DECIMAL(5, 2)'./Fee')

UPDATE dbo.tb_course SET dbo.tb_course.CourseName = A.CourseName
						 ,dbo.tb_course.CourseStartDate = A.CourseStartDate
						 ,dbo.tb_course.CourseStartTime = A.CourseStartTime
						 ,dbo.tb_course.CourseEndTime = A.CourseEndTime
						 ,dbo.tb_course.CourseInCharge = A.CourseInCharge
						 ,dbo.tb_course.CourseLocation = A.CourseLocation
						 ,dbo.tb_course.Deleted = A.Deleted
						 ,dbo.tb_course.Fee = A.Fee
FROM @Course AS A WHERE dbo.tb_course.courseID = A.courseID		

SET IDENTITY_INSERT dbo.tb_course ON

INSERT INTO dbo.tb_course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee)
SELECT courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee
FROM @Course WHERE courseID NOT IN (SELECT courseID FROM dbo.tb_course)

IF EXISTS(SELECT 1 FROM @Course)
DELETE FROM dbo.tb_course WHERE courseID NOT IN (SELECT courseID FROM @Course);

SET IDENTITY_INSERT dbo.tb_course OFF				

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
