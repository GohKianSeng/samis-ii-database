SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[udf_SearchName]
(
-- Add the parameters for the function here
@NameSearch VARCHAR(200),
@Value VARCHAR(2000)
)
RETURNS BIT
AS
BEGIN


DECLARE @TABLE TABLE(SearchValue VARCHAR(20), Found BIT)
INSERT INTO @TABLE(SearchValue, Found)
SELECT ITEMS, 0 FROM dbo.udf_Split(RTRIM(LTRIM(@NameSearch)),' ')

UPDATE @TABLE SET Found = 1
WHERE SearchValue IN(
SELECT ITEMS FROM dbo.udf_Split(@NameSearch,' ')
WHERE @Value LIKE ITEMS + ' %' OR @Value LIKE '% ' + ITEMS OR @Value LIKE '% ' +ITEMS+' %' OR @Value LIKE '% '+ITEMS+',%' OR @Value LIKE ITEMS+',%')
IF ((SELECT COUNT(1) FROM @TABLE) = (SELECT COUNT(1) FROM @TABLE WHERE Found = 1))
BEGIN
RETURN CONVERT(bit, 1)
END
ELSE
BEGIN
RETURN CONVERT(bit, 0)
END

RETURN 0


END
GO