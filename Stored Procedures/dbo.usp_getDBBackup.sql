SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_getDBBackup]

AS
SET NOCOUNT ON;

DECLARE @tempLocation VARCHAR(1000) = (SELECT value FROM dbo.tb_App_Config WHERE ConfigName = 'DBBackupLocation')

DBCC SHRINKDATABASE (DOS, 10)

BACKUP DATABASE DOS
TO DISK = @tempLocation
   WITH FORMAT,
   NAME = 'Full Backup of SAMIS 2DB'
GO
