CREATE TABLE [dbo].[tb_Users]
(
[UserID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Phone] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mobile] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_Users_Password] DEFAULT (''),
[Style] [int] NULL CONSTRAINT [DF_tb_Users_Appointment] DEFAULT ((0)),
[Deleted] [bit] NOT NULL CONSTRAINT [DF_tb_Users_Deleted] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_Users] ADD CONSTRAINT [PK_tb_Users] PRIMARY KEY CLUSTERED  ([UserID]) ON [PRIMARY]
GO
