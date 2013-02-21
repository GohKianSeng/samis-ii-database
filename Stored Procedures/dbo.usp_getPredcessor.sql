SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getPredcessor]
@InputString VARCHAR(MAX)
AS
SET NOCOUNT ON;
DECLARE @TVP TABLE(AppModFuncID VARCHAR(20))
INSERT INTO @TVP
SELECT Items FROM dbo.udf_Split(@InputString, ',')

DECLARE @stillgot INT;
DECLARE @Resulttable TABLE(AppModFuncID VARCHAR(20));

DECLARE @PredcessorInputString VARCHAR(MAX)

INSERT INTO @Resulttable
SELECT DISTINCT [dbo].udf_getAppModFuncPredcessor(AppModFuncID) AS PredcessorID
FROM [dbo].[tb_AppModFunc] WHERE AppModFuncID IN (SELECT AppModFuncID FROM @TVP);

SET @stillgot = (SELECT COUNT(*) FROM @Resulttable WHERE AppModFuncID <> 'NULL');
IF @stillgot>0
BEGIN
    
    SELECT @PredcessorInputString = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(MAX),(
	SELECT AppModFuncID AS a FROM @Resulttable FOR XML PATH('')
	)), '</a><a>', ','), '</a>', ''), '<a>', '')
    
    EXEC [dbo].[usp_getPredcessor] @PredcessorInputString;
END
SELECT * FROM @Resulttable;
SET NOCOUNT OFF;
GO
