SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Country]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./CountryID[1]','int'), T2.Loc.value('./CountryName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllCountry/*') as T2(Loc)

UPDATE dbo.tb_country SET dbo.tb_country.CountryName = A.Value1
FROM @Table AS A WHERE dbo.tb_country.CountryID = A.ID

SET IDENTITY_INSERT dbo.tb_country ON

INSERT INTO dbo.tb_country(CountryID, CountryName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CountryID FROM dbo.tb_country)

SET IDENTITY_INSERT dbo.tb_country OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_country WHERE CountryID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
