
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_UpdateHWSAttendance]
(@ID INT)
AS
SET NOCOUNT ON;

IF NOT EXISTS(SELECT 1 FROM [dbo].[tb_HokkienWorshipDate] WHERE [WorshipDate] = CONVERT(DATE, GETDATE()))
BEGIN
	INSERT INTO [dbo].[tb_HokkienWorshipDate]
	SELECT CONVERT(DATE, GETDATE())
END

IF NOT EXISTS(SELECT 1 FROM [dbo].[tb_HokkienAttendance] WHERE ID = @ID AND AttendanceDate = CONVERT(DATE, GETDATE()))
BEGIN
	INSERT INTO [dbo].[tb_HokkienAttendance]
	SELECT @ID, CONVERT(DATE, GETDATE())
END

SELECT [EnglishSurname], [EnglishGivenName], [ChineseSurname], [ChineseGivenName] FROM [dbo].[tb_HokkienMember] WHERE ID = @ID;

SET NOCOUNT OFF;

GO
