SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllSchool]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,SchoolID) AS SchoolID, SchoolName FROM tb_school ORDER BY SchoolName ASC
	

SET NOCOUNT OFF;
GO
