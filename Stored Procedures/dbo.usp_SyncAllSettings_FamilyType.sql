SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_FamilyType]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
