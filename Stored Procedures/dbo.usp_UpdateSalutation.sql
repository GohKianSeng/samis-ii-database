SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateSalutation]
(@xml XML)
AS
SET NOCOUNT ON;

	DECLARE @xdoc int;
	EXEC sp_xml_preparedocument @xdoc OUTPUT, @xml;
	
	DECLARE @table AS TABLE (SalutationID VARCHAR(10), SalutationName VARCHAR(100))
	INSERT INTO @table(SalutationID, SalutationName)
	Select SalutationID, SalutationName
	from OpenXml(@xdoc, '/ChurchSalutation/*')
	with (
	SalutationID VARCHAR(10) './SalutationID',
	SalutationName VARCHAR(100) './SalutationName') WHERE SalutationID <> 'New';		
	
	UPDATE dbo.tb_Salutation SET dbo.tb_Salutation.SalutationName = a.SalutationName
	from @table AS a WHERE a.SalutationID <> 'New' AND dbo.tb_Salutation.SalutationID = a.SalutationID; 
	
	DELETE FROM @table WHERE SalutationID = 'New'
	
	if EXISTS(SELECT 1 FROM dbo.tb_Salutation 
				WHERE SalutationID IN (SELECT DISTINCT Salutation FROM dbo.tb_members)
				AND SalutationID NOT IN (Select SalutationID FROM @table))
	OR EXISTS(SELECT 1 FROM dbo.tb_Salutation 
				WHERE SalutationID IN (SELECT DISTINCT Salutation FROM dbo.tb_members_temp)
				AND SalutationID NOT IN (Select SalutationID FROM @table))
    OR EXISTS(SELECT 1 FROM dbo.tb_Salutation 
				WHERE SalutationID IN (SELECT DISTINCT Salutation FROM dbo.tb_visitors)
				AND SalutationID NOT IN (Select SalutationID FROM @table))								
	BEGIN
			
		INSERT INTO dbo.tb_Salutation (SalutationName)
		Select SalutationName
		from OpenXml(@xdoc, '/ChurchSalutation/*')
		with (
		SalutationID VARCHAR(10) './SalutationID',
		SalutationName VARCHAR(100) './SalutationName') WHERE SalutationID = 'New';
	
		SELECT 'Unable to delete, Salutation still in used.' AS Result;
	END
	ELSE
	BEGIN
		DELETE FROM dbo.tb_Salutation 
		WHERE SalutationID NOT IN (SELECT DISTINCT Salutation FROM dbo.tb_members)
		AND SalutationID NOT IN (SELECT DISTINCT Salutation FROM dbo.tb_members_temp)
		AND SalutationID NOT IN (SELECT DISTINCT Salutation FROM dbo.tb_visitors)
		AND SalutationID NOT IN (Select SalutationID FROM @table)
		
		INSERT INTO dbo.tb_Salutation (SalutationName)
		Select SalutationName
		from OpenXml(@xdoc, '/ChurchSalutation/*')
		with (
		SalutationID VARCHAR(10) './SalutationID',
		SalutationName VARCHAR(100) './SalutationName') WHERE SalutationID = 'New';
		
		SELECT 'Salutation updated.' AS Result
	END

SET NOCOUNT OFF;
GO
