CREATE TABLE [dbo].[tb_course]
(
[courseID] [int] NOT NULL IDENTITY(20, 1),
[CourseName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourseStartDate] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourseEndDate] [date] NULL,
[CourseStartTime] [time] NOT NULL,
[CourseEndTime] [time] NOT NULL,
[CourseInCharge] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CourseLocation] [tinyint] NOT NULL,
[CourseDay] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Deleted] [bit] NOT NULL CONSTRAINT [DF_tb_course_Deleted] DEFAULT ((0)),
[Fee] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_tb_course_Fee] DEFAULT ((0.00)),
[LastRegistrationDate] [date] NOT NULL,
[AdditionalQuestion] [int] NOT NULL CONSTRAINT [DF_tb_course_AdditionalQuestion] DEFAULT ((1))
) ON [PRIMARY]
ALTER TABLE [dbo].[tb_course] ADD 
CONSTRAINT [PK_tb_course] PRIMARY KEY CLUSTERED  ([courseID]) ON [PRIMARY]
ALTER TABLE [dbo].[tb_course] ADD
CONSTRAINT [FK_tb_course_tb_course_agreement] FOREIGN KEY ([AdditionalQuestion]) REFERENCES [dbo].[tb_course_agreement] ([AgreementID])
GO
