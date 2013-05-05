SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Parish]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
