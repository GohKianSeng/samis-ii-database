CREATE TABLE [dbo].[tb_membersOtherInfo]
(
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ElectoralRoll] [date] NULL,
[CellGroup] [tinyint] NOT NULL CONSTRAINT [DF_tb_memberOtherInfo_CellGroup] DEFAULT ((0)),
[Congregation] [tinyint] NOT NULL,
[MinistryInvolvement] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_MinistryInvolvement] DEFAULT ('<Ministry></Ministry>'),
[MinistryInterested] [xml] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_MinistryInterested] DEFAULT ('<Ministry></Ministry>'),
[TithingInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_TithingInterested] DEFAULT ((0)),
[CellgroupInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_CellgroupInterested] DEFAULT ((0)),
[ServeCongregationInterested] [bit] NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_ServeCongregationInterested] DEFAULT ((0)),
[Sponsor1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sponsor2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sponsor2Contact] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_Sponsor2Contact] DEFAULT (''),
[MemberDate] [date] NULL,
[Remarks] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_Remarks] DEFAULT (''),
[TransferTo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_membersOtherInfo_TransferTo] DEFAULT (''),
[TransferToDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_membersOtherInfo] ADD CONSTRAINT [PK_tb_membersOtherInfo] PRIMARY KEY CLUSTERED  ([NRIC]) ON [PRIMARY]
GO
