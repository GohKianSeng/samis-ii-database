
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_addNewCourseVisitorParticipant]
(@Visitor XML, @course VARCHAR(10),
@FinalResult VARCHAR(10) OUTPUT,
@FinalSalutation VARCHAR(10) OUTPUT,
@FinalEnglishName VARCHAR(50) OUTPUT,
@FinalCourseName VARCHAR(100) OUTPUT,
@AdditionalInformation XML)
AS
SET NOCOUNT ON;


DECLARE @nric VARCHAR(20),
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
@church_others VARCHAR(100), @UserID VARCHAR(50),
@candidate_mailingList VARCHAR(3),
@candidate_congregation TINYINT,
@candidate_mailingListBoolean BIT = 0;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @Visitor;
	
    SELECT @candidate_mailingList = mailingList, @UserID = EnteredBy, @nric = OriginalNric, @salutation = Salutation,
	@english_name = EnglishName, @gender = Gender, @dob = CONVERT(DATETIME, DOB, 103),
	@nationality = Nationality, @contact = Contact,
	@street_address = AddressStreetName, @blk_house = AddressBlkHouse,
	@postal_code = AddressPostalCode, @unit = AddressUnit,
	@email = Email, @education = Education, @occupation = Occupation,
	@church = Church, @church_others = ChurchOthers, @candidate_congregation = Congregation
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNRIC',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(15) './DOB',
	Nationality VARCHAR(3) './Nationality',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	Contact VARCHAR(15) './Contact',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	Occupation VARCHAR(3) './Occupation',
	mailingList VARCHAR(3) './mailingList',
	Church VARCHAR(3) './Church',
	ChurchOthers VARCHAR(3) './ChurchOthers',
	Congregation TINYINT './Congregation');

IF(@candidate_mailingList = 'ON' OR @candidate_mailingList = '1')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
OR EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @nric)
BEGIN
	DECLARE @Result VARCHAR(100) = 'NotFound';
	IF EXISTS (SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @nric)
	BEGIN
		EXEC dbo.usp_updateVistor @Visitor, @Result OUTPUT;
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members WHERE NRIC = @nric)
	BEGIN
		EXEC dbo.usp_updateMemberPartial @Visitor, @Result OUTPUT;
	END
	ELSE IF EXISTS (SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @nric)
	BEGIN
		EXEC dbo.usp_updateMemberTempPartial @Visitor, @Result OUTPUT;
	END
	
	IF EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE NRIC = @nric AND courseID = @course)
	BEGIN
		UPDATE dbo.tb_course_participant SET AdditionalInformation = @AdditionalInformation WHERE NRIC = @nric AND courseID = @course;
		
		SELECT @FinalResult = 'EXISTS', @FinalSalutation = @salutation, @FinalEnglishName = @english_name, @FinalCourseName = CourseName FROM dbo.tb_course WHERE courseID = @course;		
		return;
	END
	ELSE
	BEGIN
		EXEC dbo.usp_addNewCourseMemberParticipant @nric, @course, @AdditionalInformation
		SELECT @FinalResult = 'OK', @FinalSalutation = @salutation, @FinalEnglishName = @english_name, @FinalCourseName = CourseName FROM dbo.tb_course WHERE courseID = @course;
		return;
	END
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
	
	INSERT INTO dbo.tb_visitors(Congregation, receiveMailingList, Salutation, NRIC, EnglishName, DOB, Gender, Education, Occupation, Nationality, Email, Contact, AddressStreet, AddressHouseBlk, AddressPostalCode, AddressUnit, VisitorType, Church, ChurchOthers)
	SELECT @candidate_congregation, @candidate_mailingListBoolean, @salutation, @nric, @english_name, @dob, @gender, @education, @occupation, @nationality, @email, @contact, @street_address, @blk_house, @postal_code, @unit, 1, @church, @church_others
	
	INSERT INTO dbo.tb_course_participant(NRIC, courseID, AdditionalInformation)
	SELECT @nric, @course, ISNULL(@AdditionalInformation, '<div />');
	
	DECLARE @newVisitorXML XML = (
	SELECT  C.SalutationName, A.EnglishName, A.AddressUnit,
			A.AddressHouseBlk, ISNULL(D.CountryName, '') AS Nationality, F.OccupationName AS Occupation,
			A.NRIC,
			A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.AddressStreet,
			ISNULL(CONVERT(VARCHAR(7), A.AddressPostalCode), '') AS AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education,
			A.Contact, A.Church, A.ChurchOthers, ISNULL(G.CongregationName, '') AS CongregationName
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
	LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID	
	LEFT OUTER JOIN dbo.tb_congregation AS G on G.CongregationID = A.Congregation
	WHERE A.NRIC = @nric
	FOR XML PATH, ELEMENTS)
	
	DECLARE @temp table(a INT)
	INSERT INTO @temp(a)
	EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'New', 1, 'NRIC', @nric, @newVisitorXML;
		
	SELECT @FinalResult = 'OK', @FinalSalutation = ISNULL(D.SalutationName, ''), @FinalEnglishName = B.EnglishName, @FinalCourseName = C.CourseName FROM dbo.tb_course_participant AS A
	INNER JOIN dbo.tb_visitors AS B ON B.NRIC = A.NRIC
	INNER JOIN dbo.tb_course AS C ON A.courseID = C.courseID
	LEFT OUTER JOIN dbo.tb_Salutation AS D ON D.SalutationID = B.Salutation
	WHERE A.NRIC = @nric AND A.courseID = @course
END

SET NOCOUNT OFF;

GO
