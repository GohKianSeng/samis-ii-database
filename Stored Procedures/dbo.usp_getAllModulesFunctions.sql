
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_getAllModulesFunctions]
AS
SET NOCOUNT ON;

SELECT CONVERT(XML,(SELECT AppModFuncID, AppModFuncName, [Description] FROM dbo.tb_AppModFunc WHERE AppModFuncID like '%.%.%' FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules'))) AS Modules,
CONVERT(XML,(SELECT functionID, FunctionName, [Description] FROM dbo.tb_ModulesFunctions FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions'))) AS Functions

SET NOCOUNT OFF;

GO
