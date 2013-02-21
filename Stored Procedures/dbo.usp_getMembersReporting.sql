SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getMembersReporting]
(@reportType VARCHAR(10),
 @inputA VARCHAR(100),
 @inputB VARCHAR(100), @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'
DECLARE @congregationTable Table (congregationID TINYINT)

INSERT INTO @congregationTable(congregationID)
select dbo.udf_getCongregationIDFromModuleFunction(functionName) from dbo.tb_modulesFunctions where Module = 'Congregation' AND functionID IN (
SELECT functionID FROM dbo.tb_Roles_ModulesFunctionsAccessRight 
WHERE RoleID = (SELECT RoleID FROM dbo.tb_Roles_Users WHERE UserID = @UserID))

	
	IF(@reportType = 'MIN')
	BEGIN	
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
				
		FROM dbo.tb_membersOtherInfo AS B 
		CROSS APPLY B.MinistryInvolvement.nodes('/Ministry/MinistryID') t(MinInv)
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND MinInv.value('(.)', 'VARCHAR(10)') = @inputA
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'CELL')
	BEGIN	
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
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND ISNULL(K.CellgroupID, '') = ISNULL(@inputA, '')
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'BapCon')
	BEGIN	
		IF(@inputA = 'NotBap')
		BEGIN
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
				
			FROM dbo.tb_membersOtherInfo AS B 
			INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
			INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
			INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
			INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
			INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
			LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
			LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
			LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
			LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
			WHERE A.CurrentParish = @CurrentParish AND ISNULL(CONVERT(VARCHAR(20),A.BaptismDate, 103),'NULL') = 'NULL'
			AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
		END
		ELSE IF(@inputA = 'BapNotCon')
		BEGIN
			SELECT	D.CongregationName, A.EnglishName, A.ChineseName, A.DOB, dbo.udf_getGender(A.Gender) AS Gender, A.NRIC,
				dbo.udf_getMaritialStatus(A.MaritalStatus) AS MaritalStatus, E.CountryName AS Nationality, dbo.udf_getDialect(A.Dialect) AS Dialect,
				A.HomeTel, A.MobileTel, dbo.udf_getLanguages(A.[Language]) AS Languages, F.OccupationName, dbo.udf_getEducation(A.Education) AS Education,
				A.BaptismDate, dbo.udf_getStafforMemberName(A.BaptismBy) AS BaptismBy, H.ParishName AS BaptismChurch,
				A.ConfirmDate, dbo.udf_getStafforMemberName(a.ConfirmBy) AS ConfirmBy, I.ParishName AS ConfirmChurch, J.ParishName AS PreviousChurch,
				ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') AS ElectoralRoll,  B.MemberDate,
				dbo.udf_getMinistry(CONVERT(VARCHAR(MAX),B.MinistryInvolvement)) AS MinistryInvolvement,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.MarriageDate, 103), GETDATE()),'') AS MarriageDurationYears,
				ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') AS Age,
				ISNULL(K.CellgroupName, '') AS Cellgroup, A.Email
				
			FROM dbo.tb_membersOtherInfo AS B 
			INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
			INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
			INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
			INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
			INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
			LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
			LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
			LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
			LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
			WHERE A.CurrentParish = @CurrentParish AND LEN(CONVERT(VARCHAR(20),A.BaptismDate, 103)) > 5 AND ISNULL(CONVERT(VARCHAR(20),B.MemberDate, 103),'NULL') = 'NULL'
			AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
		END
		ELSE IF(@inputA = 'BapAndCon')
		BEGIN
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
				
			FROM dbo.tb_membersOtherInfo AS B 
			INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
			INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
			INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
			INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
			INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
			LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
			LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
			LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
			LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
			LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
			WHERE A.CurrentParish = @CurrentParish AND LEN(CONVERT(VARCHAR(20),A.BaptismDate, 103)) > 5 AND LEN(CONVERT(VARCHAR(20),B.MemberDate, 103)) > 5
			AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
		END
	END
	ELSE IF(@reportType = 'MAR')
	BEGIN	
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
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND A.MaritalStatus = @inputA
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'OCC')
	BEGIN	
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
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND A.Occupation = @inputA
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'AGE')
	BEGIN	
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
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish 
		AND ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') >= @inputA
		AND ISNULL(DATEDIFF(YEAR, CONVERT(DATETIME, A.DOB, 103), GETDATE()),'') <= @inputB
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END
	ELSE IF(@reportType = 'ELECT')
	BEGIN	
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
				
		FROM dbo.tb_membersOtherInfo AS B 
		INNER JOIN dbo.tb_members AS A ON A.NRIC = B.NRIC
		INNER JOIN dbo.tb_parish AS C ON C.ParishID = A.CurrentParish
		INNER JOIN dbo.tb_congregation AS D ON D.CongregationID = B.Congregation
		INNER JOIN dbo.tb_country AS E ON A.Nationality = E.CountryID
		INNER JOIN dbo.tb_occupation AS F ON A.Occupation = F.OccupationID
		LEFT OUTER JOIN dbo.tb_Users AS G ON A.BaptismBy = G.UserID
		LEFT OUTER JOIN dbo.tb_parish AS H ON H.ParishID = A.BaptismChurch
		LEFT OUTER JOIN dbo.tb_parish AS I ON I.ParishID = A.ConfirmChurch
		LEFT OUTER JOIN dbo.tb_parish AS J ON J.ParishID = A.PreviousChurch
		LEFT OUTER JOIN dbo.tb_cellgroup AS K ON K.CellgroupID = B.CellGroup
		WHERE A.CurrentParish = @CurrentParish AND ISNULL(CONVERT(VARCHAR(MAX), B.ElectoralRoll, 103), '') <> ''
		AND B.Congregation IN (SELECT CongregationID FROM @congregationTable);
	END

SET NOCOUNT OFF;
GO
