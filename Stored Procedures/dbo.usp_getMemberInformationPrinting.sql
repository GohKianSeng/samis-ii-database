SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getMemberInformationPrinting]
(@NRIC VARCHAR(10))
AS
SET NOCOUNT ON;

	SELECT	C.ParishName, D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
			dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
			A.AddressHouseBlk + ' ' + A.AddressStreet AS Address1, 'Singapore '+ CONVERT(VARCHAR(MAX),A.AddressPostalCode) AS Address2,
			A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
			A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
			A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
			'Sponsor: ' + dbo.udf_getStafforMemberName(B.Sponsor1) + ', ' + dbo.udf_getStafforMemberName(B.Sponsor2) AS Remarks1, '' AS Remarks2,
			A.CreatedDate, A.Family, A.Child, B.ElectoralRoll AS ElectoralRoll, B.MemberDate, A.TransferReason, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers, 
			SUBSTRING (A.ICPhoto, 0, 37) AS [GUID], SUBSTRING (A.ICPhoto, 38, 999) AS [Filename]
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_membersOtherInfo AS B ON A.NRIC = B.NRIC
	INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
	INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
	INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
	INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
	LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
	LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
	LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
	LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
	WHERE A.NRIC = @NRIC
	

SET NOCOUNT OFF;

--[dbo].[usp_getMemberInformationPrinting] 'S7286405J'
GO
