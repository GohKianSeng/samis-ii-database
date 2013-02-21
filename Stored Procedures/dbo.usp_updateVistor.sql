SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_updateVistor]
(@updateXML XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_salutation VARCHAR(4),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_occupation VARCHAR(4),
@candidate_nric VARCHAR(20),
@candidate_dob VARCHAR(15),
@candidate_gender VARCHAR(1),
@candidate_street_address VARCHAR(100),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_contact VARCHAR(15),
@candidate_education VARCHAR(3),
@candidate_church VARCHAR(3),
@candidate_churchOthers VARCHAR(100)

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_gender = Gender, @candidate_dob = DOB,
	@candidate_nationality = Nationality, @candidate_contact = Contact,
	@candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit,
	@candidate_email = Email, @candidate_education = Education, @candidate_occupation = Occupation,
	@candidate_church = Church, @candidate_churchOthers = ChurchOthers
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
	Church VARCHAR(3) './Church',
	ChurchOthers VARCHAR(3) './ChurchOthers');	

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_salutation) = 0)
BEGIN
	SET @candidate_salutation = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_occupation) = 0)
BEGIN
	SET @candidate_occupation = '0'
END

IF(LEN(@candidate_gender) = 0)
BEGIN
	SET @candidate_gender = ''
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF EXISTS( SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_candidate_nric VARCHAR(10)
	DECLARE @Orig_candidate_dob VARCHAR(15)
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_contact VARCHAR(15)
	DECLARE @Orig_candidate_church VARCHAR(3)
	DECLARE @Orig_candidate_church_others VARCHAR(100)

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));																									

	SELECT  @Orig_candidate_salutation = Salutation, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_occupation = Occupation,
			@Orig_candidate_dob = ISNULL(CONVERT(VARCHAR(15),DOB,103),''), @Orig_candidate_gender = Gender, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education,
			@Orig_candidate_contact = Contact, @Orig_candidate_church = CONVERT(VARCHAR(3),Church), @Orig_candidate_church_others = ChurchOthers
	FROM dbo.tb_visitors AS A
	WHERE A.NRIC = @candidate_original_nric;
	
	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_salutation <> @candidate_salutation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Salutation', (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @Orig_candidate_salutation), (SELECT SalutationName FROM dbo.tb_Salutation WHERE SalutationID = @candidate_salutation));		
	END

	IF(@Orig_candidate_english_name <> @candidate_english_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Name', @Orig_candidate_english_name, @candidate_english_name);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END
	
	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality);
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Occupation', (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @Orig_candidate_occupation), (SELECT OccupationName FROM dbo.tb_occupation WHERE OccupationID = @candidate_occupation);
	END

	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
	END

	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END

	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END

	IF(@Orig_candidate_education <> @candidate_education)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));		
	END

	IF(@Orig_candidate_contact <> @candidate_contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Contact', @Orig_candidate_contact, @candidate_contact);
	END
	
	IF(@Orig_candidate_church <> @candidate_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Church', (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_candidate_church), (SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @candidate_church);
	END

	IF(@Orig_candidate_church_others <> @candidate_churchOthers)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Church Others', @Orig_candidate_church_others, @candidate_churchOthers);
	END
		
	DECLARE @returnTable TABLE (
		FromTo XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		IF(LEN(@candidate_dob) = 0)
		BEGIN
			SET @candidate_dob = NULL;
		END
		
		UPDATE tb_visitors SET   Salutation = @candidate_salutation,
							NRIC = @candidate_nric,
							EnglishName = @candidate_english_name,
							AddressUnit = @candidate_unit,
							AddressHouseBlk = @candidate_blk_house,
							Nationality = @candidate_nationality,
							Occupation = @candidate_occupation,
							DOB = CONVERT(DATE, @candidate_dob, 103),
							Gender = @candidate_gender,
							AddressStreet = @candidate_street_address,
							AddressPostalCode = @candidate_postal_code,
							Contact = @candidate_contact,
							Email = @candidate_email,
							Education = @candidate_education,
							Church = CONVERT(TINYINT,@candidate_church),
							ChurchOthers = @candidate_churchOthers
		WHERE NRIC = @candidate_original_nric
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'VisitorMembership', 'UpdateVisitor', 1, 'NRIC', @candidate_nric, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END
END
ELSE
BEGIN		
	SELECT 'NotFound' AS Result
END

SET NOCOUNT OFF;
GO
