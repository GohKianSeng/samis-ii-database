
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))
DECLARE @Course TABLE (
	courseID [int] NOT NULL,
	CourseName [varchar](100) NOT NULL,
	CourseStartDate [varchar](2000) NOT NULL,
	CourseStartTime [time](7) NOT NULL,
	CourseEndTime [time](7) NOT NULL,
	CourseInCharge [varchar](20) NOT NULL,
	CourseLocation [tinyint] NOT NULL,
	Deleted [bit] NOT NULL,
	Fee [decimal](5, 2) NOT NULL)


--
-- Course
--
INSERT INTO @Course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee)
SELECT T2.Loc.value('./courseID[1]','int')
	   ,T2.Loc.value('./CourseName[1]','VARCHAR(100)')
	   ,T2.Loc.value('./CourseStartDate[1]','VARCHAR(2000)')
	   ,T2.Loc.value('./CourseStartTime[1]','TIME')
	   ,T2.Loc.value('./CourseEndTime[1]','TIME')
	   ,T2.Loc.value('./CourseInCharge[1]','VARCHAR(20)')
	   ,T2.Loc.value('./CourseLocation[1]','tinyint')
	   ,T2.Loc.value('./Deleted[1]','BIT')
	   ,T2.Loc.value('./Fee[1]','DECIMAL(5, 2)')
FROM @XML.nodes('/All/AllCourse/*') as T2(Loc)

UPDATE dbo.tb_course SET dbo.tb_course.CourseName = A.CourseName
						 ,dbo.tb_course.CourseStartDate = A.CourseStartDate
						 ,dbo.tb_course.CourseStartTime = A.CourseStartTime
						 ,dbo.tb_course.CourseEndTime = A.CourseEndTime
						 ,dbo.tb_course.CourseInCharge = A.CourseInCharge
						 ,dbo.tb_course.CourseLocation = A.CourseLocation
						 ,dbo.tb_course.Deleted = A.Deleted
						 ,dbo.tb_course.Fee = A.Fee
FROM @Course AS A WHERE dbo.tb_course.courseID = A.courseID		

SET IDENTITY_INSERT dbo.tb_course ON

INSERT INTO dbo.tb_course(courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee)
SELECT courseID, CourseName, CourseStartDate, CourseStartTime, CourseEndTime, CourseInCharge, CourseLocation, Deleted, Fee
FROM @Course WHERE courseID NOT IN (SELECT courseID FROM dbo.tb_course)

IF EXISTS(SELECT 1 FROM @Course)
DELETE FROM dbo.tb_course WHERE courseID NOT IN (SELECT courseID FROM @Course);

