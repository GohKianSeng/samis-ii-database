SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Religion]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))
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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
