
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_GetAllSettingsInXML]
AS
SET NOCOUNT ON;

DECLARE @XML XML = (SELECT
	CONVERT(XML, (SELECT AgreementID, AgreementType, AgreementHTML FROM dbo.tb_course_agreement FOR XML PATH('ChurchAgreement'), ELEMENTS)) AS AllChurchAgreement,
	CONVERT(XML, (SELECT EmailID, EmailType, EmailContent FROM dbo.tb_emailContent FOR XML PATH('ChurchEmail'), ELEMENTS)) AS AllChurchEmail,
	CONVERT(XML, (SELECT AreaID, AreaName FROM dbo.tb_churchArea FOR XML PATH('ChurchArea'), ELEMENTS)) AS AllChurchArea,
	CONVERT(XML, (SELECT CongregationID, CongregationName FROM dbo.tb_congregation FOR XML PATH('Congregation'), ELEMENTS)) AS AllCongregation,
	CONVERT(XML, (SELECT CountryID, CountryName FROM dbo.tb_country FOR XML PATH('Country'), ELEMENTS)) AS AllCountry,
	CONVERT(XML, (SELECT DialectID, DialectName FROM dbo.tb_dialect FOR XML PATH('Dialect'), ELEMENTS)) AS AllDialect,
	CONVERT(XML, (SELECT EducationID, EducationName FROM dbo.tb_education FOR XML PATH('Education'), ELEMENTS)) AS AllEducation,
	CONVERT(XML, (SELECT FileTypeID, FileType AS FileTypeName FROM dbo.tb_file_type FOR XML PATH('FileType'), ELEMENTS)) AS AllFileType,
	CONVERT(XML, (SELECT FamilyTypeID, FamilyType AS FamilyTypeName FROM dbo.tb_familytype FOR XML PATH('FamilyType'), ELEMENTS)) AS AllFamilyType,
	CONVERT(XML, (SELECT LanguageID, LanguageName FROM dbo.tb_language FOR XML PATH('Language'), ELEMENTS)) AS AllLanguage,
	CONVERT(XML, (SELECT MaritalStatusID, MaritalStatusName FROM dbo.tb_maritalstatus FOR XML PATH('MaritalStatus'), ELEMENTS)) AS AllMaritalStatus,
	CONVERT(XML, (SELECT OccupationID, OccupationName FROM dbo.tb_occupation FOR XML PATH('Occupation'), ELEMENTS)) AS AllOccupation,
	CONVERT(XML, (SELECT ParishID, ParishName FROM dbo.tb_parish FOR XML PATH('Parish'), ELEMENTS)) AS AllParish,
	CONVERT(XML, (SELECT SalutationID, SalutationName FROM dbo.tb_Salutation FOR XML PATH('Salutation'), ELEMENTS)) AS AllSalutation,
	CONVERT(XML, (SELECT StyleID, StyleName FROM dbo.tb_style FOR XML PATH('Style'), ELEMENTS)) AS AllStyle,
	CONVERT(XML, (SELECT District, PostalAreaName, PostalDigit FROM dbo.tb_postalArea FOR XML PATH('PostalArea'), ELEMENTS)) AS AllPostalArea,
	CONVERT(XML, (SELECT BusGroupClusterID, BusGroupClusterName FROM dbo.tb_busgroup_cluster FOR XML PATH('BusGroupCluster'), ELEMENTS)) AS AllBusGroupCluster,
	CONVERT(XML, (SELECT ClubGroupID, ClubGroupName FROM dbo.tb_clubgroup FOR XML PATH('ClubGroup'), ELEMENTS)) AS AllClubGroup,
	CONVERT(XML, (SELECT RaceID, RaceName FROM dbo.tb_race FOR XML PATH('Race'), ELEMENTS)) AS AllRace,
	CONVERT(XML, (SELECT ReligionID, ReligionName FROM dbo.tb_religion FOR XML PATH('Religion'), ELEMENTS)) AS AllReligion,
	CONVERT(XML, (SELECT SchoolID, SchoolName FROM dbo.tb_school FOR XML PATH('School'), ELEMENTS)) AS AllSchool,
	CONVERT(XML, (SELECT courseID ,CourseName ,CourseStartDate ,CourseStartTime ,CourseEndTime ,'S00000000' AS CourseInCharge ,CourseLocation ,CourseDay ,Deleted ,Fee, AdditionalQuestion, CONVERT(VARCHAR(10), LastRegistrationDate, 103) AS LastRegistrationDate FROM dbo.tb_course FOR XML PATH('Course'), ELEMENTS)) AS AllCourse
FOR XML PATH(''), ELEMENTS, ROOT('All'));

SELECT @XML as [XML];

SET NOCOUNT OFF;
GO
