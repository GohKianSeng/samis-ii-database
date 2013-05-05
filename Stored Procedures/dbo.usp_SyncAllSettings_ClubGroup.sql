SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_ClubGroup]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
