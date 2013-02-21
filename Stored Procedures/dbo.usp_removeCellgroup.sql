SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_removeCellgroup]
(@CellgroupID INT)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_cellgroup WHERE CellgroupID = @CellgroupID)
BEGIN
	UPDATE dbo.tb_cellgroup SET Deleted = 1 WHERE CellgroupID = @CellgroupID
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
