SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_searchCityKidsForUpdate]
(@NRIC VARCHAR(10),
 @Name VARCHAR(50),
 @BusGroup VARCHAR(3),
 @ClubGroup VARCHAR(3),
 @UserID VARCHAR(50))
AS
SET NOCOUNT ON;

IF(LEN(@NRIC) > 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.NRIC LIKE '%'+@NRIC+'%' OR A.Name LIKE '%'+@Name+'%'	
	ORDER BY Name, NRIC
END

ELSE IF(LEN(@NRIC) > 0 AND LEN(@Name) = 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.NRIC LIKE '%'+@NRIC+'%'
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@NRIC) = 0 AND LEN(@Name) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.Name LIKE '%'+@Name+'%'
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@BusGroup) > 0 AND LEN(@ClubGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.BusGroupCluster = CONVERT(TINYINT, @BusGroup) AND A.ClubGroup = CONVERT(TINYINT, @ClubGroup)
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@BusGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.BusGroupCluster = CONVERT(TINYINT, @BusGroup)
	ORDER BY Name, NRIC
END
ELSE IF(LEN(@ClubGroup) > 0)
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	WHERE A.ClubGroup = CONVERT(TINYINT, @ClubGroup)
	ORDER BY Name, NRIC
END
ELSE
BEGIN
	SELECT TOP 100 A.NRIC, A.Name, DOB, dbo.udf_getGender(Gender) AS Gender, B.CountryName AS Nationality, Email, HomeTel, MobileTel, Points, C.ClubGroupName, D.BusGroupClusterName
	FROM dbo.tb_ccc_kids AS A
	LEFT OUTER JOIN dbo.tb_country AS B ON A.Nationality = B.CountryID
	LEFT OUTER JOIN dbo.tb_clubgroup AS C ON A.ClubGroup = C.ClubGroupID
	LEFT OUTER JOIN dbo.tb_busgroup_cluster AS D ON A.BusGroupCluster = D.BusGroupClusterID
	ORDER BY Name, NRIC
END


SET NOCOUNT OFF;

GO
