SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Education]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
