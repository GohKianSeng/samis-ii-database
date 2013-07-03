CREATE TABLE [dbo].[tb_HokkienMember]
(
[ID] [int] NOT NULL IDENTITY(1000, 1),
[EnglishSurname] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_EnglishSurname] DEFAULT (''),
[EnglishGivenName] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_EnglishGivenName] DEFAULT (''),
[ChineseSurname] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_ChineseSurname] DEFAULT (''),
[ChineseGivenName] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_ChineseGivenName] DEFAULT (''),
[Birthday] [date] NULL,
[Contact] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_Contact] DEFAULT (''),
[AddressHouseBlock] [varchar] (70) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Table_1_AddressBlock] DEFAULT (''),
[AddressStreet] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Table_1_AddressStreetName] DEFAULT (''),
[AddressUnit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_AddressUnit] DEFAULT (''),
[AddressPostalCode] [int] NOT NULL CONSTRAINT [DF_tb_HokkienMember_AddressPostalCode] DEFAULT ((0)),
[Photo] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_Photo] DEFAULT (''),
[NextOfKinName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_NextOfKinName] DEFAULT (''),
[NextOfKinContact] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_NextOfKinContact] DEFAULT (''),
[Remarks] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_HokkienMember_Remarks] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_HokkienMember] ADD CONSTRAINT [PK_tb_HokkienMember] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
