SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_updateCityKid]
(@updateXML XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_original_nric VARCHAR(20),
@candidate_photo VARCHAR(1000),
@candidate_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_race VARCHAR(4),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_school VARCHAR(4),
@candidate_religion VARCHAR(4),
@candidate_NOK_contact VARCHAR(15),
@candidate_NOK_name VARCHAR(50),
@candidate_special_needs VARCHAR(1000),
@candidate_transport VARCHAR(1),
@candidate_club_group VARCHAR(4),
@candidate_bus_group VARCHAR(4),
@candidate_remarks VARCHAR(1000)

DECLARE @Orig_candidate_photo VARCHAR(1000),
@Orig_candidate_name VARCHAR(50),
@Orig_candidate_unit VARCHAR(10),
@Orig_candidate_blk_house VARCHAR(10),
@Orig_candidate_nationality VARCHAR(4),
@Orig_candidate_nric VARCHAR(20),
@Orig_candidate_dob DATETIME,
@Orig_candidate_gender VARCHAR(1),
@Orig_candidate_race VARCHAR(4),
@Orig_candidate_street_address VARCHAR(1000),
@Orig_candidate_postal_code INT,
@Orig_candidate_email VARCHAR(100),
@Orig_candidate_home_tel VARCHAR(15),
@Orig_candidate_mobile_tel VARCHAR(15),
@Orig_candidate_school VARCHAR(4),
@Orig_candidate_religion VARCHAR(4),
@Orig_candidate_NOK_contact VARCHAR(15),
@Orig_candidate_NOK_name VARCHAR(50),
@Orig_candidate_special_needs VARCHAR(1000),
@Orig_candidate_transport VARCHAR(1),
@Orig_candidate_club_group VARCHAR(4),
@Orig_candidate_bus_group VARCHAR(4),
@Orig_candidate_remarks VARCHAR(1000)

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;
	
    SELECT @UserID = EnteredBy, @candidate_original_nric = OriginalNric, @candidate_photo = Photo , @candidate_name = Name, 
		   @candidate_unit = AddressUnit, @candidate_blk_house = AddressBlkHouse, @candidate_nationality = Nationality, @candidate_nric = NRIC,
		   @candidate_dob = CONVERT(DATETIME, DOB, 103), @candidate_gender = Gender, @candidate_race = Race, @candidate_street_address = AddressStreetName,
		   @candidate_postal_code = AddressPostalCode, @candidate_email = Email, @candidate_home_tel = HomeTel, 
		   @candidate_mobile_tel = MobileTel, @candidate_school = School, @candidate_religion = Religion, @candidate_NOK_contact = NOKContact,
		   @candidate_NOK_name = NOKName, @candidate_special_needs = SpecialNeeds, @candidate_transport = Transport, 
		   @candidate_club_group = Clubgroup, @candidate_bus_group = Busgroup, @candidate_remarks = Remarks
	FROM OPENXML(@idoc, '/Update')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	OriginalNric VARCHAR(20)'./OriginalNric',
	NRIC VARCHAR(20)'./NRIC',
	Name VARCHAR(50) './Name',
	Gender VARCHAR(1) './Gender',
	DOB VARCHAR(10) './DOB',
	Nationality VARCHAR(4) './Nationality',
	Photo VARCHAR(1000) './Photo',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	AddressUnit VARCHAR(10) './AddressUnit',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	Email VARCHAR(100) './Email',
	Race VARCHAR(4) './Race',
	School VARCHAR(4) './School',
	Religion VARCHAR(4) './Religion',
	NOKContact VARCHAR(15) './NOKContact',
	NOKName VARCHAR(50) './NOKName',
	SpecialNeeds VARCHAR(1000) './SpecialNeeds',
	Transport VARCHAR(1) './Transport',
	Clubgroup VARCHAR(4) './Clubgroup',
	Busgroup VARCHAR(4) './Busgroup',
	Remarks VARCHAR(1000) './Remarks');

DECLARE @rowcount INT
SET @rowcount = 0

IF(LEN(@candidate_club_group) = 0)
BEGIN
	SET @candidate_club_group = '0'
END

IF(LEN(@candidate_religion) = 0)
BEGIN
	SET @candidate_religion = '0'
END

IF(LEN(@candidate_bus_group) = 0)
BEGIN
	SET @candidate_bus_group = '0'
END

IF(LEN(@candidate_nationality) = 0)
BEGIN
	SET @candidate_nationality = '0'
END

IF(LEN(@candidate_race) = 0)
BEGIN
	SET @candidate_race = '0'
END

IF(LEN(@candidate_school) = 0)
BEGIN
	SET @candidate_school = '0'
END

