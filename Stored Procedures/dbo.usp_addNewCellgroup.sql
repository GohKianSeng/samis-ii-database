SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_addNewCellgroup]
(@cellgroupname VARCHAR(50),
 @incharge VARCHAR(20),
 @postalCode INT,
 @blkhouse VARCHAR(10),
 @streetAddress VARCHAR(100),
 @unit VARCHAR(10))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_cellgroup(CellgroupName, CellgroupLeader, PostalCode, StreetAddress, BLKHouse, Unit)
SELECT @cellgroupname, @incharge, @postalCode, @streetAddress, @blkhouse, @unit

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
