SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_addNewUser]
(@UserID VARCHAR(50),
 @Name VARCHAR(100),
 @Email VARCHAR(100),
 @Phone VARCHAR(100),
 @Mobile VARCHAR(100),
 @Department VARCHAR(100),
 @NRIC VARCHAR(50),
 @Password VARCHAR(40),
 @Style VARCHAR(2))
AS
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM dbo.tb_Users WHERE UserID = @UserID)
BEGIN
	SELECT 'UserID' AS Result;
END
ELSE IF EXISTS (SELECT * FROM dbo.tb_Users WHERE NRIC = @NRIC)
BEGIN
	SELECT 'NRIC' AS Result;
END
ELSE
BEGIN
	INSERT INTO dbo.tb_Users (UserID, Name, Email, Phone, Mobile, Department, NRIC, [Password], Style)
	SELECT @UserID, @Name, @Email, @Phone, @Mobile, @Department, @NRIC, @Password, @Style;
	
	SELECT 'OK' AS Result;
END
SET NOCOUNT OFF;
GO
