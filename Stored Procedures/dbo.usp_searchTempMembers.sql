SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_searchTempMembers]
(@NRIC VARCHAR(10),
 @DOB DATE)
AS
SET NOCOUNT ON;

SELECT B.Congregation, A.MarriageDate, A.Salutation, A.ICPhoto, A.EnglishName, A.ChineseName, A.NRIC
		,A.DOB, A.Gender, A.MaritalStatus, A.AddressStreet, A.AddressHouseBlk, A.AddressUnit, A.AddressPostalCode
		,A.Nationality, A.Dialect, A.Email, A.Education, A.[Language], A.Occupation, A.HomeTel, A.MobileTel
		,A.BaptismDate, A.BaptismBy, A.BaptismChurch, A.ConfirmBy, A.ConfirmChurch, A.ConfirmDate
		,A.PreviousChurch, B.Sponsor1, B.Sponsor2, B.Sponsor2Contact, dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1Text
		,dbo.udf_getStafforMemberName(B.Sponsor2) AS Sponsor2Text
		,B.MinistryInterested, B.CellgroupInterested
		,B.ServeCongregationInterested, B.TithingInterested, A.Family, A.Child, A.TransferReason,
		A.BaptismByOthers, A.BaptismChurchOthers, A.ConfirmByOthers, A.ConfirmChurchOthers, A.PreviousChurchOthers
FROM dbo.tb_members_temp AS A
INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON A.NRIC = B.NRIC
WHERE A.NRIC = @NRIC AND A.DOB = @DOB


SET NOCOUNT OFF;
GO
