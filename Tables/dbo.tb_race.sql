CREATE TABLE [dbo].[tb_race]
(
[RaceID] [tinyint] NOT NULL IDENTITY(1, 1),
[RaceName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_race] ADD CONSTRAINT [PK_tb_race] PRIMARY KEY CLUSTERED  ([RaceID]) ON [PRIMARY]
GO
