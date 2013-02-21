SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_removeAttachment]
(@AttachmentID INT, @userID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @GUID VARCHAR(50);
DECLARE @Filename VARCHAR(200);
DECLARE @NRIC VARCHAR(20);

SELECT @NRIC = NRIC, @GUID = [GUID], @Filename = [Filename] FROM dbo.tb_members_attachments WHERE AttachmentID = @AttachmentID

DELETE FROM dbo.tb_members_attachments WHERE AttachmentID = @AttachmentID

DECLARE @XML AS XML = '<Changes>
  <AttachmentRemoved>
      <filename>' + @Filename + '</filename>
      <GUID>' + @GUID + '</GUID>      
    </AttachmentRemoved>
</Changes>'

EXEC dbo.usp_insertlogging 'I', @userID, 'Membership', 'Update', 1, 'NRIC', @NRIC, @XML;

SET NOCOUNT OFF;
GO
