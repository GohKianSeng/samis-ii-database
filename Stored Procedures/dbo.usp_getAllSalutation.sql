SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSalutation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,SalutationID) AS SalutationID, SalutationName FROM dbo.tb_Salutation
	

SET NOCOUNT OFF;
GO
