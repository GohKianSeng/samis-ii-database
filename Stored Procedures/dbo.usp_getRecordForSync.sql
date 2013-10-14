
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getRecordForSync]

AS
SET NOCOUNT ON;

UPDATE dbo.tb_course_participant SET MarkSync = 1
UPDATE dbo.tb_members_temp SET MarkSync = 1

DECLARE @XML XML = (SELECT
	CONVERT(XML, (SELECT CourseID, CONVERT(VARCHAR(22), RegistrationDate,103) AS RegistrationDate, 'Unspecified' AS EnteredBy, B.NRIC AS OriginalNRIC, B.NRIC AS NRIC, B.Salutation, EnglishName, Gender, CONVERT(VARCHAR(10), DOB, 103) AS DOB,
		   Nationality, AddressStreet AS AddressStreetName, AddressPostalCode, AddressHouseBlk AS AddressBlkHouse,
		   AddressUnit, Contact, Email, Education, Occupation, Church, ChurchOthers, AdditionalInformation, ReceiveMailingList AS mailingList
	FROM dbo.tb_course_participant AS A
	INNER JOIN dbo.tb_visitors AS B ON A.NRIC = B.NRIC WHERE MarkSync = 1
	FOR XML PATH('Update'))) AS AllVisitors,
	
	CONVERT(XML, (SELECT ISNULL(C.CourseID, '-1') AS CourseID, ISNULL(feePaid,0) AS feePaid, ISNULL(materialReceived,0) AS materialReceived,
	       CONVERT(VARCHAR(10), ISNULL(RegistrationDate, ''), 103) AS RegistrationDate, ISNULL(AdditionalInformation, '<empty />') AS AdditionalInformation, 
	      'Unspecified' AS EnteredBy, A.NRIC, Salutation, EnglishName, ChineseName, Gender, CONVERT(VARCHAR(10), DOB, 103) AS DOB,
		   MaritalStatus, CONVERT(VARCHAR(10), MarriageDate, 103) AS MarriageDate, Nationality, Dialect, ICPhoto AS Photo,
		   AddressStreet AS AddressStreetName, AddressPostalCode, AddressHouseBlk AS AddressBlkHouse, AddressUnit, HomeTel, MobileTel,
		   Email, Education, [Language], Occupation, Congregation, BaptismBy, BaptismChurch, CONVERT(VARCHAR(10), BaptismDate, 103) AS BaptismDate,
		   ConfirmBy AS ConfirmationBy, ConfirmChurch AS ConfirmationChurch, CONVERT(VARCHAR(10), ConfirmDate, 103) AS ConfirmationDate,
		   PreviousChurch AS PreviousChurchMembership, TransferReason, CONVERT(XML, Family), CONVERT(XML, Child), ServeCongregationInterested AS InterestedServeCongregation,
		   CellgroupInterested AS InterestedCellgroup, TithingInterested AS InterestedTithing, CONVERT(XML, MinistryInterested),
		   Sponsor1, Sponsor2, Sponsor2Contact, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers, ReceiveMailingList AS mailingList
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON A.NRIC = B.NRIC 
	LEFT OUTER JOIN dbo.tb_course_participant AS C ON C.NRIC = A.NRIC WHERE A.MarkSync = 1
	FOR XML PATH('New'))) AS AllMembers
FOR XML PATH('SyncData'))

SELECT @XML AS SyncData

SET NOCOUNT OFF;

GO
