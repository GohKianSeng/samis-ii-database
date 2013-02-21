SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllBusGroupCluster]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,BusGroupClusterID) AS BusGroupClusterID, BusGroupClusterName FROM dbo.tb_busgroup_cluster
	

SET NOCOUNT OFF;
GO
