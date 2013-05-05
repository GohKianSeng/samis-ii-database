SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Salutation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./SalutationID[1]','int'), T2.Loc.value('./SalutationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllSalutation/*') as T2(Loc)

UPDATE dbo.tb_Salutation SET dbo.tb_Salutation.SalutationName = A.Value1
FROM @Table AS A WHERE dbo.tb_Salutation.SalutationID = A.ID

SET IDENTITY_INSERT dbo.tb_Salutation ON

INSERT INTO dbo.tb_Salutation(SalutationID, SalutationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT SalutationID FROM dbo.tb_Salutation)

SET IDENTITY_INSERT dbo.tb_Salutation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_Salutation WHERE SalutationID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
