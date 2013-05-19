SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllCourseAdditionalInfo]

AS
SET NOCOUNT ON;

	Select AgreementID, AgreementType, AgreementHTML FROM dbo.tb_course_agreement
	

SET NOCOUNT OFF;
GO
