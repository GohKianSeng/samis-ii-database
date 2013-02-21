SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[udf_getMaritialStatus]
(
	-- Add the parameters for the function here
	@maritialstatus INT
)
RETURNS VARCHAR(10)
AS
BEGIN
DECLARE @res VARCHAR(100)

SELECT @res = MaritalStatusName FROM dbo.tb_maritalstatus WHERE MaritalStatusID = @maritialstatus

RETURN @res
END
GO
