CREATE TABLE [dbo].[tb_congregation]
(
[CongregationID] [tinyint] NOT NULL IDENTITY(1, 1),
[CongregationName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[tb_congregation] ADD 
CONSTRAINT [PK_tb_congregation] PRIMARY KEY CLUSTERED  ([CongregationID]) ON [PRIMARY]
GO
