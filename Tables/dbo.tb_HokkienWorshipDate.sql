CREATE TABLE [dbo].[tb_HokkienWorshipDate]
(
[WorshipDate] [date] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_HokkienWorshipDate] ADD CONSTRAINT [PK_tb_HokkienWorshipDate] PRIMARY KEY CLUSTERED  ([WorshipDate]) ON [PRIMARY]
GO
