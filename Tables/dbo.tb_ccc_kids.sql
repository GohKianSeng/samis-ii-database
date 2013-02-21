CREATE TABLE [dbo].[tb_ccc_kids]
(
[NRIC] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Gender] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DOB] [date] NOT NULL,
[HomeTel] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MobileTel] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressStreet] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressHouseBlk] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddressPostalCode] [int] NOT NULL,
[AddressUnit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Email] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_ccc_kids_Email] DEFAULT (''),
[SpecialNeeds] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_ccc_kids_SpecialNeeds] DEFAULT (''),
[EmergencyContact] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmergencyContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Transport] [bit] NOT NULL CONSTRAINT [DF_tb_ccc_kids_Transport] DEFAULT ((0)),
[Religion] [tinyint] NOT NULL CONSTRAINT [DF_tb_ccc_kids_Religion] DEFAULT ((0)),
[Race] [tinyint] NOT NULL,
[Nationality] [tinyint] NOT NULL,
[School] [tinyint] NOT NULL,
[ClubGroup] [tinyint] NOT NULL CONSTRAINT [DF_tb_ccc_kids_ClubGroup] DEFAULT ((0)),
[BusGroupCluster] [tinyint] NOT NULL CONSTRAINT [DF_tb_ccc_kids_BusGroupCluster] DEFAULT ((0)),
[Remarks] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_ccc_kids_Remarks] DEFAULT (''),
[Points] [int] NOT NULL CONSTRAINT [DF_tb_ccc_kids_Points] DEFAULT ((0)),
[Photo] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_ccc_kids_Photo] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_ccc_kids] ADD CONSTRAINT [PK_tb_ccc_kids] PRIMARY KEY CLUSTERED  ([NRIC]) ON [PRIMARY]
GO
