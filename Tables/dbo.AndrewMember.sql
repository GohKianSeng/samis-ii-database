CREATE TABLE [dbo].[AndrewMember]
(
[NRIC] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime2] (0) NULL,
[Nationality] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BlockNo] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HouseNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StreetName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [int] NULL CONSTRAINT [DF__AndrewMem__Posta__607D3EDD] DEFAULT ((0)),
[LanguageWrittenEnglish] [bit] NULL CONSTRAINT [DF__AndrewMem__Langu__61716316] DEFAULT ((0)),
[LanguageWrittenChinese] [bit] NULL CONSTRAINT [DF__AndrewMem__Langu__6265874F] DEFAULT ((0)),
[LanguageWrittenOthers] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LanguageSpokenEnglish] [bit] NULL CONSTRAINT [DF__AndrewMem__Langu__6359AB88] DEFAULT ((0)),
[LanguageSpokenChinese] [bit] NULL CONSTRAINT [DF__AndrewMem__Langu__644DCFC1] DEFAULT ((0)),
[LanguageSpokenOthers] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sex] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MartialStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfMarriage] [datetime2] (0) NULL,
[Salutation] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TelNo] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OfficeNo] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HPNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Occupation] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OccupationOthers] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Education] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EducationOthers] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Congregation] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CongregationOthers] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MemberStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MembershipTransferFrom] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOConversion] [datetime2] (0) NULL,
[DOBaptism] [datetime2] (0) NULL,
[DOConfirmation] [datetime2] (0) NULL,
[DOElectoralRoll] [datetime2] (0) NULL,
[MembershipTransferTo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DODeath] [datetime2] (0) NULL,
[OverseasBlockNo] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverseasHouseNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverseasStreetName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverseasPostalCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverseasCountry] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CellGroupName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSMA_TimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$BlockNo$disallow_zero_length] CHECK ((len([BlockNo])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$Education$disallow_zero_length] CHECK ((len([Education])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$Name$disallow_zero_length] CHECK ((len([Name])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$Nationality$disallow_zero_length] CHECK ((len([Nationality])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$NRIC$disallow_zero_length] CHECK ((len([NRIC])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$Occupation$disallow_zero_length] CHECK ((len([Occupation])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$OfficeNo$disallow_zero_length] CHECK ((len([OfficeNo])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$OverseasBlockNo$disallow_zero_length] CHECK ((len([OverseasBlockNo])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] WITH NOCHECK ADD CONSTRAINT [SSMA_CC$AndrewMember$TelNo$disallow_zero_length] CHECK ((len([TelNo])>(0)))
GO
ALTER TABLE [dbo].[AndrewMember] ADD CONSTRAINT [AndrewMember$PrimaryKey] PRIMARY KEY CLUSTERED  ([NRIC]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[BlockNo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'BlockNo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[CellGroupName]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'CellGroupName'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Congregation]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Congregation'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[CongregationOthers]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'CongregationOthers'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[DateOfMarriage]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'DateOfMarriage'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[DOB]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[DOBaptism]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'DOBaptism'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[DOConfirmation]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'DOConfirmation'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[DOConversion]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'DOConversion'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[DODeath]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'DODeath'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[DOElectoralRoll]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'DOElectoralRoll'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Education]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Education'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[EducationOthers]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'EducationOthers'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Email]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[HouseNo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'HouseNo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[HPNo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'HPNo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[LanguageSpokenChinese]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'LanguageSpokenChinese'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[LanguageSpokenEnglish]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'LanguageSpokenEnglish'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[LanguageSpokenOthers]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'LanguageSpokenOthers'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[LanguageWrittenChinese]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'LanguageWrittenChinese'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[LanguageWrittenEnglish]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'LanguageWrittenEnglish'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[LanguageWrittenOthers]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'LanguageWrittenOthers'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[MartialStatus]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'MartialStatus'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[MembershipTransferFrom]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'MembershipTransferFrom'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[MembershipTransferTo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'MembershipTransferTo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[MemberStatus]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'MemberStatus'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Name]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Nationality]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Nationality'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[NRIC]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'NRIC'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Occupation]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Occupation'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[OccupationOthers]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'OccupationOthers'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[OfficeNo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'OfficeNo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[OverseasBlockNo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'OverseasBlockNo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[OverseasCountry]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'OverseasCountry'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[OverseasHouseNo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'OverseasHouseNo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[OverseasPostalCode]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'OverseasPostalCode'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[OverseasStreetName]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'OverseasStreetName'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[PostalCode]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'PostalCode'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Salutation]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Salutation'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[Sex]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'Sex'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[StreetName]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'StreetName'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[TelNo]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'COLUMN', N'TelNo'
GO
EXEC sp_addextendedproperty N'MS_SSMA_SOURCE', N'SAMIS PROD.[AndrewMember].[PrimaryKey]', 'SCHEMA', N'dbo', 'TABLE', N'AndrewMember', 'CONSTRAINT', N'AndrewMember$PrimaryKey'
GO
