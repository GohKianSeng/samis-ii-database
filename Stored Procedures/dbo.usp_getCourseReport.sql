
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseReport]
(@courseID INT, @TotalDay INT OUT, @MinAttendance INT OUT, @XML XML OUT, @AttendedAtLeastOnce INT OUT, @AllCompletedCourse INT OUT, @SACCompletedCourse INT OUT, @NonSACCompletedCourse INT OUT, @AnglicanCompletedCourse INT OUT, @NonAnglicanCompletedCourse INT OUT)
AS
SET NOCOUNT ON;

	DECLARE @Table TABLE (NRIC VARCHAR(20), Schedule DATE)
    SET @MinAttendance = (SELECT [MinCompleteAttendance] FROM [dbo].[tb_course] WHERE courseID = @courseID);
	DECLARE @ParishID INT = (SELECT [value] FROM [dbo].[tb_App_Config] WHERE ConfigName = 'currentparish');

	SELECT @TotalDay = COUNT(1) FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',');

	INSERT INTO @Table (NRIC, Schedule)
	SELECT B.Nric, CONVERT(DATETIME, A.ITEMS, 103) 
	FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',') AS A, [dbo].[tb_course_participant] AS B
	WHERE B.courseID = @courseID


	SELECT A.NRIC, ISNULL(ISNULL(C.EnglishName, D.EnglishName), E.EnglishName) AS Name, 
                 ISNULL(ISNULL(C.Gender, D.Gender), E.Gender) AS Gender,
				 ISNULL(F.ParishName, '') AS Church,
				 ISNULL(C.ChurchOthers, '') AS ChurchOthersName,
				 ISNULL(ISNULL(I.CongregationName, J.CongregationName), '') AS Congregation,
				 ISNULL(ISNULL(ISNULL(ISNULL(C.Contact, D.MobileTel), D.HomeTel), E.MobileTel), E.HomeTel) AS Contact,
				 ISNULL(ISNULL(C.Email, D.Email), E.Email) AS Email, 
	A.Schedule, ISNULL(DATEDIFF(DAY, A.Schedule, B.Date), 1) AS Attendance FROM @Table AS A
	LEFT OUTER JOIN [dbo].[tb_course_Attendance] AS B ON B.Date = A.Schedule AND B.CourseID = @courseID AND A.NRIC = B.NRIC
	LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = ISNULL(ISNULL(C.Church, D.CurrentParish), E.CurrentParish)
	LEFT OUTER JOIN [dbo].[tb_membersOtherInfo] AS G ON G.NRIC = D.NRIC
	LEFT OUTER JOIN [dbo].[tb_membersOtherInfo_temp] AS H ON H.NRIC = E.NRIC
	LEFT OUTER JOIN [dbo].[tb_congregation] AS I ON I.CongregationID = G.Congregation
	LEFT OUTER JOIN [dbo].[tb_congregation] AS J ON J.CongregationID = H.Congregation
	Order by A.NRIC, A.Schedule ASC

	SET @AttendedAtLeastOnce = (SELECT COUNT(DISTINCT NRIC) AS Attended FROM [dbo].[tb_course_Attendance] WHERE CourseID = @courseID);

	DECLARE @CompletedCourse TABLE(NRIC VARCHAR(20), Attended INT)

	INSERT INTO @CompletedCourse
	SELECT[NRIC] AS Attended, COUNT(1) FROM [dbo].[tb_course_Attendance]
	WHERE CourseID = @courseID	
	GROUP BY NRIC;

	SET @AllCompletedCourse = (SELECT COUNT(1) FROM @CompletedCourse WHERE Attended >= @MinAttendance);

	SET @SACCompletedCourse = (SELECT COUNT(1)
					 FROM @CompletedCourse AS A
		LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
		WHERE ISNULL(F.ParishID, @ParishID) = @ParishID
		AND Attended >= @MinAttendance);


	SET @NonSACCompletedCourse = (SELECT COUNT(1)
					 FROM @CompletedCourse AS A
		LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
		LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
		WHERE ISNULL(F.ParishID, @ParishID) <> @ParishID
		AND Attended >= @MinAttendance);

	SET @AnglicanCompletedCourse = (SELECT COUNT(1)
			     FROM @CompletedCourse AS A
	LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
	WHERE ISNULL(F.ParishID, @ParishID) <> 28
	AND Attended >= @MinAttendance);

	SET @NonAnglicanCompletedCourse = (SELECT COUNT(1)
			     FROM @CompletedCourse AS A
	LEFT OUTER JOIN [dbo].[tb_visitors] AS C ON C.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members] AS D ON D.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_members_temp] AS E ON E.NRIC = A.NRIC
	LEFT OUTER JOIN [dbo].[tb_parish] AS F ON F.ParishID = C.Church
	WHERE ISNULL(F.ParishID, @ParishID) = 28
	AND Attended >= @MinAttendance);

	DECLARE @CountAttendanceTable TABLE(MyDate DATE, Attended INT);
	INSERT INTO @CountAttendanceTable
	SELECT [Date], Count(1) AS Attendance FROM [dbo].[tb_course_Attendance] WHERE CourseID = @courseID
	GROUP BY [Date]

	SET @XML = (SELECT CONVERT(DATE, A.items, 103) AS [Date], ISNULL(B.Attended,0) As DailyTotal FROM dbo.udf_Split((SELECT CourseStartDate FROM [dbo].[tb_course] WHERE courseID = @courseID), ',') AS A
	LEFT OUTER JOIN @CountAttendanceTable AS B ON CONVERT(DATE, A.items, 103) = B.MyDate
	Order By CONVERT(DATE, A.items, 103) FOR XML PATH('Attendance'), ROOT('DailyAttendance'));	

SET NOCOUNT OFF;
GO
