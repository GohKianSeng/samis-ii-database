SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllClergy]

AS
SET NOCOUNT ON;

	Select NRIC, UserID, B.StyleName + ' ' + Name AS Name FROM tb_users AS A
	INNER JOIN dbo.tb_style AS B ON A.Style = B.StyleID
	

SET NOCOUNT OFF;
GO
