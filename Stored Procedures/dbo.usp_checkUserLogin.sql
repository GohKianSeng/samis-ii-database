SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_checkUserLogin]
(@UserID VARCHAR(50),
 @Password VARCHAR(40))
AS
SET NOCOUNT ON;

SELECT (SELECT UserID, Name, Email, Phone, Mobile, Department, ISNULL(Style,'') AS Style, NRIC FROM dbo.tb_Users 
WHERE UserID = @UserID AND [Password] = @Password
FOR XML RAW('UserInformation'), ELEMENTS) AS Result

SET NOCOUNT OFF;

GO
