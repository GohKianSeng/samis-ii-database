SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateUserPassword]
(@UserID VARCHAR(50),
 @oldPassword VARCHAR(40),
 @newPassword VARCHAR(50))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_Users SET [Password] = @newPassword
WHERE UserID = @UserID AND [Password] = @oldPassword

SELECT @@ROWCOUNT AS Result

SET NOCOUNT OFF;
GO
