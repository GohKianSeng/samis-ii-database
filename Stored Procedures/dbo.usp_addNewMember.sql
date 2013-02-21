SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_addNewMember]
(@newXML AS XML)
AS
SET NOCOUNT ON;

DECLARE @UserID VARCHAR(50),
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
@candidate_nric VARCHAR(20),
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
@candidate_sponsor1 VARCHAR(10),
@candidate_sponsor2 VARCHAR(10),
@candidate_sponsor2contact VARCHAR(100),
@family XML,
@child XML,
@candidate_interested_ministry XML,
@candidate_join_cellgroup VARCHAR(1),
@candidate_serve_congregation VARCHAR(1),
@candidate_tithing VARCHAR(1),
@candidate_transfer_reason VARCHAR(1000),
@baptism_by_others VARCHAR(100),
@confirm_by_others VARCHAR(100),
@baptism_church_others VARCHAR(100),
@confirm_church_others VARCHAR(100),
@previous_church_others VARCHAR(100)





DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @newXML;
	
    SELECT @UserID = EnteredBy, @candidate_nric = NRIC, @candidate_salutation = Salutation,
	@candidate_english_name = EnglishName, @candidate_chinses_name = ChineseName, @candidate_gender = Gender, @candidate_dob = CONVERT(DATETIME, DOB, 103),
	@candidate_marital_status = MaritalStatus, @candidate_marriage_date = MarriageDate, @candidate_nationality = Nationality,
	@candidate_dialect = Dialect, @candidate_photo = Photo, @candidate_street_address = AddressStreetName, @candidate_blk_house = AddressBlkHouse,
	@candidate_postal_code = AddressPostalCode, @candidate_unit = AddressUnit, @candidate_home_tel = HomeTel, @candidate_mobile_tel = MobileTel,
	@candidate_email = Email, @candidate_education = Education, @candidate_language = [Language], @candidate_occupation = Occupation,
	@baptized_by = BaptismBy, @candidate_baptism_date = BaptismDate, @baptism_church = BaptismChurch, @confirmation_by = ConfirmationBy,
	@confirmation_church = ConfirmationChurch, @candidate_confirmation_date = ConfirmationDate, @previous_church_membership = PreviousChurchMembership,
	@family = FamilyXML, @child = ChildXML, @candidate_sponsor1 = Sponsor1, @candidate_sponsor2 = Sponsor2, @candidate_sponsor2contact= Sponsor2Contact,
	@candidate_transfer_reason = TransferReason, @candidate_congregation = Congregation,
	@candidate_serve_congregation = ServeCongregation, @candidate_interested_ministry = Ministry, @candidate_join_cellgroup = Cellgroup, @candidate_tithing = Tithing,
	@baptism_by_others = BaptismByOthers, @confirm_by_others = ConfirmByOthers, @baptism_church_others = BaptismChurchOthers, @confirm_church_others = ConfirmChurchOthers, @previous_church_others = PreviousChurchOthers
	FROM OPENXML(@idoc, '/New')
	WITH (
	EnteredBy VARCHAR(50)'./EnteredBy',
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
	TransferReason VARCHAR(1000) './TransferReason',
	FamilyXML XML './FamilyList',
	ChildXML XML './ChildList',
	ServeCongregation VARCHAR(1) './InterestedServeCongregation',
	Cellgroup VARCHAR(1) './InterestedCellgroup',
	Tithing VARCHAR(1) './InterestedTithing',
	Ministry XML './Ministry',
	Sponsor1 VARCHAR(20) './Sponsor1',
	Sponsor2 VARCHAR(20) './Sponsor2',
	Sponsor2Contact VARCHAR(100) './Sponsor2Contact',
	BaptismByOthers VARCHAR(100) './BaptismByOthers',
	BaptismChurchOthers VARCHAR(100) './BaptismChurchOthers',
	ConfirmByOthers VARCHAR(100) './ConfirmByOthers',
	ConfirmChurchOthers VARCHAR(100) './ConfirmChurchOthers',
	PreviousChurchOthers VARCHAR(100) './PreviousChurchOthers');






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

IF EXISTS (SELECT * FROM dbo.tb_visitors WHERE NRIC = @candidate_nric)
BEGIN
	DELETE FROM dbo.tb_course_Attendance WHERE NRIC = @candidate_nric;
	DELETE FROM dbo.tb_course_participant WHERE NRIC = @candidate_nric;
	DELETE FROM dbo.tb_visitors WHERE NRIC = @candidate_nric;
END

