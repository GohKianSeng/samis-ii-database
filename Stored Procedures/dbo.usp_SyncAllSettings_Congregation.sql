SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Congregation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./CongregationID[1]','int'), T2.Loc.value('./CongregationName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllCongregation/*') as T2(Loc)

UPDATE dbo.tb_congregation SET dbo.tb_congregation.CongregationName = A.Value1
FROM @Table AS A WHERE dbo.tb_congregation.CongregationID = A.ID

SET IDENTITY_INSERT dbo.tb_congregation ON

INSERT INTO dbo.tb_congregation(CongregationID, CongregationName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT CongregationID FROM dbo.tb_congregation)

SET IDENTITY_INSERT dbo.tb_congregation OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_congregation WHERE CongregationID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
