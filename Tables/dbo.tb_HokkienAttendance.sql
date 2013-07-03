CREATE TABLE [dbo].[tb_HokkienAttendance]
(
[ID] [int] NOT NULL,
[AttendanceDate] [date] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_HokkienAttendance] ADD CONSTRAINT [PK_tb_HokkienAttendance] PRIMARY KEY CLUSTERED  ([ID], [AttendanceDate]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tb_HokkienAttendance] ADD CONSTRAINT [FK_tb_HokkienAttendance_tb_HokkienWorshipDate] FOREIGN KEY ([AttendanceDate]) REFERENCES [dbo].[tb_HokkienWorshipDate] ([WorshipDate])
GO
