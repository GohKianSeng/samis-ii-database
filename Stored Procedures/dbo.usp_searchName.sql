SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_searchName]
(@searchText VARCHAR(100))
 
AS
SET NOCOUNT ON;

DECLARE @CurrentParish TINYINT
SELECT @CurrentParish = CONVERT(TINYINT,value) FROM dbo.tb_App_Config WHERE ConfigName = 'currentparish'

SELECT (select TOP 100 ISNULL(B.ICPhoto,'') AS ICPhoto, ISNULL(B.EnglishName, Name) AS Name, ISNULL(B.NRIC, A.NRIC) AS NRIC, ISNULL(ISNULL(B.Email, A.Email),' ') AS Email from dbo.tb_Users AS A
Full JOIN dbo.tb_members AS B ON B.NRIC = A.NRIC
WHERE A.Name like '%' + @searchText + '%' OR B.EnglishName like '%' + @searchText + '%' AND B.CurrentParish = @CurrentParish
ORDER BY ISNULL(Name,B.EnglishName) ASC
FOR XML PATH('found'), Elements, Root('Root')) AS Result

SET NOCOUNT OFF;

GO
