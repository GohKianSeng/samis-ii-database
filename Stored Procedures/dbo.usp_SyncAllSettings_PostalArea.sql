SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_PostalArea]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./District[1]','int'), T2.Loc.value('./PostalAreaName[1]','VARCHAR(1000)'), T2.Loc.value('./PostalDigit[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllPostalArea/*') as T2(Loc)

UPDATE dbo.tb_postalArea SET dbo.tb_postalArea.PostalAreaName = A.Value1, dbo.tb_postalArea.PostalDigit = A.Value2
FROM @Table AS A WHERE dbo.tb_postalArea.District = A.ID

SET IDENTITY_INSERT dbo.tb_postalArea ON

INSERT INTO dbo.tb_postalArea(District, PostalAreaName, PostalDigit)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT District FROM dbo.tb_postalArea)

SET IDENTITY_INSERT dbo.tb_postalArea OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_postalArea WHERE District NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
