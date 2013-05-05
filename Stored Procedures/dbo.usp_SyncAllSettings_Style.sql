SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_Style]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./StyleID[1]','int'), T2.Loc.value('./StyleName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllStyle/*') as T2(Loc)

UPDATE dbo.tb_style SET dbo.tb_style.StyleName = A.Value1
FROM @Table AS A WHERE dbo.tb_style.StyleID = A.ID

SET IDENTITY_INSERT dbo.tb_style ON

INSERT INTO dbo.tb_style(StyleID, StyleName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT StyleID FROM dbo.tb_style)

SET IDENTITY_INSERT dbo.tb_style OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_style WHERE StyleID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
