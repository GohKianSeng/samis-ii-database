SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllUploadedAttachment]
(@nric VARCHAR(20))
AS
SET NOCOUNT ON;

DECLARE @xml AS XML = ( select ISNULL(Remarks,' ') AS Remarks, AttachmentID, CONVERT(VARCHAR(15),[Date], 103) AS [DATE], [GUID], [Filename], A.FileType AS FileType FROM dbo.tb_members_attachments
						INNER JOIN dbo.tb_file_type AS A ON A.FileTypeID = dbo.tb_members_attachments.FileType
						WHERE NRIC = @nric FOR XML PATH('Attachment'), ELEMENTS, ROOT('AllAttachments'))		
SELECT CONVERT(XML, ISNULL(@xml, '<AllAttachments />')) AS [XML];

SET NOCOUNT OFF;
GO
