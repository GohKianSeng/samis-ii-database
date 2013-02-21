CREATE TABLE [dbo].[tb_membersOtherInfo_temp]
(
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ElectoralRoll] [date] NULL,
[CellGroup] [tinyint] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_CellGroup] DEFAULT ((0)),
[Congregation] [tinyint] NOT NULL,
[MinistryInvolvement] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_MinistryInvolvement] DEFAULT ('<Ministry></Ministry>'),
[MinistryInterested] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_MinistryInterested] DEFAULT ('<Ministry></Ministry>'),
[TithingInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_TithingInterested] DEFAULT ((0)),
[CellgroupInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_CellgroupInterested] DEFAULT ((0)),
[ServeCongregationInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_ServeCongregationInterested] DEFAULT ((0)),
[Sponsor1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sponsor2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sponsor2Contact] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_Sponsor2Contact] DEFAULT (''),
[MemberDate] [date] NULL,
[Remarks] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_Remarks] DEFAULT (''),
[TransferTo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_temp_TransferTo] DEFAULT (''),
[TransferToDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_membersOtherInfo_temp] ADD CONSTRAINT [PK_tb_membersOtherInfo_temp] PRIMARY KEY CLUSTERED  ([NRIC]) ON [PRIMARY]
GO
