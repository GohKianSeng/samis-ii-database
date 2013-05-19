SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getCourseAdditionalInformation]
(@CourseID INT)
AS
SET NOCOUNT ON;

SELECT AgreementHTML, AgreementType FROM dbo.tb_course_agreement WHERE AgreementID = (SELECT AdditionalQuestion FROM dbo.tb_course WHERE courseID = @CourseID)

SET NOCOUNT OFF;
GO
