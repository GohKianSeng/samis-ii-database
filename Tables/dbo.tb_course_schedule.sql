CREATE TABLE [dbo].[tb_course_schedule]
(
[CourseID] [int] NOT NULL,
[Date] [date] NOT NULL,
[Remark] [nchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_course_schedule] ADD CONSTRAINT [PK_tb_course_schedule] PRIMARY KEY CLUSTERED  ([CourseID], [Date]) ON [PRIMARY]
GO
