SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateRolesUserID]
(@UserID VARCHAR(MAX),
 @Role VARCHAR(3))
AS

BEGIN TRY

	SET NOCOUNT ON;

	DECLARE @UserIDTable TABLE (ID INT IDENTITY (0,1), UserID VARCHAR(50))
	DECLARE @InvalidUser TABLE (ID INT IDENTITY (0,1), UserID VARCHAR(50))
	DECLARE @UpdatedUser TABLE (ID INT IDENTITY (0,1), UserID VARCHAR(50))

	INSERT INTO @UserIDTable(UserID)
	SELECT LTRIM(RTRIM(Items)) FROM dbo.udf_Split(@UserID, ',')
	
	
	DELETE FROM @UserIDTable OUTPUT DELETED.UserID INTO @InvalidUser WHERE UserID NOT IN (SELECT UserID FROM dbo.tb_Users)
	DELETE FROM @UserIDTable OUTPUT DELETED.UserID INTO @UpdatedUser WHERE UserID IN (SELECT UserID FROM dbo.tb_Roles_Users)
	
	INSERT INTO dbo.tb_Roles_Users (RoleID, UserID)
	SELECT @Role, UserID FROM @UserIDTable

	UPDATE dbo.tb_Roles_Users SET RoleID = @Role
	WHERE UserID IN (SELECT UserID FROM @UpdatedUser)
	
	DECLARE @IndividualUserID VARCHAR(50)
	DECLARE @X INT = 0
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM @UpdatedUser
	WHILE @X < @COUNT
	BEGIN
		SELECT @IndividualUserID = UserID FROM @UpdatedUser WHERE ID=@X
		--EXEC dbo.usp_updateUserPreferences @IndividualUserID, 'HomePage', '1.1.1';
		SET @X = @X +1
	END
	
	SET @X = 0
	SELECT @COUNT = COUNT(*) FROM @UserIDTable
	WHILE @X < @COUNT
	BEGIN
		SELECT @IndividualUserID = UserID FROM @UserIDTable WHERE ID=@X
		--EXEC dbo.usp_updateUserPreferences @IndividualUserID, 'HomePage', '1.1.1';
		SET @X = @X +1
	END

	SELECT ISNULL((SELECT UserID FROM @UserIDTable
			FOR XML RAW(''), ELEMENTS, Root('AddedUsers')
			), '<AddedUsers />') AS AddedUsers,
		   ISNULL((SELECT UserID FROM @UpdatedUser
			FOR XML RAW(''), ELEMENTS, Root('UpdatedUsers')
			), '<UpdatedUsers />') AS UpdatedUsers,
		   ISNULL((SELECT UserID FROM @InvalidUser
			FOR XML RAW(''), ELEMENTS, Root('InvalidUsers')
			), '<InvalidUsers />') AS InvalidUsers

	SET NOCOUNT OFF;
END TRY	
	
BEGIN CATCH
	
	DECLARE @ErrorMSG XML;
	
	SET @ErrorMSG = (
	SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage FOR XML RAW, ELEMENTS)
	
	EXEC dbo.usp_insertlogging 'E', 'SQLERROR', '<SQLERROR />', 'usp_updatedRolesUserID', '<SQLERROR />', 1, 0, @ErrorMSG;
	SET NOCOUNT OFF;
	
END CATCH
GO
