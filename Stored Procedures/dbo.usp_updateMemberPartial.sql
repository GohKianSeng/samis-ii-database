
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_updateMemberPartial]
(@updateXML XML, @Result VARCHAR(10) OUTPUT)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_salutation VARCHAR(4),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_occupation VARCHAR(4),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_mobile_tel VARCHAR(15),
@candidate_mailingList VARCHAR(3),
@candidate_mailingListBoolean BIT = 0;

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @candidate_mailingList = mailingLIst, @UserID = EnteredBy, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_nationality = Nationality,
	@candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_occupation = Occupation
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(20)'./EnteredBy',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	Nationality VARCHAR(3) './Nationality',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	MobileTel VARCHAR(15) './Contact',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	mailingList VARCHAR(3) './mailingList',
	Occupation VARCHAR(3) './Occupation');

IF(@candidate_mailingList = 'ON' OR @candidate_mailingList = '1')
BEGIN
	SET @candidate_mailingListBoolean = 1;
END

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF EXISTS( SELECT 1 FROM dbo.tb_members WHERE NRIC = @candidate_nric)
BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_candidate_dob DATETIME
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_mobile_tel VARCHAR(15)	
	DECLARE @Orig_candidate_mailingList VARCHAR(3)

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));
	
	SELECT  @Orig_candidate_mailingList = ReceiveMailingList, @Orig_candidate_salutation = Salutation, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_occupation = Occupation,
			@Orig_candidate_dob = DOB, @Orig_candidate_gender = Gender, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education,
			@Orig_candidate_mobile_tel = MobileTel
	FROM dbo.tb_members AS A
	WHERE A.NRIC = @candidate_nric

	IF(@Orig_candidate_mailingList <> @candidate_mailingListBoolean)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Add Mailing List', @Orig_candidate_mailingList, @candidate_mailingListBoolean);		
	END

	IF(@Orig_candidate_salutation <> @candidate_salutation AND @candidate_salutation <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));
		SET @Orig_candidate_salutation = @candidate_salutation;
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name AND LEN(@candidate_english_name) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name', @Orig_candidate_english_name, @candidate_english_name);
		SET @Orig_candidate_english_name = @candidate_english_name;
	END

	IF(@Orig_candidate_unit <> @candidate_unit AND LEN(@candidate_unit) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
		SET @Orig_candidate_unit = @candidate_unit;
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house AND LEN(@candidate_blk_house) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
		SET @Orig_candidate_blk_house = @candidate_blk_house;
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address AND LEN(@candidate_street_address) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
		SET @Orig_candidate_street_address = @candidate_street_address;
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code AND @candidate_postal_code <> 0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
		SET @Orig_candidate_postal_code = @candidate_postal_code;
	END
	
	IF(@Orig_candidate_nationality <> @candidate_nationality AND @candidate_nationality <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality);
		SET @Orig_candidate_nationality = @candidate_nationality;
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation AND @candidate_occupation <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Occupation', (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @Orig_candidate_occupation), (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @candidate_occupation);
		SET @Orig_candidate_occupation = @candidate_occupation;
	END

	IF(@Orig_candidate_dob <> @candidate_dob AND @candidate_dob <> CONVERT(DATETIME, '', 103))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
		SET @Orig_candidate_dob = @candidate_dob;
	END

	IF(@Orig_candidate_gender <> @candidate_gender AND LEN(@candidate_gender) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
		SET @Orig_candidate_gender = @candidate_gender;
	END

	IF(@Orig_candidate_email <> @candidate_email AND LEN(@candidate_email) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
		SET @Orig_candidate_email = @candidate_email;
	END

	IF(@Orig_candidate_education <> @candidate_education AND @candidate_education <> '0')
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));
		SET @Orig_candidate_education = @candidate_education;
	END

	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel AND LEN(@candidate_mobile_tel) >0)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
		SET @Orig_candidate_mobile_tel = @candidate_mobile_tel;
	END

	DECLARE @returnTable TABLE (
		FromTo XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		
		
		UPDATE tb_members SET   Salutation = @Orig_candidate_salutation,
							EnglishName = @Orig_candidate_english_name,
							AddressUnit = @Orig_candidate_unit,
							AddressHouseBlk = @Orig_candidate_blk_house,
							Nationality = @Orig_candidate_nationality,
							Occupation = @Orig_candidate_occupation,
							DOB = @Orig_candidate_dob,
							Gender = @Orig_candidate_gender,
							AddressStreet = @Orig_candidate_street_address,
							AddressPostalCode = @Orig_candidate_postal_code,
							Email = @Orig_candidate_email,
							Education = @Orig_candidate_education,
							MobileTel = @Orig_candidate_mobile_tel,
							ReceiveMailingList = @candidate_mailingListBoolean
							
		WHERE NRIC = @candidate_nric
			
		SET @Result = 'Updated';
		
		DECLARE @LogID INT;
		EXEC @LogID = dbo.usp_insertloggingNoReturn 'I', @UserID, 'Membership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SET @Result = 'NoChange';
	END
END
ELSE
BEGIN		
	SET @Result = 'NotFound';
END

SET NOCOUNT OFF;

GO
