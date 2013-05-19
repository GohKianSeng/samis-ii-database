SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncAllSettings_AdditionalInformation]
(@XML XML)
AS
SET NOCOUNT ON;

DECLARE @Table TABLE(ID INT, Value1 VARCHAR(1000), Value2 VARCHAR(MAX))
INSERT INTO @Table(ID, Value1, Value2)
SELECT T2.Loc.value('./AgreementID[1]','int'), T2.Loc.value('./AgreementType[1]','VARCHAR(1000)'), T2.Loc.value('./AgreementHTML[1]','VARCHAR(MAX)')
FROM @XML.nodes('/All/AllChurchAgreement/*') as T2(Loc)

UPDATE dbo.tb_course_agreement SET dbo.tb_course_agreement.AgreementType = A.Value1, dbo.tb_course_agreement.AgreementHTML = A.Value2
FROM @Table AS A WHERE dbo.tb_course_agreement.AgreementID = A.ID

SET IDENTITY_INSERT dbo.tb_course_agreement ON

INSERT INTO dbo.tb_course_agreement(AgreementID, AgreementType, AgreementHTML)
SELECT ID, Value1, Value2 FROM @Table
WHERE ID NOT IN (SELECT AgreementID FROM dbo.tb_course_agreement)

SET IDENTITY_INSERT dbo.tb_course_agreement OFF

IF EXISTS(SELECT 1 FROM @Table)
DELETE FROM dbo.tb_course_agreement WHERE AgreementID NOT IN (SELECT ID FROM @Table);

SELECT 'Updated' AS Result;

SET NOCOUNT OFF;
GO
