SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getListofMinistry]
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT MinistryID, MinistryName, dbo.udf_getStafforMemberName(MinistryInCharge) AS Name, [MinistryDescription] FROM dbo.tb_ministry AS A
WHERE DELETED = 0

SET NOCOUNT OFF;
GO
