SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllMaritalStatus]

AS
SET NOCOUNT ON;

	Select MaritalStatusID, MaritalStatusName FROM dbo.tb_maritalstatus;
	

SET NOCOUNT OFF;
GO
