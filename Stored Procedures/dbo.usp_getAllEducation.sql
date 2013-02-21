SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllEducation]

AS
SET NOCOUNT ON;

	Select CONVERT(INT,EducationID) AS EducationID, EducationName FROM dbo.tb_education
	

SET NOCOUNT OFF;
GO
