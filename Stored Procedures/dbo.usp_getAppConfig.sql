SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAppConfig]
AS
SET NOCOUNT ON;
SELECT [ConfigName]
      ,[value]
  FROM [dbo].[tb_App_Config];
SET NOCOUNT OFF;
GO