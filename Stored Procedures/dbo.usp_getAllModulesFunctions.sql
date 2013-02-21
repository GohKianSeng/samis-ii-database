SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getAllModulesFunctions]
/*
* Created by: Goh Kian Seng
* Date: 30/05/2012
* Used by: ITSM, PSPL\SMUser
* Called by: ITSCController.cs
*
* Purpose: Get all module and function for user administration
*
*
*/ 
AS
SET NOCOUNT ON;

SELECT CONVERT(XML,(SELECT AppModFuncID, AppModFuncName FROM dbo.tb_AppModFunc WHERE AppModFuncID like '%.%.%' FOR XML PATH('Module'), ELEMENTS, ROOT('AllModules'))) AS Modules,
CONVERT(XML,(SELECT functionID, FunctionName FROM dbo.tb_ModulesFunctions FOR XML PATH('Function'), ELEMENTS, ROOT('AllFunctions'))) AS Functions

SET NOCOUNT OFF;
GO
