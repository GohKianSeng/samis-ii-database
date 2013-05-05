SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[usp_searchName]
(@searchText VARCHAR(100))
 
AS
SET NOCOUNT ON;

SET @searchText = LTRIM(RTRIM(@searchText));

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

SELECT (select TOP 100 ISNULL(B.ICPhoto,'') AS ICPhoto, ISNULL(Name, B.EnglishName) AS Name, ISNULL(B.NRIC, A.NRIC) AS NRIC, ISNULL(ISNULL(A.Email, B.Email),' ') AS Email from dbo.tb_Users AS A
Full JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
WHERE (dbo.udf_SearchName(@searchText, B.EnglishName) = 1 OR dbo.udf_SearchName(@searchText, A.Name) = 1)
ORDER BY ISNULL(Name,B.EnglishName) ASC
FOR XML PATH('found'), Elements, Root('Root')) AS Result


SET NOCOUNT OFF;
GO
