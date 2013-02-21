SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCityKid]
(@newXML AS XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
@candidate_photo VARCHAR(1000),
@candidate_english_name VARCHAR(50),
@candidate_unit VARCHAR(10),
@candidate_blk_house VARCHAR(10),
@candidate_nationality VARCHAR(4),
@candidate_race VARCHAR(4),
@candidate_school VARCHAR(4),
@candidate_religion VARCHAR(4),
@candidate_emergency_contact VARCHAR(15),
@candidate_emergency_relationship VARCHAR(50),
@candidate_nric VARCHAR(20),
@candidate_dob DATETIME,
@candidate_gender VARCHAR(1),
@candidate_street_address VARCHAR(1000),
@candidate_postal_code INT,
@candidate_email VARCHAR(100),
@candidate_home_tel VARCHAR(15),
@candidate_mobile_tel VARCHAR(15),
@candidate_specialneed VARCHAR(1000)




DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @newXML;
	
    SELECT @UserID = EnteredBy, @candidate_photo = Photo, @candidate_english_name = EnglishName, 
    @candidate_unit = AddressUnit, @candidate_blk_house = AddressBlkHouse, @candidate_nationality = Nationality, @candidate_race = Race,
    @candidate_school = School, @candidate_religion = Religion, @candidate_emergency_contact = NOKContact, @candidate_emergency_relationship = NOKRelationship,
    @candidate_nric = NRIC, @candidate_dob = CONVERT(DATETIME, DOB, 103), @candidate_gender = Gender, @candidate_street_address = AddressStreetName,
    @candidate_postal_code = AddressPostalCode, @candidate_email = Email, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
    @candidate_specialneed = SpecialNeeds
	FROM OPENXML(@idoc, '/New')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
	Photo VARCHAR(1000) './Photo',
	EnglishName VARCHAR(50) './Name',
	AddressUnit VARCHAR(10) './AddressUnit',
	AddressBlkHouse VARCHAR(10) './AddressBlkHouse',
	Nationality VARCHAR(3) './Nationality',
	Race VARCHAR(3) './Race',
	School VARCHAR(3) './School',
	Religion VARCHAR(3) './Religion',
	NOKContact VARCHAR(15) './NOKContact',
	NOKRelationship VARCHAR(50) './NOKRelationship',
	NRIC VARCHAR(20)'./NRIC',
	DOB VARCHAR(10) './DOB',
	Gender VARCHAR(1) './Gender',
	AddressStreetName VARCHAR(100) './AddressStreetName',
	AddressPostalCode INT './AddressPostalCode',
	Email VARCHAR(100) './Email',
	HomeTel VARCHAR(15) './HomeTel',
	MobileTel VARCHAR(15) './MobileTel',
	SpecialNeeds VARCHAR(1000) './SpecialNeeds');
	
	
IF NOT EXISTS( SELECT * FROM dbo.tb_ccc_kids WHERE NRIC = @candidate_nric)
BEGIN
	
	INSERT INTO dbo.tb_ccc_kids(NRIC, Name, Gender, DOB, HomeTel, MobileTel, AddressHouseBlk, AddressPostalCode,
				AddressStreet, AddressUnit, Email, SpecialNeeds, EmergencyContact, EmergencyContactName,
				Religion, Race, Nationality, School, Photo)
	SELECT @candidate_nric, @candidate_english_name, @candidate_gender, @candidate_dob, @candidate_home_tel, @candidate_mobile_tel,
	       @candidate_blk_house, @candidate_postal_code, @candidate_street_address, @candidate_unit, @candidate_email, @candidate_specialneed,
	       @candidate_emergency_contact, @candidate_emergency_relationship, @candidate_religion, @candidate_race, @candidate_nationality,
	       @candidate_school, @candidate_photo
	
	DECLARE @rowcount INT = @@ROWCOUNT;	
	
	DECLARE @newKidXML XML = (SELECT NRIC, Name, Gender, DOB, HomeTel, MobileTel, AddressHouseBlk, AddressPostalCode,
										AddressStreet, AddressUnit, Email, SpecialNeeds, EmergencyContact, EmergencyContactName,
										ISNULL(B.ReligionName, '') AS Religion, ISNULL(C.RaceName, '') AS Race, ISNULL(D.CountryName, '') AS Nationality, ISNULL(E.SchoolName, '') AS School, Photo
								 FROM dbo.tb_ccc_kids AS A
								 LEFT OUTER JOIN dbo.tb_religion AS B ON A.Religion = B.ReligionID
								 LEFT OUTER JOIN dbo.tb_race AS C ON A.Race = C.RaceID
								 LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
								 LEFT OUTER JOIN dbo.tb_school AS E ON A.School = E.SchoolID
								 WHERE NRIC = @candidate_nric
								 FOR XML PATH, ELEMENTS)
	SELECT ISNULL(@rowcount, 0) AS Result
	EXEC dbo.usp_insertlogging 'I', @UserID, 'CityKidMembership', 'New', 1, 'NRIC', @candidate_nric, @newKidXML;								 
	
END	

SELECT 0 AS Result

SET NOCOUNT OFF;
GO
