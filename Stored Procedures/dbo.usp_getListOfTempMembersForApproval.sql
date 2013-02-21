SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getListOfTempMembersForApproval]

AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

	SELECT TOP 100 NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members_temp AS A
	LEFT JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE CurrentParish = @CurrentParish
	ORDER BY Name, NRIC

SET NOCOUNT OFF;

GO