IF EXISTS( SELECT 1 FROM dbo.tb_ccc_kids WHERE NRIC = @candidate_original_nric)
BEGIN

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));

	SELECT  @Orig_candidate_photo = Photo, @Orig_candidate_name = Name, @Orig_candidate_unit = AddressUnit, 
	        @Orig_candidate_blk_house = AddressHouseBlk, @Orig_candidate_nationality = Nationality, @Orig_candidate_nric = NRIC, @Orig_candidate_dob = DOB,
			@Orig_candidate_gender = Gender, @Orig_candidate_race = Race, @Orig_candidate_street_address = AddressStreet, @Orig_candidate_postal_code = AddressPostalCode,
            @Orig_candidate_email = Email, @Orig_candidate_home_tel = HomeTel, @Orig_candidate_mobile_tel = MobileTel, @Orig_candidate_school = School,
            @Orig_candidate_religion = Religion, @Orig_candidate_NOK_contact = EmergencyContact, @Orig_candidate_NOK_name = EmergencyContactName,
            @Orig_candidate_special_needs = SpecialNeeds,  @Orig_candidate_transport = Transport, @Orig_candidate_club_group = ClubGroup,
			@Orig_candidate_bus_group = BusGroupCluster, @Orig_candidate_remarks = Remarks 	FROM dbo.tb_ccc_kids 
	WHERE NRIC = @candidate_original_nric


	IF(@candidate_original_nric <> @candidate_nric)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('NRIC', @candidate_original_nric, @candidate_nric);		
		UPDATE dbo.tb_DOSLogging SET Reference = @candidate_nric WHERE Reference = @candidate_original_nric
	END
	
	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('ICPhoto', @Orig_candidate_photo, @candidate_photo);
	END
	
	IF(@Orig_candidate_name <> @candidate_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Name', @Orig_candidate_name, @candidate_name);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Unit', @Orig_candidate_unit, @candidate_unit);
	END
	
	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address BLK/House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_nationality <> @candidate_nationality)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Nationality', (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @Orig_candidate_nationality), (SELECT CountryName FROM dbo.tb_country WHERE CountryID = @candidate_nationality)
		
	END
	
	IF(@Orig_candidate_dob <> @candidate_dob)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Date of Birth', Convert(VARCHAR(10), @Orig_candidate_dob, 103), Convert(VARCHAR(10), @candidate_dob, 103));
	END
	
	IF(@Orig_candidate_gender <> @candidate_gender)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Gender', @Orig_candidate_gender, @candidate_gender);
	END
	
	IF(@Orig_candidate_race <> @candidate_race)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Race', (SELECT RaceName FROM dbo.tb_race WHERE RaceID = @Orig_candidate_race), (SELECT RaceName FROM dbo.tb_race WHERE RaceID = @candidate_race);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Street', @Orig_candidate_street_address, @candidate_street_address);
	END
	
	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Address Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END
	
	IF(@Orig_candidate_email <> @candidate_email)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Email', @Orig_candidate_email, @candidate_email);
	END
	
	IF(@Orig_candidate_home_tel <> @candidate_home_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Home Tel', @Orig_candidate_home_tel, @candidate_home_tel);
	END
	
	IF(@Orig_candidate_mobile_tel <> @candidate_mobile_tel)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Mobile Tel', @Orig_candidate_mobile_tel, @candidate_mobile_tel);
	END
	
	IF(@Orig_candidate_school <> @candidate_school)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'School', (SELECT SchoolName FROM dbo.tb_school WHERE SchoolID = @Orig_candidate_school), (SELECT SchoolName FROM dbo.tb_school WHERE SchoolID = @candidate_school);
	END
	
	IF(@Orig_candidate_religion <> @candidate_religion)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Religion', ISNULL((SELECT ReligionName FROM dbo.tb_religion WHERE ReligionID = @Orig_candidate_religion),''), ISNULL((SELECT ReligionName FROM dbo.tb_religion WHERE ReligionID = @candidate_religion),'');
	END
	
	IF(@Orig_candidate_NOK_contact <> @candidate_NOK_contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next Of Kin Contact', @Orig_candidate_NOK_contact, @candidate_NOK_contact);
	END
	
	IF(@Orig_candidate_NOK_name <> @candidate_NOK_name)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next Of Kin Name', @Orig_candidate_NOK_name, @candidate_NOK_name);
	END
	
	IF(@Orig_candidate_special_needs <> @candidate_special_needs)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Special Needs', @Orig_candidate_special_needs, @candidate_special_needs);
	END
	
	IF(@Orig_candidate_transport <> @candidate_transport)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Transport', REPLACE(REPLACE(@Orig_candidate_transport,'0', 'False'),'1', 'True'), REPLACE(REPLACE(@candidate_transport,'0', 'False'),'1', 'True'));
	END
	
	IF(@Orig_candidate_club_group <> @candidate_club_group)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Club Group', (SELECT ClubGroupName FROM dbo.tb_clubgroup WHERE ClubGroupID = @Orig_candidate_club_group), (SELECT ClubGroupName FROM dbo.tb_clubgroup WHERE ClubGroupID = @candidate_club_group); 
	END
	
	IF(@Orig_candidate_bus_group <> @candidate_bus_group)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To])
		SELECT 'Bus Group / Cluster', (SELECT BusGroupClusterName FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID = @Orig_candidate_bus_group), (SELECT BusGroupClusterName FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID = @candidate_bus_group);
	END
	
	IF(@Orig_candidate_remarks <> @candidate_remarks)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Remarks', @Orig_candidate_remarks, @candidate_remarks);
	END
	
	
	DECLARE @returnTable TABLE (
		FromTo XML);
	
	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);
		
		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);
		
		UPDATE dbo.tb_ccc_kids SET
			NRIC = @candidate_nric, Name = @candidate_name, Gender = @candidate_gender, DOB = @candidate_dob, HomeTel = @candidate_home_tel,
			MobileTel = @candidate_mobile_tel, AddressStreet = @candidate_street_address, AddressHouseBlk = @candidate_blk_house,
			AddressPostalCode = @candidate_postal_code, AddressUnit = @candidate_unit, Email = @candidate_email,
			SpecialNeeds = @candidate_special_needs, EmergencyContact = @candidate_NOK_contact, EmergencyContactName = @candidate_NOK_name,
			Transport = @candidate_transport, Religion = @candidate_religion, Race = @candidate_race, Nationality = @candidate_nationality,
			School = @candidate_school, ClubGroup = @candidate_club_group, BusGroupCluster = @candidate_bus_group, Remarks = @candidate_remarks,
			Photo = @candidate_photo
		WHERE NRIC = @candidate_original_nric		
		
		
		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'CityKidMembership', 'Update', 1, 'NRIC', @candidate_nric, @changesXML;
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
