SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCellgroupInfo]
(@cellgroupid int)
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT CONVERT(VARCHAR(4), CellgroupID) AS CellgroupID, CellgroupName,  dbo.udf_getStafforMemberName(CellgroupLeader) AS Name, CellgroupLeader, PostalCode, StreetAddress, BLKHouse, Unit FROM dbo.tb_cellgroup
WHERE CellgroupID = @cellgroupid

SET NOCOUNT OFF;
GO
