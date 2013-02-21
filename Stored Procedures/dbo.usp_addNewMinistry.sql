SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_addNewMinistry]
(@ministryname VARCHAR(50),
 @ministrydescription VARCHAR(2000),
 @incharge VARCHAR(10))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_ministry(MinistryName, [MinistryDescription], MinistryInCharge)
SELECT @ministryname, @ministrydescription, @incharge

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
