SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Dialect]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

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

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
