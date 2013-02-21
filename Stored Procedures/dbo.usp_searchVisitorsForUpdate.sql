SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_searchVisitorsForUpdate]
(@NRIC VARCHAR(10),
 @Name VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

IF(LEN(@NRIC) > 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 NRIC, ISNULL(C.SalutationName,'') +' '+EnglishName AS Name, ISNULL(CONVERT(VARCHAR(10), DOB, 103),'') AS DOB, dbo.udf_getGender(Gender) AS Gender, ISNULL(B.CountryName,'') AS Nationality, Email, Contact, Email 
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE NRIC LIKE '%'+@NRIC+'%' OR EnglishName LIKE '%'+@Name+'%'
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 NRIC, ISNULL(C.SalutationName,'') +' '+EnglishName AS Name, ISNULL(CONVERT(VARCHAR(10), DOB, 103),'') AS DOB, dbo.udf_getGender(Gender) AS Gender, ISNULL(B.CountryName,'') AS Nationality, Email, Contact, Email  
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE NRIC LIKE '%'+@NRIC+'%'
END
ELSE
BEGIN
	SELECT TOP 100 NRIC, ISNULL(C.SalutationName,'') +' '+EnglishName AS Name, ISNULL(CONVERT(VARCHAR(10), DOB, 103),'') AS DOB, dbo.udf_getGender(Gender) AS Gender, ISNULL(B.CountryName,'') AS Nationality, Email, Contact, Email
	FROM dbo.tb_visitors AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_Salutation AS C ON A.Salutation = C.SalutationID
	WHERE EnglishName LIKE '%'+@Name+'%'
	ORDER BY Name
END

SET NOCOUNT OFF;
GO
