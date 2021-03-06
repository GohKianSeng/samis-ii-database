CREATE TABLE [dbo].[tb_members_temp]
(
[Salutation] [tinyint] NOT NULL,
[EnglishName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChineseName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DOB] [date] NOT NULL,
[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Nationality] [tinyint] NOT NULL,
[Dialect] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_Dialect] DEFAULT ((0)),
[MaritalStatus] [tinyint] NOT NULL,
[MarriageDate] [date] NULL,
[AddressStreet] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressHouseBlk] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressPostalCode] [int] NOT NULL,
[AddressUnit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Education] [tinyint] NOT NULL,
[Language] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Occupation] [tinyint] NOT NULL,
[HomeTel] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MobileTel] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BaptismDate] [date] NULL,
[BaptismBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BaptismByOthers] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_temp_BaptismByOthers] DEFAULT (''),
[BaptismChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_BaptismChurch] DEFAULT ((0)),
[BaptismChurchOthers] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_temp_BaptismChurchOthers] DEFAULT (''),
[ConfirmDate] [date] NULL,
[ConfirmBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ConfirmByOthers] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_temp_ConfirmByOthers] DEFAULT (''),
[ConfirmChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_ConfirmChurch] DEFAULT ((0)),
[ConfirmChurchOthers] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_temp_ConfirmChurchOthers] DEFAULT (''),
[TransferReason] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_temp_TransferReason] DEFAULT (''),
[Family] [xml] NOT NULL,
[Child] [xml] NOT NULL,
[CurrentParish] [tinyint] NOT NULL,
[ICPhoto] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PreviousChurch] [tinyint] NOT NULL CONSTRAINT [DF_tb_members_temp_PreviousChurch] DEFAULT ((0)),
[PreviousChurchOthers] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_temp_PreviousChurchOthers] DEFAULT (''),
[DeceasedDate] [date] NULL,
[CreatedDate] [date] NOT NULL CONSTRAINT [DF_tb_members_temp_CreatedDate] DEFAULT (getdate()),
[CarIU] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_members_temp_CarIU] DEFAULT (''),
[MarkSync] [bit] NOT NULL CONSTRAINT [DF_tb_members_temp_MarkSync] DEFAULT ((0)),
[ReceiveMailingList] [bit] NOT NULL CONSTRAINT [DF_tb_members_temp_ReceiveMailingList] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_members_temp] ADD CONSTRAINT [PK_tb_members_temp] PRIMARY KEY CLUSTERED  ([NRIC]) ON [PRIMARY]
GO
