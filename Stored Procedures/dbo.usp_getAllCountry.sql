SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCountry]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,CountryID) AS CountryID, CountryName FROM tb_country
	

SET NOCOUNT OFF;
GO
