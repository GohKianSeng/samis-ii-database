SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getMinistryInfo]
(@ministryid int)
AS
SET NOCOUNT ON;

DECLARE @today DATE
SELECT @today = GETDATE()

SELECT CONVERT(VARCHAR(4), MinistryID) AS MinistryID, MinistryName, MinistryDescription,  dbo.udf_getStafforMemberName(MinistryInCharge) AS Name, MinistryInCharge FROM dbo.tb_ministry
WHERE MinistryID = @ministryid

SET NOCOUNT OFF;
GO
