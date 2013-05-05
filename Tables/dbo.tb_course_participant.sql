CREATE TABLE [dbo].[tb_course_participant]
(
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[courseID] [int] NOT NULL,
[feePaid] [bit] NOT NULL CONSTRAINT [DF_tb_course_participant_feePaid] DEFAULT ((0)),
[materialReceived] [bit] NOT NULL CONSTRAINT [DF_tb_course_participant_materialReceived] DEFAULT ((0)),
[RegistrationDate] [datetime] NOT NULL CONSTRAINT [DF_tb_course_participant_RegistrationDate] DEFAULT (getdate()),
[MarkSync] [bit] NOT NULL CONSTRAINT [DF_tb_course_participant_MarkSync] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_course_participant] ADD CONSTRAINT [PK_tb_course_participant] PRIMARY KEY CLUSTERED  ([NRIC], [courseID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_course_participant] ADD CONSTRAINT [FK_tb_course_participant_tb_course] FOREIGN KEY ([courseID]) REFERENCES [dbo].[tb_course] ([courseID])
GO
