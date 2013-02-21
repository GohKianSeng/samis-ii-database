CREATE TABLE [dbo].[tb_education]
(
[EducationID] [tinyint] NOT NULL IDENTITY(1, 1),
[EducationName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_education] ADD CONSTRAINT [PK_tb_education] PRIMARY KEY CLUSTERED  ([EducationID]) ON [PRIMARY]
GO
