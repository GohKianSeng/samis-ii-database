SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateMinistry]
(@ministryid INT,
 @ministryname VARCHAR(50),
 @ministrydescription VARCHAR(2000),
 @incharge VARCHAR(10))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_ministry SET MinistryName = @ministryname, [MinistryDescription] = @ministrydescription, MinistryInCharge = @incharge
       WHERE MinistryID = @ministryid;
SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
