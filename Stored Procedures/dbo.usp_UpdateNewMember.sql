SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateNewMember]
(@updateXML XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_salutation VARCHAR(4),
@candidate_photo VARCHAR(1000),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_dialect VARCHAR(4),
@candidate_occupation VARCHAR(4),
@baptized_by VARCHAR(50),
@baptism_church VARCHAR(4),
@confirmation_by VARCHAR(50),
@confirmation_church VARCHAR(4),
@previous_church_membership VARCHAR(4),
@candidate_chinses_name NVARCHAR(50),
@candidate_nric VARCHAR(10),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_marital_status VARCHAR(3),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_education VARCHAR(3),
@candidate_language VARCHAR(200),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_baptism_date VARCHAR(15),
@candidate_confirmation_date VARCHAR(15),
@candidate_marriage_date VARCHAR(15),
@candidate_congregation VARCHAR(3),
@candidate_sponsor1 VARCHAR(20),
@candidate_sponsor2 VARCHAR(100),
@candidate_sponsor2contact VARCHAR(100),
@family XML,
@child XML,
@TransferReason VARCHAR(1000),
@InterestedCellgroup VARCHAR(1),
@InterestedMinistry XML,
@InterestedServeCongregation VARCHAR(1),
@InterestedTithing VARCHAR(1),
@baptism_by_others VARCHAR(100),
@confirm_by_others VARCHAR(100),
@baptism_church_others VARCHAR(100),
@confirm_church_others VARCHAR(100),
@previous_church_others VARCHAR(100)

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_chinses_name = ChineseName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_marital_status = MaritalStatus, @candidate_marriage_date = MarriageDate, @candidate_nationality = Nationality,
	@candidate_dialect = Dialect, @candidate_photo = Photo, @candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_language = [Language], @candidate_occupation = Occupation,
	@baptized_by = BaptismBy, @candidate_baptism_date = BaptismDate, @baptism_church = BaptismChurch, @confirmation_by = ConfirmationBy,
	@confirmation_church = ConfirmationChurch, @candidate_confirmation_date = ConfirmationDate, @previous_church_membership = PreviousChurchMembership,
	@family = FamilyXML, @child = ChildXML, @candidate_sponsor1 = Sponsor1, @candidate_sponsor2 = Sponsor2, @candidate_sponsor2contact = Sponsor2Contact, @candidate_congregation = Congregation,
	@InterestedCellgroup = InterestedCellgroup, @InterestedMinistry = InterestedMinistry, @InterestedServeCongregation = InterestedServeCongregation,
	@InterestedTithing = InterestedTithing, @TransferReason = TransferReason,
	@baptism_by_others = BaptismByOthers, @confirm_by_others = ConfirmByOthers, @baptism_church_others = BaptismChurchOthers, @confirm_church_others = ConfirmChurchOthers, @previous_church_others = PreviousChurchOthers
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNRIC',
	NRIC VARCHAR(20)'./NRIC',
	Salutation VARCHAR(3) './Salutation',
	EnglishName VARCHAR(50) './EnglishName',
	ChineseName NVARCHAR(50) './ChineseName',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	MaritalStatus VARCHAR(3) './MaritalStatus',
	MarriageDate VARCHAR(20) './MarriageDate',
	Nationality VARCHAR(3) './Nationality',
	Dialect VARCHAR(3) './Dialect',
	Photo VARCHAR(1000) './Photo',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	Email VARCHAR(100) './Email',
	Education VARCHAR(3) './Education',
	[Language] VARCHAR(200) './Language',
	Occupation VARCHAR(3) './Occupation',
	Congregation VARCHAR(3) './Congregation',
	BaptismBy VARCHAR(20) './BaptismBy',
	BaptismDate VARCHAR(10) './BaptismDate',
	BaptismChurch VARCHAR(3) './BaptismChurch',
	ConfirmationBy VARCHAR(20) './ConfirmationBy',
	ConfirmationChurch VARCHAR(3) './ConfirmationChurch',
	ConfirmationDate VARCHAR(10) './ConfirmationDate',
	PreviousChurchMembership VARCHAR(3) './PreviousChurchMembership',
	FamilyXML XML './FamilyXML/FamilyList',
	ChildXML XML './ChildXML/ChildList',
	Sponsor1 VARCHAR(20) './Sponsor1',
	Sponsor2 VARCHAR(100) './Sponsor2',
	Sponsor2Contact VARCHAR(100) './Sponsor2Contact',
	InterestedCellgroup VARCHAR(1) './InterestedCellgroup',
	InterestedMinistry XML './InterestedMinistry/Ministry',
	InterestedServeCongregation VARCHAR(1) './InterestedServeCongregation',
	TransferReason VARCHAR(1000) './TransferReason',
	InterestedTithing VARCHAR(1) './InterestedTithing',
	BaptismByOthers VARCHAR(100) './BaptismByOthers',
	BaptismChurchOthers VARCHAR(100) './BaptismChurchOthers',
	ConfirmByOthers VARCHAR(100) './ConfirmByOthers',
	ConfirmChurchOthers VARCHAR(100) './ConfirmChurchOthers',
	PreviousChurchOthers VARCHAR(100) './PreviousChurchOthers');

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

