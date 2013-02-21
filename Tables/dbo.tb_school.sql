CREATE TABLE [dbo].[tb_school]
(
[SchoolID] [int] NOT NULL IDENTITY(1, 1),
[SchoolName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_school] ADD CONSTRAINT [PK_tb_school] PRIMARY KEY CLUSTERED  ([SchoolID]) ON [PRIMARY]
GO
