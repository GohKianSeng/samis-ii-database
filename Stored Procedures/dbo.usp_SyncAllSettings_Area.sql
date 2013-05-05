SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Area]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
