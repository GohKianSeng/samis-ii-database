SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_BusGroupCluster]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(1000))

INSERT INTO @Table(ID, Value1)
SELECT T2.Loc.value('./BusGroupClusterID[1]','int'), T2.Loc.value('./BusGroupClusterName[1]','VARCHAR(1000)')
FROM @XML.nodes('/All/AllBusGroupCluster/*') as T2(Loc)

UPDATE dbo.tb_busgroup_cluster SET dbo.tb_busgroup_cluster.BusGroupClusterName = A.Value1
FROM @Table AS A WHERE dbo.tb_busgroup_cluster.BusGroupClusterID = A.ID

SET IDENTITY_INSERT dbo.tb_busgroup_cluster ON

INSERT INTO dbo.tb_busgroup_cluster(BusGroupClusterID, BusGroupClusterName)
SELECT ID, Value1 FROM @Table
WHERE ID NOT IN (SELECT BusGroupClusterID FROM dbo.tb_busgroup_cluster)

SET IDENTITY_INSERT dbo.tb_busgroup_cluster OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_busgroup_cluster WHERE BusGroupClusterID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
