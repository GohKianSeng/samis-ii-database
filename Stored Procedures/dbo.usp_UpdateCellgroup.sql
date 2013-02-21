SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCellgroup]
(@cellgroupid INT,
 @cellgroupname VARCHAR(50),
 @incharge VARCHAR(10),
 @postalCode INT,
 @blkhouse VARCHAR(10),
 @streetAddress VARCHAR(100),
 @unit VARCHAR(10))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_cellgroup SET CellgroupName = @cellgroupname, CellgroupLeader = @incharge, PostalCode = @postalCode, StreetAddress = @streetAddress, BLKHouse = @blkhouse, Unit = @unit
       WHERE CellgroupID = @cellgroupid;
SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
