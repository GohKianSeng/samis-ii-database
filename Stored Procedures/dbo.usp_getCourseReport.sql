SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseReport]
(@courseID INT, @TotalDay INT OUT)
AS
SET NOCOUNT ON;

	DECLARE @Table TABLE (NRIC VARCHAR(20), Schedule DATE)
    
	SELECT @TotalDay = COUNT(1) FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',');

	INSERT INTO @Table (NRIC, Schedule)
	SELECT B.Nric, CONVERT(DATETIME, A.ITEMS, 103) 
	FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',') AS A, [dbo].[tb_course_participant] AS B
	WHERE B.courseID = @courseID


	SELECT A.NRIC, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name, 
                 ISNULL(ISNULL(C.Gender, D.Gender), E.Gender) AS Gender,
				 ISNULL(ISNULL(F.ParishName, 'St Andrew''s Cathedral'), 'St Andrew''s Cathedral') AS Church,
				 ISNULL(ISNULL(I.CongregationName, J.CongregationName), '') AS Congregation,
				 ISNULL(ISNULL(ISNULL(ISNULL(C.Contact, D.MobileTel), D.HomeTel), E.MobileTel), E.HomeTel) AS Contact,
				 ISNULL(ISNULL(C.Email, D.Email), E.Email) AS Email, 
	A.Schedule, ISNULL(DATEDIFF(DAY, A.Schedule, B.Date), 1) AS Attendance FROM @Table AS A
	LEFT OUTER JOIN [dbo].[tb_course_Attendance] AS B ON B.Date = A.Schedule AND B.CourseID = @courseID AND A.NRIC = B.NRIC
	LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
	LEFT OUTER JOIN [dbo].[tb_membersOtherInfo] AS G ON G.NRIC = D.NRIC
	LEFT OUTER JOIN [dbo].[tb_membersOtherInfo_temp] AS H ON H.NRIC = E.NRIC
	LEFT OUTER JOIN [dbo].[tb_congregation] AS I ON I.CongregationID = G.Congregation
	LEFT OUTER JOIN [dbo].[tb_congregation] AS J ON J.CongregationID = H.Congregation
	Order by A.NRIC, A.Schedule ASC

SET NOCOUNT OFF;
GO
