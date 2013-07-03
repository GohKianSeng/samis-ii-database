SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getHWSMemberInformation]
(@ID INT)
AS
SET NOCOUNT ON;

SELECT [ID]
      ,[EnglishSurname]
      ,[EnglishGivenName]
      ,[ChineseSurname]
      ,[ChineseGivenName]
      ,CONVERT(VARCHAR(10), [Birthday], 103) AS DOB
      ,[Contact]
      ,[AddressHouseBlock]
      ,[AddressStreet]
      ,[AddressUnit]
      ,[AddressPostalCode]
      ,[Photo]
      ,[NextOfKinName]
      ,[NextOfKinContact]
      ,[Remarks]
  FROM [DOS].[dbo].[tb_HokkienMember] WHERE ID = @ID;

SET NOCOUNT OFF;

GO
