CREATE TABLE [dbo].[tb_DOSLogging]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[ActionTime] [datetime] NOT NULL,
[Type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProgramReference] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DebugLevel] [tinyint] NOT NULL,
[Reference] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferenceType] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedElements] [xml] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_DOSLogging] ADD CONSTRAINT [PK_tb_AuditLog_LogID] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
