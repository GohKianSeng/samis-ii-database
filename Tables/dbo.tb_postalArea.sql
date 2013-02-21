CREATE TABLE [dbo].[tb_postalArea]
(
[District] [int] NOT NULL IDENTITY(1, 1),
[PostalAreaName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PostalDigit] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_tb_postalArea_PostalDigit] DEFAULT ('')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_postalArea] ADD CONSTRAINT [PK_tb_postalArea] PRIMARY KEY CLUSTERED  ([District]) ON [PRIMARY]
GO
