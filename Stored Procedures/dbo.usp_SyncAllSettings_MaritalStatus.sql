SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_MaritalStatus]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./MaritalStatusID[1]','int'), T2.Loc.value('./MaritalStatusName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllMaritalStatus/*') as T2(Loc)

UPDATE dbo.tb_maritalstatus SET dbo.tb_maritalstatus.MaritalStatusName = A.Value1
FROM @Table AS A WHERE dbo.tb_maritalstatus.MaritalStatusID = A.ID

SET IDENTITY_INSERT dbo.tb_maritalstatus ON

INSERT INTO dbo.tb_maritalstatus(MaritalStatusID, MaritalStatusName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT MaritalStatusID FROM dbo.tb_maritalstatus)

SET IDENTITY_INSERT dbo.tb_maritalstatus OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_maritalstatus WHERE MaritalStatusID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