SET IDENTITY_INSERT dbo.tb_course OFF				
--
-- School
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./SchoolID[1]','int'), T2.Loc.value('./SchoolName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllSchool/*') as T2(Loc)

UPDATE dbo.tb_school SET dbo.tb_school.SchoolName = A.Value1
FROM @Table AS A WHERE dbo.tb_school.SchoolID = A.ID

SET IDENTITY_INSERT dbo.tb_school ON

INSERT INTO dbo.tb_school(SchoolID, SchoolName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT SchoolID FROM dbo.tb_school)

SET IDENTITY_INSERT dbo.tb_school OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_school WHERE SchoolID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Religion
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ReligionID[1]','int'), T2.Loc.value('./ReligionName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllReligion/*') as T2(Loc)

UPDATE dbo.tb_religion SET dbo.tb_religion.ReligionName = A.Value1
FROM @Table AS A WHERE dbo.tb_religion.ReligionID = A.ID

SET IDENTITY_INSERT dbo.tb_religion ON

INSERT INTO dbo.tb_religion(ReligionID, ReligionName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ReligionID FROM dbo.tb_religion)

SET IDENTITY_INSERT dbo.tb_religion OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_religion WHERE ReligionID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Race
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./RaceID[1]','int'), T2.Loc.value('./RaceName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllRace/*') as T2(Loc)

UPDATE dbo.tb_race SET dbo.tb_race.RaceName = A.Value1
FROM @Table AS A WHERE dbo.tb_race.RaceID = A.ID

SET IDENTITY_INSERT dbo.tb_race ON

INSERT INTO dbo.tb_race(RaceID, RaceName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT RaceID FROM dbo.tb_race)

SET IDENTITY_INSERT dbo.tb_race OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_race WHERE RaceID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- ClubGroup
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ClubGroupID[1]','int'), T2.Loc.value('./ClubGroupName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllClubGroup/*') as T2(Loc)

UPDATE dbo.tb_clubgroup SET dbo.tb_clubgroup.ClubGroupName = A.Value1
FROM @Table AS A WHERE dbo.tb_clubgroup.ClubGroupID = A.ID

SET IDENTITY_INSERT dbo.tb_clubgroup ON

INSERT INTO dbo.tb_clubgroup(ClubGroupID, ClubGroupName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ClubGroupID FROM dbo.tb_clubgroup)

SET IDENTITY_INSERT dbo.tb_clubgroup OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_clubgroup WHERE ClubGroupID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table


--
-- BusGroupCluster
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./BusGroupClusterID[1]','int'), T2.Loc.value('./BusGroupClusterName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllBusGroupCluster/*') as T2(Loc)

UPDATE dbo.tb_busgroup_cluster SET dbo.tb_busgroup_cluster.BusGroupClusterName = A.Value1
FROM @Table AS A WHERE dbo.tb_busgroup_cluster.BusGroupClusterID = A.ID

SET IDENTITY_INSERT dbo.tb_busgroup_cluster ON

INSERT INTO dbo.tb_busgroup_cluster(BusGroupClusterID, BusGroupClusterName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT BusGroupClusterID FROM dbo.tb_busgroup_cluster)

SET IDENTITY_INSERT dbo.tb_busgroup_cluster OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table


--
-- PostalArea
--
INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./District[1]','int'), T2.Loc.value('./PostalAreaName[1]','VARCHAR(1000)'), T2.Loc.value('./PostalDigit[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllPostalArea/*') as T2(Loc)

UPDATE dbo.tb_postalArea SET dbo.tb_postalArea.PostalAreaName = A.Value1, dbo.tb_postalArea.PostalDigit = A.Value2
FROM @Table AS A WHERE dbo.tb_postalArea.District = A.ID

SET IDENTITY_INSERT dbo.tb_postalArea ON

INSERT INTO dbo.tb_postalArea(District, PostalAreaName, PostalDigit)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT District FROM dbo.tb_postalArea)

SET IDENTITY_INSERT dbo.tb_postalArea OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_postalArea WHERE District NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Style
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./StyleID[1]','int'), T2.Loc.value('./StyleName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllStyle/*') as T2(Loc)

UPDATE dbo.tb_style SET dbo.tb_style.StyleName = A.Value1
FROM @Table AS A WHERE dbo.tb_style.StyleID = A.ID

SET IDENTITY_INSERT dbo.tb_style ON

INSERT INTO dbo.tb_style(StyleID, StyleName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT StyleID FROM dbo.tb_style)

SET IDENTITY_INSERT dbo.tb_style OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_style WHERE StyleID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Salutation
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./SalutationID[1]','int'), T2.Loc.value('./SalutationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllSalutation/*') as T2(Loc)

UPDATE dbo.tb_Salutation SET dbo.tb_Salutation.SalutationName = A.Value1
FROM @Table AS A WHERE dbo.tb_Salutation.SalutationID = A.ID

SET IDENTITY_INSERT dbo.tb_Salutation ON

INSERT INTO dbo.tb_Salutation(SalutationID, SalutationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT SalutationID FROM dbo.tb_Salutation)

SET IDENTITY_INSERT dbo.tb_Salutation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_Salutation WHERE SalutationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Parish
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./ParishID[1]','int'), T2.Loc.value('./ParishName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllParish/*') as T2(Loc)

UPDATE dbo.tb_parish SET dbo.tb_parish.ParishName = A.Value1
FROM @Table AS A WHERE dbo.tb_parish.ParishID = A.ID

SET IDENTITY_INSERT dbo.tb_parish ON

INSERT INTO dbo.tb_parish(ParishID, ParishName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT ParishID FROM dbo.tb_parish)

SET IDENTITY_INSERT dbo.tb_parish OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_parish WHERE ParishID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Occupation
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./OccupationID[1]','int'), T2.Loc.value('./OccupationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllOccupation/*') as T2(Loc)

UPDATE dbo.tb_occupation SET dbo.tb_occupation.OccupationName = A.Value1
FROM @Table AS A WHERE dbo.tb_occupation.OccupationID = A.ID

SET IDENTITY_INSERT dbo.tb_occupation ON

INSERT INTO dbo.tb_occupation(OccupationID, OccupationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT OccupationID FROM dbo.tb_occupation)

SET IDENTITY_INSERT dbo.tb_occupation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_occupation WHERE OccupationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- MaritalStatus
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./MaritalStatusID[1]','int'), T2.Loc.value('./MaritalStatusName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllMaritalStatus/*') as T2(Loc)

UPDATE dbo.tb_maritalstatus SET dbo.tb_maritalstatus.MaritalStatusName = A.Value1
FROM @Table AS A WHERE dbo.tb_maritalstatus.MaritalStatusID = A.ID

SET IDENTITY_INSERT dbo.tb_maritalstatus ON

INSERT INTO dbo.tb_maritalstatus(MaritalStatusID, MaritalStatusName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT MaritalStatusID FROM dbo.tb_maritalstatus)

SET IDENTITY_INSERT dbo.tb_maritalstatus OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_maritalstatus WHERE MaritalStatusID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Language
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./LanguageID[1]','int'), T2.Loc.value('./LanguageName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllLanguage/*') as T2(Loc)

UPDATE dbo.tb_language SET dbo.tb_language.LanguageName = A.Value1
FROM @Table AS A WHERE dbo.tb_language.LanguageID = A.ID

SET IDENTITY_INSERT dbo.tb_language ON

INSERT INTO dbo.tb_language(LanguageID, LanguageName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT LanguageID FROM dbo.tb_language)

SET IDENTITY_INSERT dbo.tb_language OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_language WHERE LanguageID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- FamilyType
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./FamilyTypeID[1]','int'), T2.Loc.value('./FamilyTypeName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllFamilyType/*') as T2(Loc)

UPDATE dbo.tb_familytype SET dbo.tb_familytype.FamilyType = A.Value1
FROM @Table AS A WHERE dbo.tb_familytype.FamilyTypeID = A.ID

SET IDENTITY_INSERT dbo.tb_familytype ON

INSERT INTO dbo.tb_familytype(FamilyTypeID, FamilyType)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT FamilyTypeID FROM dbo.tb_familytype)

SET IDENTITY_INSERT dbo.tb_familytype OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_familytype WHERE FamilyTypeID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- FileType
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./FileTypeID[1]','int'), T2.Loc.value('./FileTypeName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllFileType/*') as T2(Loc)

UPDATE dbo.tb_file_type SET dbo.tb_file_type.FileType = A.Value1
FROM @Table AS A WHERE dbo.tb_file_type.FileTypeID = A.ID

SET IDENTITY_INSERT dbo.tb_file_type ON

INSERT INTO dbo.tb_file_type(FileTypeID, FileType)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT FileTypeID FROM dbo.tb_file_type)

SET IDENTITY_INSERT dbo.tb_file_type OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_file_type WHERE FileTypeID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Church Area
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./AreaID[1]','int'), T2.Loc.value('./AreaName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllChurchArea/*') as T2(Loc)

UPDATE dbo.tb_churchArea SET dbo.tb_churchArea.AreaName = A.Value1
FROM @Table AS A WHERE dbo.tb_churchArea.AreaID = A.ID

SET IDENTITY_INSERT dbo.tb_churchArea ON

INSERT INTO dbo.tb_churchArea(AreaID, AreaName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT AreaID FROM dbo.tb_churchArea)

SET IDENTITY_INSERT dbo.tb_churchArea OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_churchArea WHERE AreaID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Congregation
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./CongregationID[1]','int'), T2.Loc.value('./CongregationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllCongregation/*') as T2(Loc)

UPDATE dbo.tb_congregation SET dbo.tb_congregation.CongregationName = A.Value1
FROM @Table AS A WHERE dbo.tb_congregation.CongregationID = A.ID

SET IDENTITY_INSERT dbo.tb_congregation ON

INSERT INTO dbo.tb_congregation(CongregationID, CongregationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CongregationID FROM dbo.tb_congregation)

SET IDENTITY_INSERT dbo.tb_congregation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Country
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./CountryID[1]','int'), T2.Loc.value('./CountryName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllCountry/*') as T2(Loc)

UPDATE dbo.tb_country SET dbo.tb_country.CountryName = A.Value1
FROM @Table AS A WHERE dbo.tb_country.CountryID = A.ID

SET IDENTITY_INSERT dbo.tb_country ON

INSERT INTO dbo.tb_country(CountryID, CountryName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CountryID FROM dbo.tb_country)

SET IDENTITY_INSERT dbo.tb_country OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_country WHERE CountryID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Dialect
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./DialectID[1]','int'), T2.Loc.value('./DialectName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllDialect/*') as T2(Loc)

UPDATE dbo.tb_dialect SET dbo.tb_dialect.DialectName = A.Value1
FROM @Table AS A WHERE dbo.tb_dialect.DialectID = A.ID

SET IDENTITY_INSERT dbo.tb_dialect ON

INSERT INTO dbo.tb_dialect(DialectID, DialectName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT DialectID FROM dbo.tb_dialect)

SET IDENTITY_INSERT dbo.tb_dialect OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_dialect WHERE DialectID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

--
-- Education
--
INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./EducationID[1]','int'), T2.Loc.value('./EducationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllEducation/*') as T2(Loc)

UPDATE dbo.tb_education SET dbo.tb_education.EducationName = A.Value1
FROM @Table AS A WHERE dbo.tb_education.EducationID = A.ID

SET IDENTITY_INSERT dbo.tb_education ON

INSERT INTO dbo.tb_education(EducationID, EducationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT EducationID FROM dbo.tb_education)

SET IDENTITY_INSERT dbo.tb_education OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_education WHERE EducationID NOT IN (SELECT ID FROM @Table);

DELETE FROM @Table

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
GO