IF NOT EXISTS( SELECT * FROM dbo.tb_members WHERE NRIC = @candidate_nric)
BEGIN

	IF NOT EXISTS( SELECT * FROM dbo.tb_members_temp WHERE NRIC = @candidate_nric)
	BEGIN

	DECLARE @CurrentParish TINYINT
	SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'


	INSERT INTO dbo.tb_members_temp (Salutation, ICPhoto, EnglishName, AddressUnit,
							AddressHouseBlk, Nationality, Dialect, Occupation, BaptismBy, BaptismChurch,
							ConfirmBy, ConfirmChurch, PreviousChurch, ChineseName, NRIC,
							DOB, Gender, MaritalStatus, AddressStreet,
							AddressPostalCode, Email, Education, [Language],
							HomeTel, MobileTel, BaptismDate, ConfirmDate,
							MarriageDate, CurrentParish, Family, Child, TransferReason,
							BaptismByOthers, ConfirmByOthers , BaptismChurchOthers , ConfirmChurchOthers , PreviousChurchOthers)
	SELECT  @candidate_salutation, @candidate_photo,
			@candidate_english_name, @candidate_unit,
			@candidate_blk_house, @candidate_nationality,
			@candidate_dialect, @candidate_occupation,
			@baptized_by, @baptism_church,
			@confirmation_by, @confirmation_church,
			@previous_church_membership, @candidate_chinses_name,
			@candidate_nric, @candidate_dob,
			@candidate_gender, @candidate_marital_status,
			@candidate_street_address, @candidate_postal_code,
			@candidate_email, @candidate_education,
			@candidate_language, @candidate_home_tel,
			@candidate_mobile_tel,
			CONVERT(DATETIME, @candidate_baptism_date, 103),
			CONVERT(DATETIME, @candidate_confirmation_date, 103),
			CONVERT(DATETIME, @candidate_marriage_date, 103),
			@CurrentParish, @family, @child, @candidate_transfer_reason,
			@baptism_by_others,
			@confirm_by_others,
			@baptism_church_others,
			@confirm_church_others,
			@previous_church_others;
			
			DECLARE @rowcount INT = @@ROWCOUNT;
			
			INSERT INTO dbo.tb_membersOtherInfo_temp (NRIC, Congregation, Sponsor1, Sponsor2, Sponsor2Contact, MinistryInterested, CellgroupInterested, ServeCongregationInterested, TithingInterested)
			SELECT @candidate_nric, @candidate_congregation, @candidate_sponsor1, @candidate_sponsor2, @candidate_sponsor2contact, @candidate_interested_ministry, @candidate_join_cellgroup, @candidate_serve_congregation, @candidate_tithing
			
			DECLARE @newMemberXML XML = (
			SELECT  C.SalutationName, A.ICPhoto, A.EnglishName, A.AddressUnit,
					A.AddressHouseBlk, D.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect, F.OccupationName AS Occupation, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
					dbo.udf_getStafforMemberName(A.ConfirmBy) AS ConfirmBy, G.ParishName AS ConfirmChurch, L.ParishName AS PreviousChurch, A.ChineseName, A.NRIC,
					A.DOB, dbo.udf_getGender(A.Gender) AS Gender, dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, A.AddressStreet,
					A.AddressPostalCode, A.Email, dbo.udf_getEducation(A.Education) AS Education, dbo.udf_getLanguages(A.[Language]) AS [Language],
					A.HomeTel, A.MobileTel, A.BaptismDate, A.ConfirmDate, A.TransferReason,
					A.MarriageDate, A.CurrentParish, A.Family, A.Child, K.CongregationName AS Congregation, dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1, B.Sponsor2 AS Sponsor2, B.Sponsor2Contact,
					B.MinistryInterested, B.TithingInterested, B.CellgroupInterested, B.CellgroupInterested, BaptismByOthers, ConfirmByOthers , BaptismChurchOthers , ConfirmChurchOthers , PreviousChurchOthers
			FROM dbo.tb_members_temp AS A
			INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON B.NRIC = A.NRIC
			LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
			LEFT OUTER JOIN dbo.tb_country AS D ON A.Nationality = D.CountryID
			LEFT OUTER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_parish AS G ON A.ConfirmChurch = G.ParishID
			LEFT OUTER JOIN dbo.tb_parish AS H ON A.BaptismChurch = H.ParishID
			LEFT OUTER JOIN dbo.tb_congregation AS K ON B.Congregation = K.CongregationID
			LEFT OUTER JOIN dbo.tb_parish AS L ON A.PreviousChurch = L.ParishID
			WHERE A.NRIC = @candidate_nric
			FOR XML PATH, ELEMENTS)
			SELECT ISNULL(@rowcount, 0) AS Result
			EXEC dbo.usp_insertlogging 'I', @UserID, 'Membership', 'New', 1, 'NRIC', @candidate_nric, @newMemberXML;
			
	END

END		
SELECT ISNULL(@rowcount, 0) AS Result

SET NOCOUNT OFF;

GO
