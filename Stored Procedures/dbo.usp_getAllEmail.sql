SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllEmail]

AS
SET NOCOUNT ON;

	Select EmailType, EmailContent FROM dbo.tb_emailContent
	

SET NOCOUNT OFF;

GO
