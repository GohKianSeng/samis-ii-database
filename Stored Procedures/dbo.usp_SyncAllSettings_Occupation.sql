SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Occupation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
