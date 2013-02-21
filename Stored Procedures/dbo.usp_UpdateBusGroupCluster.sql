SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateBusGroupCluster]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (BusGroupClusterID VARCHAR(10), BusGroupClusterName VARCHAR(100))
	INSERT INTO @table(BusGroupClusterID, BusGroupClusterName)
	Select BusGroupClusterID, BusGroupClusterName
	from OpenXml(@xdoc, '/BusGroupCluster/*')
	with (
	BusGroupClusterID VARCHAR(10) './BusGroupClusterID',
	BusGroupClusterName VARCHAR(100) './BusGroupClusterName') WHERE BusGroupClusterID <> 'New';		
	
	UPDATE dbo.tb_BusGroup_Cluster SET dbo.tb_BusGroup_Cluster.BusGroupClusterName = a.BusGroupClusterName
	from @table AS a WHERE a.BusGroupClusterID <> 'New' AND dbo.tb_BusGroup_Cluster.BusGroupClusterID = a.BusGroupClusterID; 
	
	DELETE FROM @table WHERE BusGroupClusterID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_BusGroup_Cluster 
				WHERE BusGroupClusterID IN (SELECT DISTINCT BusGroupCluster FROM dbo.tb_ccc_kids)
				AND BusGroupClusterID NOT IN (Select BusGroupClusterID FROM @table))		
	BEGIN
			
		INSERT INTO dbo.tb_BusGroup_Cluster (BusGroupClusterName)
		Select BusGroupClusterName
		from OpenXml(@xdoc, '/BusGroupCluster/*')
		with (
		BusGroupClusterID VARCHAR(10) './BusGroupClusterID',
		BusGroupClusterName VARCHAR(100) './BusGroupClusterName') WHERE BusGroupClusterID = 'New';
	
		SELECT 'Unable to delete, BusGroupCluster still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_BusGroup_Cluster 
		WHERE BusGroupClusterID NOT IN (SELECT DISTINCT BusGroupCluster FROM dbo.tb_ccc_kids)
		AND BusGroupClusterID NOT IN (Select BusGroupClusterID FROM @table)
		
		INSERT INTO dbo.tb_BusGroup_Cluster (BusGroupClusterName)
		Select BusGroupClusterName
		from OpenXml(@xdoc, '/BusGroupCluster/*')
		with (
		BusGroupClusterID VARCHAR(10) './BusGroupClusterID',
		BusGroupClusterName VARCHAR(100) './BusGroupClusterName') WHERE BusGroupClusterID = 'New';
		
		SELECT 'BusGroupCluster updated.' AS Result
	END

SET NOCOUNT OFF;
GO
