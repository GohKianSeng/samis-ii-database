SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCountry]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (CountryID VARCHAR(10), CountryName VARCHAR(100))
	INSERT INTO @table(CountryID, CountryName)
	Select CountryID, CountryName
	from OpenXml(@xdoc, '/ChurchCountry/*')
	with (
	CountryID VARCHAR(10) './CountryID',
	CountryName VARCHAR(100) './CountryName') WHERE CountryID <> 'New';		
	
	UPDATE dbo.tb_country SET dbo.tb_country.CountryName = a.CountryName
	from @table AS a WHERE a.CountryID <> 'New' AND dbo.tb_country.CountryID = a.CountryID; 
	
	DELETE FROM @table WHERE CountryID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_country 
				WHERE CountryID IN (SELECT DISTINCT Nationality FROM dbo.tb_members)
				AND CountryID NOT IN (Select CountryID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_country 
				WHERE CountryID IN (SELECT DISTINCT Nationality FROM dbo.tb_members_temp)
				AND CountryID NOT IN (Select CountryID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_country 
				WHERE CountryID IN (SELECT DISTINCT Nationality FROM dbo.tb_visitors)
				AND CountryID NOT IN (Select CountryID FROM @table))				
	BEGIN
		
		INSERT INTO dbo.tb_country (CountryName)
		Select CountryName
		from OpenXml(@xdoc, '/ChurchCountry/*')
		with (
		CountryID VARCHAR(10) './CountryID',
		CountryName VARCHAR(100) './CountryName') WHERE CountryID = 'New';
	
		SELECT 'Unable to delete, country still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_country 
		WHERE CountryID NOT IN (SELECT DISTINCT Nationality FROM dbo.tb_members)
		AND CountryID NOT IN (SELECT DISTINCT Nationality FROM dbo.tb_members_temp)
		AND CountryID NOT IN (SELECT DISTINCT Nationality FROM dbo.tb_visitors)
		AND CountryID NOT IN (Select CountryID FROM @table)
		
		INSERT INTO dbo.tb_country (CountryName)
		Select CountryName
		from OpenXml(@xdoc, '/ChurchCountry/*')
		with (
		CountryID VARCHAR(10) './CountryID',
		CountryName VARCHAR(100) './CountryName') WHERE CountryID = 'New';
		
		SELECT 'Country updated.' AS Result
	END

SET NOCOUNT OFF;
GO
