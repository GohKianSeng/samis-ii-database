SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllOccupation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,OccupationID) AS OccupationID, OccupationName FROM tb_occupation
	

SET NOCOUNT OFF;
GO
