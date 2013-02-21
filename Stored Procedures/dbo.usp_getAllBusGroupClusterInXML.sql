SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllBusGroupClusterInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select BusGroupClusterID AS ID, BusGroupClusterName AS Name from dbo.tb_busgroup_cluster FOR XML PATH('Type'), ROOT('ChurchBusGroupCluster'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
