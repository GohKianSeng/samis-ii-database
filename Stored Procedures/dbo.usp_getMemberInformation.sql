
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getMemberInformation]
(@NRIC VARCHAR(10), @Type VARCHAR(10))
AS
SET NOCOUNT ON;

DECLARE @tNRIC VARCHAR(10) = @NRIC, @tType VARCHAR(10) = @Type;

IF(@tType = 'Actual')
BEGIN
	SELECT [EnglishName], CONVERT(INT, [Salutation]) AS Salutation
      ,[ChineseName],[DOB] ,[Gender] ,@tNRIC AS [NRIC] ,[Nationality] ,[Dialect] ,[MaritalStatus]
      ,[MarriageDate]  ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit] ,[Email]
      ,[Education] ,[Language] ,[Occupation] ,[HomeTel] ,[MobileTel] ,[BaptismDate]
      ,[BaptismBy] ,[BaptismChurch] ,[ConfirmDate] ,[ConfirmBy] ,[ConfirmChurch] ,[Family] ,[Child] ,[CurrentParish]
      ,[ICPhoto] ,[PreviousChurch] ,[DeceasedDate] ,[CreatedDate], TransferReason 
      ,B.CellGroup, B.Congregation, CarIU, B.Remarks, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers
      ,   Convert(XML, ISNULL((SELECT B.CourseName AS CourseName, B.courseID AS CourseID from dbo.tb_course_participant AS A
		  INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
		  WHERE A.NRIC = @tNRIC
		  FOR XML PATH(''), ELEMENTS, ROOT('Course')), '<Course></Course>')) AS CourseAttended 
      ,B.ElectoralRoll, B.MinistryInvolvement, B.Sponsor1, B.Sponsor2, B.Sponsor2Contact, B.MemberDate, B.TransferTo, B.TransferToDate
      ,dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1Name
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
					FROM dbo.tb_DOSLogging AS A
					INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
					WHERE [TYPE] = 'I' AND Reference = @tNRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'Membership'
					ORDER BY A.ActionTime DESC 
					FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
	FROM dbo.tb_members AS A
	INNER JOIN dbo.tb_membersOtherInfo AS B ON A.NRIC = B.NRIC
	WHERE A.NRIC = @tNRIC
END
ELSE IF(@tType = 'Temp')
BEGIN
	SELECT [EnglishName], CONVERT(INT, [Salutation]) AS Salutation
      ,[ChineseName],[DOB] ,[Gender] ,@tNRIC AS [NRIC] ,[Nationality] ,[Dialect] ,[MaritalStatus]
      ,[MarriageDate]  ,[AddressStreet] ,[AddressHouseBlk] ,[AddressPostalCode] ,[AddressUnit] ,[Email]
      ,[Education] ,[Language] ,[Occupation] ,[HomeTel] ,[MobileTel] ,[BaptismDate]
      ,[BaptismBy] ,[BaptismChurch] ,[ConfirmDate] ,[ConfirmBy] ,[ConfirmChurch] ,[Family] ,[Child] ,[CurrentParish]
      ,[ICPhoto] ,[PreviousChurch] ,[DeceasedDate] ,[CreatedDate], TransferReason 
      ,B.CellGroup, B.Congregation, CarIU, B.Remarks, BaptismByOthers, BaptismChurchOthers, ConfirmByOthers, ConfirmChurchOthers, PreviousChurchOthers
      , Convert(XML, ISNULL((SELECT B.CourseName, B.courseID AS CourseID from dbo.tb_course_participant AS A
		  INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
		  WHERE A.NRIC = @tNRIC
		  FOR XML PATH(''), ELEMENTS, ROOT('Course')), '<Course></Course>')) AS CourseAttended
      , B.ElectoralRoll, B.MinistryInvolvement, B.Sponsor1, B.Sponsor2, B.Sponsor2Contact, B.MemberDate, B.TransferTo, B.TransferToDate
      ,dbo.udf_getStafforMemberName(B.Sponsor1) AS Sponsor1Name
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
					FROM dbo.tb_DOSLogging AS A
					INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
					WHERE [TYPE] = 'I' AND Reference = @tNRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'Membership'
					ORDER BY A.ActionTime DESC 
					FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
	FROM dbo.tb_members_temp AS A
	INNER JOIN dbo.tb_membersOtherInfo_temp AS B ON A.NRIC = B.NRIC
	WHERE A.NRIC = @tNRIC
END

SET NOCOUNT OFF;

GO
