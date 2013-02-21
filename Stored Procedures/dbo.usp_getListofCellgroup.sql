SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getListofCellgroup]
AS
SET NOCOUNT ON;

SELECT CellgroupID, CellgroupName, dbo.udf_getStafforMemberName(CellgroupLeader) AS Name FROM dbo.tb_cellgroup
WHERE Deleted = 0

SET NOCOUNT OFF;
GO
