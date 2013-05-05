SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Race]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
