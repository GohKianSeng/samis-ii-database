SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateCityKidsPoints]
(@XML XML, @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

DECLARE @idoc int;
EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;

DECLARE @kidtable TABLE (NRIC VARCHAR(20), [Type] VARCHAR(1), Points INT, Remarks VARCHAR(1000));

INSERT INTO @kidtable (NRIC, [Type], Points, Remarks)
SELECT NRIC, [Type], Points, Remarks
FROM OPENXML(@idoc, '/UpdateCityKidPoints/Kid')
	WITH (
	NRIC VARCHAR(20)'./NRIC',
	[Type] VARCHAR(1)'./Type',
	Points INT'./Points',
	Remarks VARCHAR(1000)'./Remarks');

UPDATE dbo.tb_ccc_kids
SET dbo.tb_ccc_kids.Points = A.Points + dbo.tb_ccc_kids.Points    
FROM @kidtable AS A
WHERE A.NRIC = dbo.tb_ccc_kids.NRIC AND A.[Type] = '+';

UPDATE dbo.tb_ccc_kids
SET dbo.tb_ccc_kids.Points = dbo.tb_ccc_kids.Points - A.Points
FROM @kidtable AS A
WHERE A.NRIC = dbo.tb_ccc_kids.NRIC AND A.[Type] = '-';

UPDATE dbo.tb_ccc_kids
SET Points = 0 WHERE Points < 0

INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, [Description], DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference)
SELECT 'I', @UserID,  'CityKidMembership', 'Update', 1, CONVERT(XML,'<Changes><FromTo><Changes><ElementName>Points Added</ElementName><From>0</From><To>' + CONVERT(VARCHAR(3),Points) + '</To></Changes><Changes><ElementName>Remarks</ElementName><From>0</From><To>' + Remarks + '</To></Changes></FromTo></Changes>'), GETDATE(), 'NRIC', NRIC
FROM @kidtable WHERE [Type] = '+'

INSERT INTO dbo.tb_DOSLogging([Type], ActionBy, ProgramReference, [Description], DebugLevel, UpdatedElements, ActionTime, ReferenceType, Reference)
SELECT 'I', @UserID,  'CityKidMembership', 'Update', 1, CONVERT(XML,'<Changes><FromTo><Changes><ElementName>Points Deducted</ElementName><From>0</From><To>' + CONVERT(VARCHAR(3),Points) + '</To></Changes><Changes><ElementName>Remarks</ElementName><From>0</From><To>' + Remarks + '</To></Changes></FromTo></Changes>'), GETDATE(), 'NRIC', NRIC
FROM @kidtable WHERE [Type] = '-'


SET NOCOUNT OFF;

-- [dbo].[usp_UpdateCityKidsPoints] ''
GO
