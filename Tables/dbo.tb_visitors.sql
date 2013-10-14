CREATE TABLE [dbo].[tb_visitors]
(
[Salutation] [tinyint] NULL,
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EnglishName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DOB] [date] NULL,
[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Education] [tinyint] NULL,
[Occupation] [tinyint] NULL,
[Nationality] [tinyint] NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_visitors_Email] DEFAULT (''),
[Contact] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_visitors_Contact] DEFAULT (''),
[AddressStreet] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressHouseBlk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressPostalCode] [int] NULL,
[AddressUnit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Church] [tinyint] NOT NULL CONSTRAINT [DF_tb_visitors_Church] DEFAULT ((0)),
[ChurchOthers] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_visitors_ChurchOthers] DEFAULT (''),
[VisitorType] [tinyint] NOT NULL,
[ReceiveMailingList] [bit] NOT NULL CONSTRAINT [DF_tb_visitors_ReceiveMailingList] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_visitors] ADD CONSTRAINT [PK_tb_visitors] PRIMARY KEY CLUSTERED  ([NRIC]) ON [PRIMARY]
GO
