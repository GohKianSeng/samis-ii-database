CREATE TABLE [dbo].[tb_course_agreement]
(
[AgreementID] [int] NOT NULL IDENTITY(1, 1),
[AgreementType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgreementHTML] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_course_agreement] ADD CONSTRAINT [PK_tb_course_agreement] PRIMARY KEY CLUSTERED  ([AgreementID]) ON [PRIMARY]
GO
