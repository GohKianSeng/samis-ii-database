SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllPostalCode]

AS
SET NOCOUNT ON;

	Select PostalAreaName, PostalDigit FROM dbo.tb_postalArea
	

SET NOCOUNT OFF;
GO
