SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getMembersTempReportingManualSearch]
(@gender VARCHAR(3),
@marriage VARCHAR(3),
@nationality VARCHAR(3),
@dialect VARCHAR(3),
@education VARCHAR(3),
@occupation VARCHAR(3),
@congregation VARCHAR(3),
@language VARCHAR(3),
@cellgroup VARCHAR(3),
@ministry VARCHAR(3),
@batismchurch VARCHAR(3),
@confirmchurch VARCHAR(3),
@previouschurch VARCHAR(3),
@baptismby VARCHAR(3),
@confirmby VARCHAR(3),
@residentalarea VARCHAR(200), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @allMember TABLE(NRIC VARCHAR(20))
DECLARE @congregationTable Table (congregationID TINYINT)


declare 
@tgender VARCHAR(3) = @gender,
@tmarriage VARCHAR(3) = @marriage,
@tnationality VARCHAR(3) = @nationality,
@tdialect VARCHAR(3) = @dialect,
@teducation VARCHAR(3) = @education,
@toccupation VARCHAR(3) = @occupation,
@tcongregation VARCHAR(3) = @congregation,
@tlanguage VARCHAR(3) = @language,
@tcellgroup VARCHAR(3) = @cellgroup,
@tministry VARCHAR(3) = @ministry,
@tbatismchurch VARCHAR(3) = @batismchurch,
@tconfirmchurch VARCHAR(3) = @confirmchurch,
@tpreviouschurch VARCHAR(3) = @previouschurch,
@tbaptismby VARCHAR(3) = @baptismby,
@tconfirmby VARCHAR(3) = @confirmby,
@tresidentalarea VARCHAR(200) = @residentalarea, @tUserID VARCHAR(50) = @UserID;



INSERT INTO @congregationTable(congregationID)
select dbo.udf_getCongregationIDFromModuleFunction(functionName) from dbo.tb_modulesFunctions where Module = 'Congregation' AND functionID IN (
SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
WHERE RoleID = (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID))


INSERT INTO @allMember (NRIC)
SELECT NRIC FROM dbo.tb_membersOtherInfo_temp WHERE Congregation IN (SELECT CongregationID FROM @congregationTable)

IF(ISNULL(@tgender, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Gender = @tgender)
END

IF(ISNULL(@tmarriage, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE MaritalStatus = @tmarriage)
END

IF(ISNULL(@tnationality, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Nationality = @tnationality)
END

IF(ISNULL(@tdialect, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Dialect = @tdialect)
END

IF(ISNULL(@teducation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Education = @teducation)
END

IF(ISNULL(@toccupation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE Occupation = @toccupation)
END

IF(ISNULL(@tcongregation, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_membersOtherInfo_temp WHERE Congregation = @tcongregation)
END

IF(ISNULL(@tcellgroup, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_membersOtherInfo_temp WHERE CellGroup = @tcellgroup)
END

IF(ISNULL(@tbatismchurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE BaptismChurch = @tbatismchurch)
END

IF(ISNULL(@tconfirmchurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE ConfirmChurch = @tconfirmchurch)
END

IF(ISNULL(@tpreviouschurch, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE PreviousChurch = @tpreviouschurch)
END

IF(ISNULL(@tbaptismby, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE BaptismBy = @tbaptismby)
END

IF(ISNULL(@tconfirmby, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE ConfirmBy = @tconfirmby)
END

IF(ISNULL(@tlanguage, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM tb_members_temp AS A WHERE 1 = (SELECT 1 FROM dbo.udf_Split(A.[Language],',') WHERE items = @tlanguage))
END

IF(ISNULL(@tministry, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM tb_membersOtherInfo_temp AS A WHERE 1 = (SELECT 1 FROM dbo.udf_Split(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(8000), A.MinistryInvolvement),'<Ministry/>',''),'</MinistryID><MinistryID>',','),'<Ministry><MinistryID>',''),'</MinistryID></Ministry>',''), ',') WHERE items = @tministry))
END

IF(ISNULL(@tresidentalarea, '-') <> '-')
BEGIN
	DELETE FROM @allMember WHERE NRIC NOT IN (SELECT NRIC FROM dbo.tb_members_temp WHERE SUBSTRING(CONVERT(VARCHAR(7),AddressPostalCode), 1, 2) IN (SELECT RTRIM(LTRIM(ITEMS)) FROM dbo.udf_Split(@tresidentalarea, ',')))
END












DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'
SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
		dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
		A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
		A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
		A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
		ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll, B.MemberDate,
		dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
		ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
		ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
		ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
		
FROM dbo.tb_membersOtherInfo_temp AS B 
INNER JOIN dbo.tb_members_temp AS A ON A.NRIC = B.NRIC
INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
WHERE A.CurrentParish = @CurrentParish AND B.NRIC IN (SELECT NRIC FROM @allMember)

SET NOCOUNT OFF;

GO
