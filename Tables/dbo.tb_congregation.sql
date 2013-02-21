CREATE TABLE [dbo].[tb_congregation]
(
[CongregationID] [tinyint] NOT NULL IDENTITY(1, 1),
[CongregationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_congregation] ADD CONSTRAINT [PK_tb_congregation_1] PRIMARY KEY CLUSTERED  ([CongregationID], [CongregationName]) ON [PRIMARY]
GO
