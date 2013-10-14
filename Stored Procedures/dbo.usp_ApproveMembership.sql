
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_ApproveMembership]
(@NRICS VARCHAR(MAX))
AS
SET NOCOUNT ON;

INSERT INTO dbo.tb_members
SELECT [Salutation] ,[EnglishName] ,[ChineseName] ,[DOB] ,[Gender] ,[NRIC]
      ,[Nationality] ,[Dialect] ,[MaritalStatus] ,[MarriageDate] ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit]
      ,[Email] ,[Education] ,[Language] ,[Occupation] ,[HomeTel] ,[MobileTel] ,[BaptismDate] ,[BaptismBy]
      ,[BaptismByOthers] ,[BaptismChurch] ,[BaptismChurchOthers] ,[ConfirmDate] ,[ConfirmBy] ,[ConfirmByOthers] ,[ConfirmChurch] ,[ConfirmChurchOthers]
      ,[TransferReason] ,[Family] ,[Child] ,[CurrentParish] ,[ICPhoto] ,[PreviousChurch] ,[PreviousChurchOthers]
      ,[DeceasedDate] ,[CreatedDate]
      ,[CarIU], ReceiveMailingList FROM dbo.tb_members_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

INSERT INTO dbo.tb_membersOtherInfo
SELECT * FROM dbo.tb_membersOtherInfo_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))
	
DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))
DELETE FROM dbo.tb_members_temp WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

SELECT ICPhoto, @@ROWCOUNT AS Result FROM dbo.tb_members WHERE NRIC IN (SELECT ITEMS FROM dbo.udf_Split(@NRICS, ','))

SET NOCOUNT OFF;

GO
