SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_insertloggingNoReturn] 
	(@Type CHAR(1),
	 @ActionBy varchar(50),
	 @ProgramReference varchar(100),
	 @Description VARCHAR(2000),
	 @DebugLevel INT,
	 @ReferenceType VARCHAR(100),
	 @Reference VARCHAR(100),
	 @Updates XML)	
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @definedLogLevel TINYINT;
    SET @definedLogLevel = 1; --(SELECT TOP 1[logLevel] FROM [log].[dbo].[logRequirement])
	IF (@DebugLevel <= @definedLogLevel)
	BEGIN
		INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, Description, DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference) VALUES (@Type, @ActionBy, @ProgramReference, @Description, @DebugLevel, ISNULL(@Updates, '<empty />'), GETDATE(), @ReferenceType, @Reference);
--		DECLARE @LogID INT
	END
	SET NOCOUNT ON;
END
GO
