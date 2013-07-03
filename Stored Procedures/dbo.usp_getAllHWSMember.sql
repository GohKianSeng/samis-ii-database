SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllHWSMember]

AS
SET NOCOUNT ON;

	SELECT [ID]
      ,[EnglishSurname]
      ,[EnglishGivenName]
      ,[ChineseSurname]
      ,[ChineseGivenName]
      ,[Birthday]
      ,[Contact]
      ,[AddressHouseBlock]
      ,[AddressStreet]
      ,[AddressUnit]
      ,[AddressPostalCode]
      ,[Photo]
      ,[NextOfKinName]
      ,[NextOfKinContact]
      ,[Remarks]
  FROM [dbo].[tb_HokkienMember] Order by EnglishSurname+EnglishGivenName, ChineseSurname+ChineseGivenName
	

SET NOCOUNT OFF;

GO
