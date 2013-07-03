SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_updateHWSMember]
(@updateXML XML)
AS
SET NOCOUNT ON;


DECLARE @UserID VARCHAR(50), @ID VARCHAR(5),
	@EnglishSurname VARCHAR(10),
	@EnglishGivenName VARCHAR(30),
	@ChineseSurname NVARCHAR(2),
	@ChineseGivenName NVARCHAR(3),
	@DOB VARCHAR(10),
	@Contact VARCHAR(10),
	@NOK VARCHAR(50),
	@NOKContact VARCHAR(10),
	@candidate_street_address VARCHAR(100),
	@candidate_postal_code INT,
	@candidate_blk_house VARCHAR(70),
	@candidate_unit VARCHAR(10),
	@candidate_photo VARCHAR(1000),
	@remarks VARCHAR(8000);

	DECLARE @Orig_UserID VARCHAR(50),
	@Orig_EnglishSurname VARCHAR(10),
	@Orig_EnglishGivenName VARCHAR(30),
	@Orig_ChineseSurname NVARCHAR(2),
	@Orig_ChineseGivenName NVARCHAR(3),
	@Orig_DOB VARCHAR(10),
	@Orig_Contact VARCHAR(10),
	@Orig_NOK VARCHAR(50),
	@Orig_NOKContact VARCHAR(10),
	@Orig_candidate_street_address VARCHAR(100),
	@Orig_candidate_postal_code INT,
	@Orig_candidate_blk_house VARCHAR(70),
	@Orig_candidate_unit VARCHAR(10),
	@Orig_candidate_photo VARCHAR(1000),
	@Orig_remarks VARCHAR(8000);

	DECLARE @ChangesTable TABLE (
			ElementName VARCHAR(100),
			[From] VARCHAR(MAX),
			[To] VARCHAR(MAX));

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @updateXML;

	SELECT @ID = ID, @UserID = EnteredBy, @EnglishSurname = EnglishSurname, @EnglishGivenName = EnglishGivenName, @ChineseSurname = ChineseSurname,
	@ChineseGivenName = ChineseGivenName, @DOB = DOB, @Contact = Contact, @NOK = NOK, @NOKContact = NOKContact,
	@candidate_street_address = candidate_street_address, @candidate_postal_code = candidate_postal_code, 
	@candidate_blk_house = candidate_blk_house, @candidate_unit = candidate_unit, @candidate_photo = candidate_photo, @remarks = remarks
	FROM OPENXML(@idoc, '/new')
	WITH (
	ID VARCHAR(5) './ID',
	EnteredBy VARCHAR(50)'./EnteredBy',
	EnglishSurname VARCHAR(10)'./EnglishSurname',
	EnglishGivenName VARCHAR(30) './EnglishGivenName',
	ChineseSurname NVARCHAR(2) './ChineseSurname',
	ChineseGivenName NVARCHAR(3) './ChineseGivenName',
	DOB VARCHAR(10) './DOB',
	Contact VARCHAR(10) './Contact',
	NOK VARCHAR(50) './NOK',
	NOKContact VARCHAR(10) './NOKContact',
	candidate_street_address VARCHAR(100) './candidate_street_address',
	candidate_postal_code INT './candidate_postal_code',
	candidate_blk_house VARCHAR(70) './candidate_blk_house',
	candidate_unit VARCHAR(10) './candidate_unit',
	candidate_photo VARCHAR(1000) './candidate_photo',
	remarks VARCHAR(8000) './remarks');

	SELECT @Orig_EnglishSurname = EnglishSurname, @Orig_EnglishGivenName = EnglishGivenName, @Orig_ChineseSurname = ChineseSurname,
	@Orig_ChineseGivenName = ChineseGivenName, @Orig_DOB = CONVERT(VARCHAR(10), Birthday, 103), @Orig_Contact = Contact, @Orig_NOK = NextOfKinName, @Orig_NOKContact = NextOfKinContact,
	@Orig_candidate_street_address = AddressStreet, @Orig_candidate_postal_code = AddressPostalCode, 
	@Orig_candidate_blk_house = AddressHouseBlock, @Orig_candidate_unit = AddressUnit, @Orig_candidate_photo = Photo, @Orig_remarks = remarks
	FROM [dbo].[tb_HokkienMember] WHERE @ID = @ID;

	IF(@Orig_EnglishSurname <> @EnglishSurname)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Surname', @Orig_EnglishSurname, @EnglishSurname);
	END

	IF(@Orig_EnglishGivenName <> @EnglishGivenName)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('English Given Name', @Orig_EnglishGivenName, @EnglishGivenName);
	END

	IF(@Orig_ChineseSurname <> @ChineseSurname)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Surname', @Orig_ChineseSurname, @ChineseSurname);
	END

	IF(@Orig_ChineseGivenName <> @ChineseGivenName)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Chinese Given Name', @Orig_ChineseGivenName, @ChineseGivenName);
	END

	IF(@Orig_Contact <> @Contact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Contact', @Orig_Contact, @Contact);
	END

	IF(@Orig_candidate_blk_house <> @candidate_blk_house)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Blk House', @Orig_candidate_blk_house, @candidate_blk_house);
	END

	IF(@Orig_candidate_street_address <> @candidate_street_address)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Street Address', @Orig_candidate_street_address, @candidate_street_address);
	END

	IF(@Orig_candidate_unit <> @candidate_unit)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('House Unit', @Orig_candidate_unit, @candidate_unit);
	END

	IF(@Orig_candidate_postal_code <> @candidate_postal_code)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Postal Code', @Orig_candidate_postal_code, @candidate_postal_code);
	END

	IF(@Orig_candidate_photo <> @candidate_photo)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Photo', @Orig_candidate_photo, @candidate_photo);
	END

	IF(@Orig_NOK <> @NOK)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next of Kin', @Orig_NOK, @NOK);
	END

	IF(@Orig_NOKContact <> @NOKContact)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Next of Kin Contact', @Orig_NOKContact, @NOKContact);
	END

	IF(@Orig_remarks <> @remarks)
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Remarks', @Orig_remarks, @remarks);
	END

	
	IF(ISNULL(@Orig_DOB,'') <> ISNULL(@DOB,''))
	BEGIN
		INSERT INTO @ChangesTable (ElementName, [From], [To]) VALUES ('Birthday', @Orig_DOB, @DOB);
		if(LEN(@DOB) = 0)
		BEGIN
			SET @DOB = null;
		END
	END

	DECLARE @returnTable TABLE (
		FromTo XML);

	IF EXISTS (SELECT 1 FROM @ChangesTable)
	BEGIN
		INSERT INTO @returnTable (FromTo)
		SELECT (SELECT ElementName, [From], [To] FROM @ChangesTable FOR XML RAW('Changes'), ELEMENTS);

		DECLARE @changesXML AS XML = (
		SELECT FromTo FROM @returnTable FOR XML RAW('Changes'), ELEMENTS);

		UPDATE [dbo].[tb_HokkienMember] SET [EnglishSurname] = @EnglishSurname, [EnglishGivenName] = @EnglishGivenName, [ChineseSurname] = @ChineseSurname,
		[ChineseGivenName] = @ChineseGivenName, [Birthday] = CONVERT(DATE, @DOB, 103), [Contact] = @Contact, [AddressHouseBlock] = @candidate_blk_house,
		[AddressStreet] = @candidate_street_address, [AddressUnit] = @candidate_unit, [AddressPostalCode] = @candidate_postal_code, [Photo] = @candidate_photo,
		[NextOfKinName] = @NOK, [NextOfKinContact] = @NOKContact, [Remarks] = @remarks
		WHERE ID = @ID;

		SELECT 'Updated' AS Result;
		
		EXEC dbo.usp_insertlogging 'I', @UserID, 'HWSMembership', 'Update', 1, 'NRIC', @ID, @changesXML;
	END
	ELSE
	BEGIN
		SELECT 'NoChange' AS Result;
	END

SET NOCOUNT OFF;

GO
