SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllHWSAttendanceDate]

AS
SET NOCOUNT ON;

	SELECT [WorshipDate] FROM [dbo].[tb_HokkienWorshipDate] order by [WorshipDate] desc;
	
SET NOCOUNT OFF;

GO
