SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateUserInformation]
(@UserID VARCHAR(50),
 @Name VARCHAR(100),
 @Email VARCHAR(100),
 @Phone VARCHAR(100),
 @Mobile VARCHAR(100),
 @Department VARCHAR(100),
 @NRIC VARCHAR(50),
 @Style VARCHAR(2))
AS
SET NOCOUNT ON;

UPDATE dbo.tb_Users SET Name = @Name, Email = @Email, Phone = @Phone, Mobile = @Mobile, Department = @Department, Style = @Style
WHERE UserID = @UserID AND NRIC = @NRIC

SELECT (SELECT UserID, Name, Email, Phone, Mobile, Department, NRIC, Style FROM dbo.tb_Users 
WHERE UserID = @UserID AND NRIC = @NRIC
FOR XML RAW('UserInformation'), ELEMENTS) AS Result

SET NOCOUNT OFF;
GO
