SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_resetUserPassword]
(@UserID VARCHAR(50),
 @Password VARCHAR(40))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_Users SET [Password] = @Password WHERE UserID = @UserID

SELECT @@ROWCOUNT;

SET NOCOUNT OFF;
GO