
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_SyncVisitorAndMembers]
(@XML XML)
AS
SET NOCOUNT ON;

BEGIN TRANSACTION;
BEGIN TRY
	
	DECLARE @idoc int;
	EXEC sp_xml_preparedocument @idoc OUTPUT, @XML;
	DECLARE @NewMemberTable TABLE(NewMemberXML XML, ID INT IDENTITY(1,1));
	DECLARE @NewCETable TABLE(NewCEXML XML, ID INT IDENTITY(1,1));
	DECLARE @Count INT;
	DECLARE @Index INT = 1;
	DECLARE @NRICDoneTable TABLE(NRIC VARCHAR(20), [Type] VARCHAR(7), [XML] XML, Successful BIT, PhotoFile VARCHAR(1000));
	
	DECLARE @CourseID INT;
	DECLARE @RegistrationDate DATE;
	DECLARE @AdditionalInformation XML;
	
	INSERT INTO @NewMemberTable (NewMemberXML)
	SELECT NewMember FROM OPENXML(@idoc, '/SyncData/AllMembers/*') WITH (NewMember XML '.');

	INSERT INTO @NewCETable (NewCEXML)
	SELECT NewMember FROM OPENXML(@idoc, '/SyncData/AllVisitors/*') WITH (NewMember XML '.');

	SET @Count = (SELECT COUNT(1) FROM @NewMemberTable);
	WHILE(@Index <= @Count)
	BEGIN
		DECLARE @NewXML XML = (SELECT NewMemberXML FROM @NewMemberTable WHERE ID = @Index);
		DECLARE @NRIC VARCHAR(20);

		DECLARE @feePaid BIT;
		DECLARE @materialReceived BIT;		
		
		DECLARE @ydoc int;
		EXEC sp_xml_preparedocument @ydoc OUTPUT, @NewXML;
		
		SELECT @CourseID = CourseID, @feePaid = feePaid, @NRIC = NRIC, @materialReceived = materialReceived,
		@RegistrationDate = CONVERT(DATETIME, RegistrationDate, 103), @AdditionalInformation = AdditionalInformation
		FROM OPENXML(@ydoc, '/New') WITH 
		(NRIC VARCHAR(20) './NRIC',
		 CourseID INT './CourseID',
		 feePaid BIT './feePaid',
		 materialReceived BIT './materialReceived',
		 RegistrationDate VARCHAR(10) './RegistrationDate',
		 AdditionalInformation XML './AdditionalInformation');
		
		IF EXISTS(SELECT 1 FROM dbo.tb_members WHERE NRIC = @NRIC)
		OR EXISTS(SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @NRIC)		
		BEGIN
			IF(@CourseID <> -1)
			BEGIN
				INSERT INTO dbo.tb_course_participant(NRIC, courseID, RegistrationDate, AdditionalInformation)
				SELECT @NRIC, @CourseID, @RegistrationDate, @AdditionalInformation
			END
			
			INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
			SELECT @NRIC, 'New', @NewXML, 1;
		END
		ELSE
		BEGIN
			DELETE FROM dbo.tb_visitors WHERE NRIC = @NRIC;
			DELETE FROM dbo.tb_membersOtherInfo_temp WHERE NRIC = @NRIC;
			DELETE FROM dbo.tb_members_temp WHERE NRIC = @NRIC;
			
			DECLARE @Res VARCHAR(10) = '0';
			EXEC dbo.usp_addNewMember @NewXML, @Res OUTPUT
			IF(@Res = '1')
			BEGIN
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @NRIC, 'New', @NewXML, 1;
				
				IF(@CourseID <> -1)
				BEGIN
					INSERT INTO dbo.tb_course_participant(NRIC, courseID, RegistrationDate, AdditionalInformation)
					SELECT @NRIC, @CourseID, @RegistrationDate, @AdditionalInformation
				END		
			END
			ELSE
			BEGIN
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @NRIC, 'New', @NewXML, 0;
			END
		END
		
		
		SET @Index = @Index + 1;
	END

	SET @Index = 1;
	SET @Count = (SELECT COUNT(1) FROM @NewCETable);
	DECLARE @TABLE TABLE(Result1 VARCHAR(10), Result2 VARCHAR(10), Result3 VARCHAR(10), Result4 VARCHAR(10))
	
	WHILE(@Index <= @Count)
	BEGIN
		DECLARE @VisitorXML XML = (SELECT NewCEXML FROM @NewCETable WHERE ID = @Index);
		DECLARE @VisitorNRIC VARCHAR(20);		
		
		DECLARE @xdoc int;
		EXEC sp_xml_preparedocument @xdoc OUTPUT, @VisitorXML;
		
		SELECT @AdditionalInformation = AdditionalInformation, @RegistrationDate = CONVERT(DATETIME, RegistrationDate, 103), @VisitorNRIC = NRIC, @CourseID = CourseID FROM OPENXML(@xdoc, '/Update') WITH 
		(NRIC VARCHAR(20) './NRIC',
		 CourseID INT './CourseID',
		 RegistrationDate VARCHAR(10) './RegistrationDate',
		 AdditionalInformation XML './AdditionalInformation');
		
		IF EXISTS(SELECT 1 FROM dbo.tb_members WHERE NRIC = @VisitorNRIC)
		BEGIN
			DECLARE @Temp1 VARCHAR(100) = 'NotFound';
			EXEC dbo.usp_updateMemberPartial @VisitorXML, @Temp1 OUTPUT;
			IF(@Temp1 <> 'NotFound')
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE NRIC = @VisitorNRIC AND courseID = @CourseID)
				BEGIN
					INSERT INTO dbo.tb_course_participant(courseID, NRIC, RegistrationDate, AdditionalInformation)
					SELECT @CourseID, @VisitorNRIC, @RegistrationDate, @AdditionalInformation
				END
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
			END
			ELSE
			BEGIN
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @VisitorNRIC, 'Update', @VisitorXML, 0;
			END						
		END
		ELSE IF EXISTS(SELECT 1 FROM dbo.tb_members_temp WHERE NRIC = @VisitorNRIC)
		BEGIN
			DECLARE @Temp2 VARCHAR(100) = 'NotFound';
			EXEC dbo.usp_updateMemberTempPartial @VisitorXML, @Temp2 OUTPUT;
			
			IF(@Temp2 <> 'NotFound')
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM dbo.tb_course_participant WHERE NRIC = @VisitorNRIC AND courseID = @CourseID)
				BEGIN
					INSERT INTO dbo.tb_course_participant(courseID, NRIC, RegistrationDate, AdditionalInformation)
					SELECT @CourseID, @VisitorNRIC, @RegistrationDate, @AdditionalInformation
				END
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
			END
			ELSE
			BEGIN
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @VisitorNRIC, 'Update', @VisitorXML, 0;
			END			
		END
		ELSE IF EXISTS(SELECT 1 FROM dbo.tb_visitors WHERE NRIC = @VisitorNRIC)
		BEGIN
			DECLARE @Result VARCHAR(100) = 'NotFound';
			EXEC dbo.usp_updateVistor @VisitorXML, @Result OUTPUT;
			
			IF(@Result <> 'NotFound')
			BEGIN
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
			END
			ELSE
			BEGIN
				INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
				SELECT @VisitorNRIC, 'Update', @VisitorXML, 0;
				
				INSERT INTO dbo.tb_course_participant(courseID, NRIC, RegistrationDate, AdditionalInformation)
				SELECT @CourseID, @VisitorNRIC, @RegistrationDate, @AdditionalInformation
			END			
		END
		ELSE
		BEGIN
			DECLARE @FResult VARCHAR(10), @SAR VARCHAR(10), @Name VARCHAR(50), @CourseName VARCHAR(100)
			EXEC dbo.usp_addNewCourseVisitorParticipant @VisitorXML, @CourseID, @FResult OUTPUT, @SAR OUTPUT, @Name OUTPUT, @CourseName OUTPUT, @AdditionalInformation
			
			INSERT INTO @NRICDoneTable(NRIC, [Type], [XML], Successful)
			SELECT @VisitorNRIC, 'Update', @VisitorXML, 1;
		END
		
		SET @Index = @Index + 1;
	END

	UPDATE @NRICDoneTable SET PhotoFile = B.ICPhoto
	FROM @NRICDoneTable AS A
	INNER JOIN dbo.tb_members_temp AS B ON B.NRIC = A.NRIC	
	
	SELECT NRIC, [Type], [XML], Successful, PhotoFile FROM @NRICDoneTable
	COMMIT TRANSACTION;
END TRY
BEGIN CATCH
	DECLARE @ErrorMSG XML;

	SET @ErrorMSG = (
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_STATE() AS ErrorState,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage FOR XML RAW, ELEMENTS)
	EXEC dbo.usp_insertlogging 'E', 'SQLERROR', '<SQLERROR />', 'usp_SyncVisitorAndMembers', '<SQLERROR />', 1, 0, @ErrorMSG;
	ROLLBACK TRANSACTION;
END CATCH;
	

SET NOCOUNT OFF;
GO
GO
