CREATE TABLE [dbo].[tb_clubgroup]
(
[ClubGroupID] [tinyint] NOT NULL IDENTITY(1, 1),
[ClubGroupName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_clubgroup] ADD CONSTRAINT [PK_tb_clubgroup] PRIMARY KEY CLUSTERED  ([ClubGroupID]) ON [PRIMARY]
GO
