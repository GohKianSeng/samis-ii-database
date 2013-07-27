SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getHWSMemberAttendance]
(@Date DATE)
AS
SET NOCOUNT ON;

  SELECT A.[ID]
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
  FROM [dbo].[tb_HokkienAttendance] AS A
  INNER JOIN [dbo].[tb_HokkienMember] AS B ON A.ID = B.ID
  where [AttendanceDate] = @Date

	

SET NOCOUNT OFF;

GO
