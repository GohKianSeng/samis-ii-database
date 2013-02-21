SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
* Created by: Goh Kian Seng
* Date: 15/03/2012
* Used by: ITSM
* Called by: ITSCController.cs
*
* Purpose: list of roles
*  
*/

CREATE PROCEDURE [dbo].[usp_listOfRoles]

AS
SET NOCOUNT ON;

SELECT [RoleID] ,[RoleName]
  FROM [dbo].[tb_Roles] ORDER BY [RoleName] ASC

SET NOCOUNT OFF;
GO
