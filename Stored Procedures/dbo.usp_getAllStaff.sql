SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllStaff]

AS
SET NOCOUNT ON;

	Select RTRIM(LTRIM(ISNULL(B.StyleName, '') + ' ' + Name)) AS Name, A.USERID, Email, Phone, Mobile, Department, ISNULL(D.RoleName, 'Unspecified') AS RoleName FROM tb_users AS A
	LEFT OUTER JOIN dbo.tb_style AS B ON A.Style = B.StyleID
	LEFT OUTER JOIN dbo.tb_Roles_Users AS C ON C.UserID = A.UserID
	LEFT OUTER JOIN dbo.tb_Roles AS D ON D.RoleID = C.RoleID
	WHERE A.Deleted = 0;

SET NOCOUNT OFF;

GO
