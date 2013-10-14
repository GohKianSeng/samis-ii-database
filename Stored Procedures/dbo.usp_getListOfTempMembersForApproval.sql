
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getListOfTempMembersForApproval]

AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality,
		dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel,
		AddressHouseBlk, AddressPostalCode, AddressStreet, AddressUnit, E.CongregationName, F.OccupationName
	FROM dbo.tb_members_temp AS A
	INNER JOIN [dbo].[tb_occupation] AS F ON F.OccupationID = A.Occupation
	INNER JOIN tb_membersOtherInfo_temp AS D ON D.NRIC = A.NRIC
	INNER JOIN [dbo].[tb_congregation] AS E ON E.CongregationID = D.Congregation
	LEFT JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE CurrentParish = @CurrentParish
	ORDER BY Name, A.NRIC

SET NOCOUNT OFF;

GO
