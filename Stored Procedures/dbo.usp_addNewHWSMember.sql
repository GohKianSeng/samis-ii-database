SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_addNewHWSMember]
(@newXML AS XML,
 @Result VARCHAR(10) OUTPUT)
AS
	SET NOCOUNT ON;

	SET @Result = '0';


	DECLARE @UserID VARCHAR(50),
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

	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @newXML;
	
    SELECT @UserID = EnteredBy, @EnglishSurname = EnglishSurname, @EnglishGivenName = EnglishGivenName, @ChineseSurname = ChineseSurname,
	@ChineseGivenName = ChineseGivenName, @DOB = DOB, @Contact = Contact, @NOK = NOK, @NOKContact = NOKContact,
	@candidate_street_address = candidate_street_address, @candidate_postal_code = candidate_postal_code, 
	@candidate_blk_house = candidate_blk_house, @candidate_unit = candidate_unit, @candidate_photo = candidate_photo, @remarks = remarks
	FROM OPENXML(@idoc, '/new')
	WITH (
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

	if(LEN(@DOB) = 0)
	BEGIN
		SET @DOB = null;
	END

	INSERT INTO [dbo].[tb_HokkienMember] ([EnglishSurname] ,[EnglishGivenName] ,[ChineseSurname] ,[ChineseGivenName] ,[Birthday] ,[Contact]
      ,[AddressHouseBlock] ,[AddressStreet] ,[AddressUnit] ,[AddressPostalCode] ,[Photo] ,[NextOfKinName] ,[NextOfKinContact] ,[Remarks])
	SELECT @EnglishSurname, @EnglishGivenName, @ChineseSurname, @ChineseGivenName, CONVERT(DATE, @DOB, 103), @Contact, @candidate_blk_house, @candidate_street_address,
	@candidate_unit, @candidate_postal_code, @candidate_photo, @NOK, @NOKContact, @remarks

	DECLARE @ID VARCHAR(10);
	SELECT @ID = @@identity;

	DECLARE @newMemberXML XML = (
	SELECT ID, [EnglishSurname] ,[EnglishGivenName] ,[ChineseSurname] ,[ChineseGivenName] ,[Birthday] ,[Contact]
      ,[AddressHouseBlock] ,[AddressStreet] ,[AddressUnit] ,[AddressPostalCode] ,[Photo] ,[NextOfKinName] ,[NextOfKinContact] ,[Remarks]
	FROM [dbo].[tb_HokkienMember] WHERE ID = @ID
	FOR XML PATH, ELEMENTS)


	
	DECLARE @LogID TABLE(ID INT);
	INSERT INTO @LogID(ID)
	EXEC dbo.usp_insertlogging 'I', @UserID, 'HWSMembership', 'New', 1, 'NRIC', @ID, @newMemberXML;			

	SET @Result = 'OK';

SET NOCOUNT OFF;

GO
