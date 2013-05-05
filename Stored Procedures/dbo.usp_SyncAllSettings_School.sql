SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_School]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))
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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
