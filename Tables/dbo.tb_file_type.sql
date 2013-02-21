CREATE TABLE [dbo].[tb_file_type]
(
[FileTypeID] [tinyint] NOT NULL IDENTITY(1, 1),
[FileType] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_file_type] ADD CONSTRAINT [PK_tb_file_type] PRIMARY KEY CLUSTERED  ([FileTypeID]) ON [PRIMARY]
GO
