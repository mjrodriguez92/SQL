USE P_Libre_MDS
GO

DROP TABLE #TMP
GO

DROP TABLE #T
GO

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


CREATE TABLE #TMP
(
	UnitSN varchar(200)
)

INSERT INTO #TMP SELECT 'L2B22010099000141000437167'
INSERT INTO #TMP SELECT 'L2B22010099000141000437058'
INSERT INTO #TMP SELECT 'L2B22010099000141000437079'
INSERT INTO #TMP SELECT 'L2B2201009900014100043716E'
INSERT INTO #TMP SELECT 'L2B22010099000141000437096'
INSERT INTO #TMP SELECT 'L2B22010099000141000437105'
INSERT INTO #TMP SELECT 'L2B22010099000141000437136'
INSERT INTO #TMP SELECT 'L2B22010099000141000437157'
INSERT INTO #TMP SELECT 'L2B22010099000141000437272'
INSERT INTO #TMP SELECT 'L2B22010099000141000437196'
INSERT INTO #TMP SELECT 'L2B22010099000141000437275'

--SELECT count(*) FROM #TMP

;WITH Unit AS(
	SELECT Unit.Unit_Id, Unit.SerialNumber, Unit.PartNumber_Id, Unit.Workorder_Id, Unit.ParentUnit_Id, Unit.SampleUnit, Unit.CreateDttm
	FROM DS_FT_Unit Unit
	INNER JOIN #TMP t ON Unit.SerialNumber = t.UnitSN
	--WHERE Unit.SerialNumber IN 
	--('L1B1201006900014070008978E')
)


SELECT 
	Unit.SerialNumber,
	SPITest.TestResult SPITestResult,
	AOITest.TestResult AOITestResult,
	CASE WHEN LEFT (Unit.SerialNumber,2) != 'L2' THEN 'NA' ELSE CAST(RFTest.TestResult AS varchar(1)) END RFTestResult,
	FCTest.TestResult FCTestResult,
	CASE WHEN (tray.trayResult IS NULL) THEN 0 ELSE 1 END TraySorterTest,
	f.FileName SPIFileName,
	AOITest.TestEndDate AOITestEndDate,  ff.FileName AOIFileName,
	CASE WHEN LEFT (Unit.SerialNumber,2) != 'L2' THEN 'NA' ELSE CONVERT(varchar(20),RFTest.TestEndDate,121) END RFTestEndDate,  
	CASE WHEN LEFT (Unit.SerialNumber,2) != 'L2' THEN 'NA' ELSE ffff.FileName END RFFileName,
	FCTest.TestEndDate FCTestEndDate,  fff.FileName FCFileName,
	ftray.FileName TraySorterFileName
INTO #T
FROM Unit 
LEFT JOIN [dbo].[DS_FT_SPITest] SPITest on Unit.Unit_Id = SPITest.UNit_Id
LEFT JOIN [dbo].[Log_InFileProcess] f ON f.[InFileProcess_Id] = SPITest.InFileProcess_Id
LEFT JOIN [dbo].[DS_FT_AOITest] AOITest ON Unit.Unit_Id = AOITest.UNit_Id
LEFT JOIN [dbo].[Log_InFileProcess] ff ON ff.[InFileProcess_Id] = AOITest.InFileProcess_Id
LEFT JOIN DS_FT_FCTest FCTest on Unit.Unit_Id = FCTest.UNit_Id
LEFT JOIN [dbo].[Log_InFileProcess] fff ON fff.[InFileProcess_Id] = FCTest.InFileProcess_Id
LEFT JOIN [dbo].[DS_FT_RFTest] RFTest ON Unit.Unit_Id = RFTest.UNit_Id
LEFT JOIN [dbo].[Log_InFileProcess] ffff ON ffff.[InFileProcess_Id] = RFTest.InFileProcess_Id
LEFT JOIN
(
	SELECT 
		tray.Unit_Id, 
		tray.a+tray.b+tray.c+tray.d+tray.e+	isnull(tray.f,0)+isnull(tray.g,0)+ tray.h trayResult
	FROM
	(
		SELECT 
			t.Unit_Id, 
			sum(CAST(ts.AckFlag as INT))-COUNT(*) a,
			sum(CAST(SPITest.TestResult as INT))-COUNT(*) b,
			sum(CAST(SPITest.AckFlag as INT))-COUNT(*) c,
			sum(CAST(AOITest.TestResult as INT))-COUNT(*) d,
			sum(CAST(AOITest.AckFlag as INT))-COUNT(*) e,
			sum(CAST(RFTest.TestResult as INT))-COUNT(*) f,
			sum(CAST(RFTest.AckFlag as INT))-COUNT(*) g,
			sum(CAST(FCTest.TestResult as INT))-COUNT(*) h
		FROM DS_FT_TraySorter ts
		INNER JOIN
		(
			select Unit.Unit_Id, InFileProcess_Id
			from Unit
			INNER JOIN DS_FT_TraySorter tray 
				on tray.Unit_Id=Unit.Unit_Id
		)t 
		ON t.InFileProcess_Id =  ts.InFileProcess_Id
		INNER JOIN [dbo].[DS_FT_SPITest] SPITest on ts.Unit_Id = SPITest.UNit_Id
		INNER JOIN [dbo].[DS_FT_AOITest] AOITest ON ts.Unit_Id = AOITest.UNit_Id
		INNER JOIN DS_FT_FCTest FCTest on ts.Unit_Id = FCTest.UNit_Id
		LEFT JOIN [dbo].[DS_FT_RFTest] RFTest ON ts.Unit_Id = RFTest.UNit_Id
		GROUP BY t.Unit_Id
	)tray
)tray on tray.Unit_Id = Unit.Unit_Id
	left JOIN DS_FT_TraySorter tray2 on tray2.Unit_Id=Unit.Unit_Id
	left JOIN [dbo].[Log_InFileProcess] ftray ON tray2.[InFileProcess_Id] = ftray.InFileProcess_Id


SELECT *
FROM #T

