SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_removeMinistry]
(@MinistryID INT)
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_ministry WHERE MinistryID = @MinistryID)
BEGIN
	UPDATE dbo.tb_ministry SET Deleted = 1 WHERE MinistryID = @MinistryID
END

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
