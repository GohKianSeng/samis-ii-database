CREATE TABLE [dbo].[tb_members_attachments]
(
[AttachmentID] [int] NOT NULL IDENTITY(1, 1),
[Date] [date] NOT NULL,
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GUID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Filename] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileType] [tinyint] NOT NULL,
[Remarks] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_attachments_Remarks] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_members_attachments] ADD CONSTRAINT [PK_tb_member_attachments] PRIMARY KEY CLUSTERED  ([AttachmentID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_members_attachments] ADD CONSTRAINT [FK_tb_members_attachments_tb_file_type] FOREIGN KEY ([FileType]) REFERENCES [dbo].[tb_file_type] ([FileTypeID])
GO
