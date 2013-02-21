SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCongregation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,CongregationID) AS CongregationID, CongregationName FROM tb_congregation
	

SET NOCOUNT OFF;
GO
