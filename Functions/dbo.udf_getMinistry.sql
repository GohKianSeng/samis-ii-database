SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getMinistry]
(
	-- Add the parameters for the function here
	@xml VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @return VARCHAR(MAX)
SET @return = ''
DECLARE @MinistryTable TABLE(ministryid tinyint)
DECLARE @table TABLE(ministry XML)
INSERT INTO @table (ministry)
SELECT @xml


INSERT INTO @MinistryTable(MinistryID)
SELECT p.value('(.)', 'VARCHAR(5)') as MinistryID
FROM @table CROSS APPLY ministry.nodes('/Ministry/MinistryID') t(p)

SELECT @return = @return + B.MinistryName + ',' FROM @MinistryTable AS A
INNER JOIN dbo.tb_ministry AS B ON B.MinistryID = A.MinistryID

RETURN @return
END
GO
