
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseMemberParticipant]
(@NRIC VARCHAR(100),
 @courseid int,
 @AdditionalInformation XML)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
		SELECT @NRIC, @courseid, ISNULL(@AdditionalInformation, '<div />');
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @courseid;
		
		SELECT 'EXISTS' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
		SELECT @NRIC, @courseid, ISNULL(@AdditionalInformation, '<div />');
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @courseid;
		
		SELECT 'EXISTS' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON C.courseID = A.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
END
ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @NRIC)
BEGIN
	if NOT EXISTS (SELECT 1 FROM dbo.tb_course_participant WHERE NRIC=@NRIC AND courseID=@courseid)
	BEGIN
		INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
		SELECT @NRIC, @courseid, ISNULL(@AdditionalInformation, '<div />');
		
		SELECT 'OK' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members_temp AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
	ELSE
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @courseid;
		
		SELECT 'EXISTS' AS Result, D.SalutationName, B.EnglishName, C.CourseName FROM dbo.tb_course_participant AS A
		INNER JOIN dbo.tb_members_temp AS B ON B.NRIC = A.NRIC
		INNER JOIN dbo.tb_course AS C ON C.courseID = A.courseID
		INNER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
		WHERE A.NRIC = @nric AND A.courseID = @courseid
	END
END
ELSE
BEGIN
		SELECT 'NOTEXISTS' AS Result, '' AS SalutationName, '' AS EnglishName, '' AS CourseName
END

SET NOCOUNT OFF;
GO
