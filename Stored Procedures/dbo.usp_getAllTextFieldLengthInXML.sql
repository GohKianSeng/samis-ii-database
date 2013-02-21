SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllTextFieldLengthInXML]

AS
SET NOCOUNT ON;

	DECLARE @XML XML = (select column_name AS ColumnName, TABLE_NAME AS TableName, character_maximum_length AS [Length] from information_schema.columns where data_type = 'varchar' OR DATA_TYPE = 'nvarchar' ORDER BY TABLE_NAME, information_schema.columns.column_name FOR XML PATH('Column'), ELEMENTS, ROOT('Table'));
	SELECT @XML AS [XML] WHERE LEN(CONVERT(VARCHAR(MAX), @XML)) > 0;
	

SET NOCOUNT OFF;
GO
