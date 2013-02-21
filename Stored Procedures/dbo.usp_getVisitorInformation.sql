SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getVisitorInformation]
(@NRIC VARCHAR(10))
AS
SET NOCOUNT ON;


	SELECT [EnglishName], CONVERT(VARCHAR(5), [Salutation]) AS Salutation
      ,ISNULL(CONVERT(VARCHAR(10),[DOB],103), '') AS DOB ,[Gender] ,@NRIC AS [NRIC] , CONVERT(VARCHAR(5),[Nationality]) AS [Nationality]
      ,[AddressStreet] ,[AddressHouseBlk] , ISNULL(CONVERT(VARCHAR(6),[AddressPostalCode]),'' ) AS [AddressPostalCode] ,[AddressUnit] ,[Email]
      ,CONVERT(VARCHAR(5), [Education]) AS Education , CONVERT(VARCHAR(5),[Occupation]) AS [Occupation], Contact 
      ,CONVERT(VARCHAR(3),A.Church) AS Church, A.ChurchOthers
      ,   Convert(XML, ISNULL((SELECT B.CourseName AS CourseName, B.courseID AS CourseID from dbo.tb_course_participant AS A
		  INNER JOIN dbo.tb_course AS B ON A.courseID = B.courseID
		  WHERE A.NRIC = @NRIC
		  FOR XML PATH(''), ELEMENTS, ROOT('Course')), '<Course></Course>')) AS CourseAttended       
      ,CONVERT(XML,(SELECT [Description], CONVERT(VARCHAR(20),ActionTime, 103) + ' ' + CONVERT(VARCHAR(20),ActionTime, 108) AS ActionTime, B.Name AS ActionBy, UpdatedElements 
					FROM dbo.tb_DOSLogging AS A
					INNER JOIN dbo.tb_Users AS B ON A.ActionBy = B.UserID
					WHERE [TYPE] = 'I' AND Reference = @NRIC AND ReferenceType = 'NRIC' AND ProgramReference = 'VisitorMembership'
					ORDER BY A.ActionTime DESC 
					FOR XML PATH('row'), ELEMENTS, ROOT('History'))) AS History
	FROM dbo.tb_visitors AS A
	WHERE A.NRIC = @NRIC


SET NOCOUNT OFF;
GO
