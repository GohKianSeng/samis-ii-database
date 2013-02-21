SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getUserInformation]
(@UserID VARCHAR(50))
AS
SET NOCOUNT ON;

	SELECT UserID, Name, Email, Phone, Mobile, Department, NRIC, ISNULL(Style,'') AS Style FROM dbo.tb_Users
	WHERE UserID = @UserID
	FOR XML RAW('UserInformation'), ELEMENTS
	

SET NOCOUNT OFF;

GO
