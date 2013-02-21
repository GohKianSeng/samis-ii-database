SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCourseVisitorParticipantAndAttendance]
(@nric VARCHAR(10),
@course VARCHAR(10),
@salutation VARCHAR(10),
@english_name VARCHAR(50),
@dob DATE,
@gender VARCHAR(1),
@education VARCHAR(10),
@nationality VARCHAR(10),
@occupation VARCHAR(10),
@postal_code VARCHAR(6),
@blk_house  VARCHAR(10),
@street_address  VARCHAR(1000),
@unit  VARCHAR(10),
@contact  VARCHAR(15),
@email  VARCHAR(100),
@church INT,
@church_others VARCHAR(100), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @today DATE = GETDATE();

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
BEGIN
	EXEC dbo.usp_UpdateCourseAttendance @course, @NRIC, @today;
END
ELSE
BEGIN
	if(len(@postal_code) = 0)
	BEGIN
		SET @postal_code = null;
	END
	if(@dob = CONVERT(DATE, '',103))
	BEGIN
		SET @dob = NULL;
	END

	INSERT INTO dbo.tb_visitors(Salutation, NRIC, EnglishName, DOB, Gender, Education, Occupation, Nationality, Email, Contact, AddressStreet, AddressHouseBlk, AddressPostalCode, AddressUnit, VisitorType, Church, ChurchOthers)
	SELECT @salutation, @nric, @english_name, @dob, @gender, @education, @occupation, @nationality, @email, @contact, @street_address, @blk_house, @postal_code, @unit, 1, @church, @church_others
	
	INSERT INTO dbo.tb_course_participant(NRIC, courseID)
	SELECT @nric, @course;
	
	EXEC dbo.usp_UpdateCourseAttendance @course, @NRIC, @today;
	
	DECLARE @newVisitorXML XML = (
	SELECT  C.SalutationName, A.EnglishName, A.AddressUnit,
			A.AddressHouseBlk, ISNULL(D.CountryName, '') AS Nationality, F.OccupationName AS Occupation,
			A.NRIC,
			A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.AddressStreet,
			ISNULL(CONVERT(VARCHAR(7), A.AddressPostalCode), '') AS AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education,
			A.Contact, A.Church, A.ChurchOthers
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
	LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID	
	WHERE A.NRIC = @nric
	FOR XML PATH, ELEMENTS)
	
	EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'New', 1, 'NRIC', @nric, @newVisitorXML;
END

SET NOCOUNT OFF;

			
GO
