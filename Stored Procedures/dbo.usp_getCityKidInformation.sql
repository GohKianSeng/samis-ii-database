SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCityKidInformation]
(@NRIC VARCHAR(10))
AS
SET NOCOUNT ON;


SELECT NRIC, Name, Gender, [DOB], [HomeTel] ,[MobileTel] ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit]
      ,Email, SpecialNeeds, EmergencyContact, EmergencyContactName, Transport, Religion, Race, Nationality, School, ClubGroup
      ,BusGroupCluster, Remarks, Points, Photo
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
				FROM dbo.tb_DOSLogging AS A
				INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
				WHERE [TYPE] = 'I' AND Reference = @NRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'CityKidMembership'
				ORDER BY A.ActionTime DESC 
				FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
FROM dbo.tb_ccc_kids
WHERE NRIC = @NRIC


SET NOCOUNT OFF;
GO
