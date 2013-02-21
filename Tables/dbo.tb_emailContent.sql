CREATE TABLE [dbo].[tb_emailContent]
(
[EmailID] [int] NOT NULL IDENTITY(1, 1),
[EmailType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailContent] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
