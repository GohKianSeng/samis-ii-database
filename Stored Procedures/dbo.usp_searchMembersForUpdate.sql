SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_searchMembersForUpdate]
(@NRIC VARCHAR(10),
 @Name VARCHAR(50), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
DECLARE @congregationTable Table (congregationID TINYINT)

INSERT INTO @congregationTable(congregationID)
select dbo.udf_getCongregationIDFromModuleFunction(functionName) from dbo.tb_modulesFunctions where Module = 'Congregation' AND functionID IN (
SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
WHERE RoleID = (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID))

SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

IF(LEN(@NRIC) > 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE (A.NRIC LIKE '%'+@NRIC+'%' OR dbo.udf_SearchName(@Name, EnglishName) = 1)
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE A.NRIC LIKE '%'+@NRIC+'%'
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
END
ELSE
BEGIN
	SELECT TOP 100 A.NRIC, C.SalutationName +' '+EnglishName AS Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, dbo.udf_getMaritialStatus(MaritalStatus) AS MaritalStatus, Email, HomeTel, MobileTel 
	FROM dbo.tb_members AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	LEFT OUTER JOIN dbo.tb_membersOtherInfo AS D ON A.NRIC = D.NRIC
	WHERE dbo.udf_SearchName(@Name, EnglishName) = 1
	AND CurrentParish = @CurrentParish AND D.Congregation IN (SELECT congregationID FROM @congregationTable)
	ORDER BY Name
END

SET NOCOUNT OFF;

GO