IF(LEN(@candidate_marital_status) = 0)
BEGIN
	SET @candidate_marital_status = '0'
END

IF(LEN(@candidate_education) = 0)
BEGIN
	SET @candidate_education = '0'
END

IF(LEN(@candidate_congregation) = 0)
BEGIN
	SET @candidate_congregation = '0'
END

IF(LEN(@candidate_dialect) = 0)
BEGIN
	SET @candidate_dialect = '0'
END

IF(LEN(@previous_church_membership) = 0)
BEGIN
	SET @previous_church_membership = '0'
END

IF(LEN(@baptism_church) = 0)
BEGIN
	SET @baptism_church = '0'
END

IF(LEN(@confirmation_church) = 0)
BEGIN
	SET @confirmation_church = '0'
END

IF(LEN(@candidate_baptism_date) = 0)
BEGIN
	SET @candidate_baptism_date = NULL;
END

IF(LEN(@candidate_marriage_date) = 0)
BEGIN
	SET @candidate_marriage_date = NULL;
END

if(LEN(@candidate_confirmation_date) = 0)
BEGIN
	SET @candidate_confirmation_date = NULL;
END

IF EXISTS( SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	DECLARE @Orig_candidate_salutation VARCHAR(4)
	DECLARE @Orig_candidate_photo VARCHAR(1000)
	DECLARE @Orig_candidate_english_name VARCHAR(50)
	DECLARE @Orig_candidate_unit VARCHAR(10)
	DECLARE @Orig_candidate_blk_house VARCHAR(10)
	DECLARE @Orig_candidate_nationality VARCHAR(4)
	DECLARE @Orig_candidate_dialect VARCHAR(4)
	DECLARE @Orig_candidate_occupation VARCHAR(4)
	DECLARE @Orig_baptized_by VARCHAR(50)
	DECLARE @Orig_baptism_church VARCHAR(4)
	DECLARE @Orig_confirmation_by VARCHAR(50)
	DECLARE @Orig_confirmation_church VARCHAR(4)
	DECLARE @Orig_previous_church_membership VARCHAR(4)
	DECLARE @Orig_candidate_chinses_name NVARCHAR(50)
	DECLARE @Orig_candidate_nric VARCHAR(10)
	DECLARE @Orig_candidate_dob DATETIME
	DECLARE @Orig_candidate_gender VARCHAR(1)
	DECLARE @Orig_candidate_marital_status VARCHAR(3)
	DECLARE @Orig_candidate_street_address VARCHAR(1000)
	DECLARE @Orig_candidate_postal_code INT
	DECLARE @Orig_candidate_email VARCHAR(100)
	DECLARE @Orig_candidate_education VARCHAR(3)
	DECLARE @Orig_candidate_language VARCHAR(200)
	DECLARE @Orig_candidate_home_tel VARCHAR(15)
	DECLARE @Orig_candidate_mobile_tel VARCHAR(15)
	DECLARE @Orig_candidate_baptism_date VARCHAR(15)
	DECLARE @Orig_candidate_confirmation_date VARCHAR(15)
	DECLARE @Orig_candidate_marriage_date VARCHAR(15)
	DECLARE @Orig_candidate_congregation VARCHAR(3)
	DECLARE @Orig_candidate_electoralroll VARCHAR(15)
	DECLARE @Orig_candidate_cellgroup VARCHAR(3)
	DECLARE @Orig_candidate_sponsor1 VARCHAR(20)
	DECLARE @Orig_candidate_sponsor2 VARCHAR(100)
	DECLARE @Orig_candidate_sponsor2contact VARCHAR(100)
	DECLARE @Orig_candidate_ministry XML
	DECLARE @Orig_candidate_DeceasedDate VARCHAR(15)
	DECLARE @Orig_candidate_TransferReason VARCHAR(1000)
	DECLARE @Orig_family XML
	DECLARE @Orig_child XML
	DECLARE @Orig_InterestedCellgroup VARCHAR(1),
	@Orig_InterestedMinistry XML,
	@Orig_InterestedServeCongregation VARCHAR(1),
	@Orig_InterestedTithing VARCHAR(1)
	
	DECLARE @Orig_baptism_by_others VARCHAR(100),
	@Orig_confirm_by_others VARCHAR(100),
	@Orig_baptism_church_others VARCHAR(100),
	@Orig_confirm_church_others VARCHAR(100),
	@Orig_previous_church_others VARCHAR(100)

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));
	
	DECLARE @FamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @OriginalFamilyTable TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
								
	DECLARE @FamilyAdded TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	DECLARE @FamilyRemoved TABLE (FamilyType VARCHAR(100),
								FamilyEnglishName VARCHAR(100),
								FamilyChineseName VARCHAR(100),
								FamilyOccupation VARCHAR(100),
								FamilyReligion VARCHAR(100))
	
	DECLARE @ChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @OriginalChildTable TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildAdded TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	DECLARE @ChildRemoved TABLE (ChildEnglishName VARCHAR(100),
								ChildChineseName VARCHAR(100),
								ChildBaptismDate VARCHAR(100),
								ChildBaptismBy VARCHAR(100),
								ChildChurch VARCHAR(100))
	
	DECLARE @MinistryTable TABLE (MinistryID VARCHAR(100),
								  MinistryName VARCHAR(100))
	DECLARE @OriginalMinistryTable TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
	DECLARE @MinistryTableAdded TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))
    DECLARE @MinistryTableRemoved TABLE (MinistryID VARCHAR(100),
										  MinistryName VARCHAR(100))										  
																																

	SELECT  @Orig_candidate_salutation = Salutation, @Orig_candidate_photo = ICPhoto, @Orig_candidate_english_name = EnglishName, @Orig_candidate_unit = AddressUnit,
			@Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_dialect = Dialect, @Orig_candidate_occupation = Occupation, @Orig_baptized_by = BaptismBy, @Orig_baptism_church = BaptismChurch,
			@Orig_confirmation_by = ConfirmBy, @Orig_confirmation_church = ConfirmChurch, @Orig_previous_church_membership = PreviousChurch, @Orig_candidate_chinses_name = ChineseName,
			@Orig_candidate_dob = DOB, @Orig_candidate_gender = Gender, @Orig_candidate_marital_status = MaritalStatus, @Orig_candidate_street_address = AddressStreet,
			@Orig_candidate_postal_code = AddressPostalCode, @Orig_candidate_email = Email, @Orig_candidate_education = Education, @Orig_candidate_language = [Language],
			@Orig_candidate_home_tel = HomeTel, @Orig_candidate_mobile_tel = MobileTel, @Orig_candidate_baptism_date = CONVERT(VARCHAR(15), BaptismDate,103), @Orig_candidate_confirmation_date = CONVERT(VARCHAR(15), ConfirmDate, 103),
			@Orig_candidate_marriage_date = CONVERT(VARCHAR(15),MarriageDate, 103), @Orig_family = Family, @Orig_child = Child, @Orig_candidate_congregation = Congregation, @Orig_candidate_sponsor1 = Sponsor1, @Orig_candidate_sponsor2 = Sponsor2, @Orig_candidate_sponsor2contact = Sponsor2Contact,
			@Orig_candidate_ministry = MinistryInvolvement, @Orig_candidate_DeceasedDate = CONVERT(VARCHAR(15), DeceasedDate, 103), @Orig_candidate_electoralroll = CONVERT(VARCHAR(15), ElectoralRoll, 103),
			@Orig_candidate_cellgroup = CellGroup, @Orig_InterestedCellgroup = B.CellgroupInterested, @Orig_InterestedMinistry = B.MinistryInterested, @Orig_InterestedServeCongregation = B.ServeCongregationInterested, @Orig_InterestedTithing = B.TithingInterested,
			@Orig_candidate_TransferReason = A.TransferReason,
			@Orig_baptism_by_others = BaptismByOthers,
			@Orig_confirm_by_others = ConfirmByOthers,
			@Orig_baptism_church_others = BaptismChurchOthers,
			@Orig_confirm_church_others = ConfirmChurchOthers,
			@Orig_previous_church_others = PreviousChurchOthers
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON B.NRIC = A.NRIC
	WHERE A.NRIC = @candidate_original_nric
	
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

	IF(@Orig_candidate_chinses_name <> @candidate_chinses_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Name', @Orig_candidate_chinses_name, @candidate_chinses_name);
	END

	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('ICPhoto', @Orig_candidate_photo, @candidate_photo);
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
	
	IF(@Orig_candidate_TransferReason <> @TransferReason)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transfer Reason', @Orig_candidate_TransferReason, @TransferReason);
	END

	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Nationality', @Orig_candidate_nationality, @candidate_nationality);
	END

	IF(@Orig_candidate_dialect <> @candidate_dialect)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Dialect', (SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @Orig_candidate_dialect), (SELECT DialectName FROM dbo.tb_dialect WHERE DialectID = @candidate_dialect));
	END

	IF(@Orig_candidate_occupation <> @candidate_occupation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Occupation', @Orig_candidate_occupation, @candidate_occupation);
	END

	IF(@Orig_baptized_by <> @baptized_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptised By', @Orig_baptized_by, @baptized_by);
	END

	IF(@Orig_baptism_church <> @baptism_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Church', @Orig_baptism_church, @baptism_church);
	END

	IF(ISNULL(@Orig_candidate_baptism_date,'') <> ISNULL(@candidate_baptism_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Date', ISNULL(@Orig_candidate_baptism_date,''), ISNULL(@candidate_baptism_date,''));
	END

	IF(@Orig_confirmation_by <> @confirmation_by)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation By', @Orig_confirmation_by, @confirmation_by);
	END

	IF(@Orig_confirmation_church <> @confirmation_church)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation Church', @Orig_confirmation_church, @confirmation_church);
	END

	IF(ISNULL(@Orig_candidate_confirmation_date,'') <> ISNULL(@candidate_confirmation_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Conformation Date', ISNULL(@Orig_candidate_confirmation_date,''), ISNULL(@candidate_confirmation_date,''));
	END

	IF(@Orig_previous_church_membership <> @previous_church_membership)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Previous Church Membership', ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @Orig_previous_church_membership),''), ISNULL((SELECT ParishName FROM dbo.tb_parish WHERE ParishID = @previous_church_membership),''));
	END

	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date Of Birth', @Orig_candidate_dob, @candidate_dob);
	END

	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END

	IF(@Orig_candidate_marital_status <> @candidate_marital_status)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Marital Status', @Orig_candidate_marital_status, @candidate_marital_status);
	END

	IF(ISNULL(@Orig_candidate_marriage_date,'') <> ISNULL(@candidate_marriage_date,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Marriage Date', ISNULL(@Orig_candidate_marriage_date,''), ISNULL(@candidate_marriage_date,''));
	END

	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END

	IF(@Orig_candidate_education <> @candidate_education)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Education', (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @Orig_candidate_education), (SELECT EducationName FROM dbo.tb_education WHERE EducationID = @candidate_education));		
	END

	IF(@Orig_candidate_language <> @candidate_language)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Language', @Orig_candidate_language, @candidate_language);
	END

	IF(@Orig_candidate_home_tel <> @candidate_home_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Home Tel', @Orig_candidate_home_tel, @candidate_home_tel);
	END

	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
	END

	IF(@Orig_candidate_congregation <> @candidate_congregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Congregation', @Orig_candidate_congregation, @candidate_congregation);
	END

	IF(@Orig_candidate_sponsor1 <> @candidate_sponsor1)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 1', @Orig_candidate_sponsor1, @candidate_sponsor1);
	END

	IF(@Orig_candidate_sponsor2 <> @candidate_sponsor2)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2', @Orig_candidate_sponsor2, @candidate_sponsor2);
	END
	
	IF(@Orig_candidate_sponsor2contact <> @candidate_sponsor2contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Sponsor 2 Contact', @Orig_candidate_sponsor2contact, @candidate_sponsor2contact);
	END
	
	IF(@Orig_InterestedCellgroup <> @InterestedCellgroup)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Join Cellgroup', REPLACE(REPLACE(@Orig_InterestedCellgroup , '1', 'Yes'), '0', 'No'), REPLACE(REPLACE(@InterestedCellgroup , '1', 'Yes'), '0', 'No'));
	END
	
	IF(@Orig_InterestedServeCongregation <> @InterestedServeCongregation)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Serve Congregation', REPLACE(REPLACE(@Orig_InterestedServeCongregation , '1', 'Yes'), '0', 'No'), REPLACE(REPLACE(@InterestedServeCongregation , '1', 'Yes'), '0', 'No'));
	END
	
	IF(@Orig_InterestedTithing <> @InterestedTithing)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Give Tithing', REPLACE(REPLACE(@Orig_InterestedTithing , '1', 'Yes'), '0', 'No'), REPLACE(REPLACE(@InterestedTithing , '1', 'Yes'), '0', 'No'));
	END
	
	IF(@Orig_baptism_by_others <> @baptism_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_baptism_by_others, @baptism_by_others);
	END
	IF(@Orig_confirm_by_others <> @confirm_by_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm By Others', @Orig_confirm_by_others, @confirm_by_others);
	END
	IF(@Orig_baptism_church_others <> @baptism_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism Church By Others', @Orig_baptism_church_others, @baptism_church_others);
	END
	IF(@Orig_confirm_church_others <> @confirm_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Confirm Church By Others', @Orig_confirm_church_others, @confirm_church_others);
	END
	IF(@Orig_previous_church_others <> @previous_church_others)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Baptism By Others', @Orig_previous_church_others, @previous_church_others);
	END
	
	DECLARE @xdoc int;
	DECLARE @familyxml AS XML = (SELECT Family FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;

	INSERT INTO @OriginalFamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	SET @familyxml = @family;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @familyxml;
	
	INSERT INTO @FamilyTable (FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion) 
	Select FamilyReligion, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion
	from OpenXml(@xdoc, '/FamilyList/*')
	with (
	FamilyType VARCHAR(100) './FamilyType',
	FamilyEnglishName VARCHAR(100) './FamilyEnglishName',
	FamilyChineseName VARCHAR(100) './FamilyChineseName',
	FamilyOccupation VARCHAR(100) './FamilyOccupation',
	FamilyReligion VARCHAR(50) './FamilyReligion');
	
	INSERT INTO @FamilyAdded
	SELECT * FROM @FamilyTable WHERE FamilyEnglishName NOT IN (SELECT FamilyEnglishName FROM @OriginalFamilyTable)
	
	INSERT INTO @FamilyRemoved
	SELECT * FROM @OriginalFamilyTable WHERE FamilyEnglishName NOT IN (SELECT FamilyEnglishName FROM @FamilyTable)	
	
	-------------------------
	
	
	DECLARE @chilexml AS XML = (SELECT Child FROM dbo.tb_members_temp WHERE NRIC = @candidate_original_nric);
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;

	INSERT INTO @OriginalChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	SET @chilexml = @child;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @chilexml;
	
	INSERT INTO @ChildTable (ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch) 
	Select ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch
	from OpenXml(@xdoc, '/ChildList/*')
	with (
	ChildEnglishName VARCHAR(100) './ChildEnglishName',
	ChildChineseName VARCHAR(100) './ChildChineseName',
	ChildBaptismDate VARCHAR(100) './ChildBaptismDate',
	ChildBaptismBy VARCHAR(100) './ChildBaptismBy',
	ChildChurch VARCHAR(50) './ChildChurch');
	
	INSERT INTO @ChildAdded
	SELECT * FROM @ChildTable WHERE ChildEnglishName NOT IN (SELECT ChildEnglishName FROM @OriginalChildTable)
	
	INSERT INTO @ChildRemoved
	SELECT * FROM @OriginalChildTable WHERE ChildEnglishName NOT IN (SELECT ChildEnglishName FROM @ChildTable)	
	
	--------------
	
	
	DECLARE @ministryxml AS VARCHAR(MAX) = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),@Orig_InterestedMinistry), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');

	INSERT INTO @OriginalMinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	SET @ministryxml = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),@InterestedMinistry), '<Ministry>', ''), '</Ministry>', ''), '</MinistryID><MinistryID>', ','), '</MinistryID>', ''), '<MinistryID>', ''), '<Ministry/>', '');
	
	INSERT INTO @MinistryTable (MinistryID, MinistryName) 
	SELECT ITEMS, MinistryName FROM dbo.udf_Split(@ministryxml, ',')
	INNER JOIN dbo.tb_ministry ON MinistryID = ITEMS
	
	INSERT INTO @MinistryTableAdded
	SELECT * FROM @MinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @OriginalMinistryTable)
	
	INSERT INTO @MinistryTableRemoved
	SELECT * FROM @OriginalMinistryTable WHERE MinistryID NOT IN (SELECT MinistryID FROM @MinistryTable)	
	
	--------------
	
	
	
	DECLARE @returnTable TABLE (
		FromTo XML,
		FamilyRemoved XML,
		FamilyAdded XML,
		ChildRemoved XML,
		ChileAdded XML,
		MinistryInterestedAdded XML,
		MinistryInterestedRemoved XML);
		
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	OR EXISTS (SELECT 1 FROM @FamilyRemoved)
	OR EXISTS (SELECT 1 FROM @FamilyAdded)
	OR EXISTS (SELECT 1 FROM @ChildAdded)
	OR EXISTS (SELECT 1 FROM @ChildRemoved)
	OR EXISTS (SELECT 1 FROM @MinistryTableAdded)
	OR EXISTS (SELECT 1 FROM @MinistryTableRemoved)
	BEGIN
		INSERT INTO @returnTable (FromTo, FamilyRemoved, FamilyAdded, MinistryInterestedRemoved, MinistryInterestedAdded, ChildRemoved, ChileAdded)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyRemoved FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT FamilyType, FamilyEnglishName, FamilyChineseName, FamilyOccupation, FamilyReligion FROM @FamilyAdded FOR XML RAW('Family'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableRemoved FOR XML RAW('MinistryInterested'), ELEMENTS)),
		(SELECT (SELECT MinistryName FROM @MinistryTableAdded FOR XML RAW('MinistryInterested'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildRemoved FOR XML RAW('Child'), ELEMENTS)),
		(SELECT (SELECT ChildEnglishName, ChildChineseName, ChildBaptismDate, ChildBaptismBy, ChildChurch FROM @ChildAdded FOR XML RAW('Child'), ELEMENTS));
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo, FamilyRemoved, FamilyAdded, ChildRemoved, ChileAdded, MinistryInterestedRemoved, MinistryInterestedAdded FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		
		
		UPDATE tb_members_temp SET   Salutation = @candidate_salutation,
							NRIC = @candidate_nric,
							ICPhoto = @candidate_photo,
							EnglishName = @candidate_english_name,
							AddressUnit = @candidate_unit,
							AddressHouseBlk = @candidate_blk_house,
							Nationality = @candidate_nationality,
							Dialect = @candidate_dialect,
							Occupation = @candidate_occupation,
							BaptismBy = @baptized_by,
							BaptismChurch = @baptism_church,
							ConfirmBy = @confirmation_by,
							ConfirmChurch = @confirmation_church,
							PreviousChurch = @previous_church_membership,
							ChineseName = @candidate_chinses_name,
							DOB = @candidate_dob,
							Gender = @candidate_gender,
							MaritalStatus = @candidate_marital_status,
							AddressStreet = @candidate_street_address,
							AddressPostalCode = @candidate_postal_code,
							Email = @candidate_email,
							Education = @candidate_education,
							[Language] = @candidate_language,
							HomeTel = @candidate_home_tel,
							MobileTel = @candidate_mobile_tel,
							TransferReason = @TransferReason,
							BaptismDate = CONVERT(DATETIME, @candidate_baptism_date, 103),
							ConfirmDate = CONVERT(DATETIME, @candidate_confirmation_date, 103),
							MarriageDate = CONVERT(DATETIME, @candidate_marriage_date, 103),
							CurrentParish = @CurrentParish,
							Family = @family,
							Child = @child,
							BaptismByOthers = @baptism_by_others,
							ConfirmByOthers = @confirm_by_others,
							BaptismChurchOthers = @baptism_church_others,
							ConfirmChurchOthers = @confirm_church_others,
							PreviousChurchOthers = @previous_church_others
		WHERE NRIC = @candidate_original_nric
			
		UPDATE dbo.tb_membersOtherInfo_temp SET Congregation = @candidate_congregation,
									   NRIC = @candidate_nric,
									   CellgroupInterested = @InterestedCellgroup,
									   MinistryInterested = @InterestedMinistry,
									   ServeCongregationInterested = @InterestedServeCongregation,
									   TithingInterested = @InterestedTithing,
									   Sponsor1 = @candidate_sponsor1,
									   Sponsor2 = @candidate_sponsor2,
									   Sponsor2Contact = @candidate_sponsor2contact
		WHERE NRIC = @candidate_original_nric
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'Membership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
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
