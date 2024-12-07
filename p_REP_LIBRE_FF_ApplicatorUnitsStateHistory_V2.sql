USE p_REP_LIBRE_FF
GO
/*
***************************************************************************
Author			: Santos Morales
Creation Date	: 2020-11-19
Explanation	:  Deviation BGDEV000203 Query for Applicator
Script Version	: 1

Output			:  All the units that has a lack of mandatory step/UnitState on FFHistory from Applicator	
Is used			:  ON DEMAND (Every time OPS want to review a kitpack order before to ship)
History			:
Santos Morales - 2020-11-02 Added cosmetic Changes
Santos Morales - 2020-11-19 Making Stored procedure and searching by production order ID


**************************************************************************
*/
--Alter PROCEDURE dbo.udpApplicatorDeviatonRDL
--@ApplicatorOrderNumber varchar(50)
--AS
--BEGIN

DROP TABLE IF EXISTS #App;
DROP TABLE IF EXISTS #MandatoryStates;
DROP TABLE IF EXISTS #KUnitsAPP;
DROP TABLE IF EXISTS #Applicator;
DROP TABLE IF EXISTS #EPUC;
DROP TABLE IF EXISTS #EPCA;
DROP TABLE IF EXISTS #MDSResult;


CREATE TABLE #KUnitsAPP(
	[ID] [int] NOT NULL,
	[SN] [varchar](50) NULL,
	[IsSystemE] [bit] NULL,
	[10SNCreation] [bit] NULL,
	[702SMTSPITest-Pass] [bit] NULL,
	[704SMTAOI-Pass] [bit] NULL,
	[706SMTRFPrograming-Pass] [bit] NULL,
	[708SMTFTCTester-Pass] [bit] NULL,
	[710SMTTraySorter-Pass] [bit] NULL,
	[7000PuckUnitCreation] [bit] NULL,
	[2000102ApplicatorMachineUnitPass] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY];

declare @ApplicatorOrderNumber varchar(50) = 'A40000830'
declare @min int=1;
declare @max int;
declare @RaiseErrorMessage varchar(max)
declare @unitstate int
declare @ColumnName varchar(128)
declare @familyAPP int
declare @familyPUCK int
declare @familyPCA int
declare @UCPUCKstation int
declare @UCSMTstation int
declare @sqlcmd  varchar (max);


create table  #MandatoryStates (id int identity(1,1),UnitStateID int ,StateName varchar(100),ColumnName varchar(120)) ;

insert into #MandatoryStates (UnitStateID) values(10)
insert into #MandatoryStates (UnitStateID) values(702)
insert into #MandatoryStates (UnitStateID) values(704)
insert into #MandatoryStates (UnitStateID) values(706)
insert into #MandatoryStates (UnitStateID) values(708)
insert into #MandatoryStates (UnitStateID) values(710)
insert into #MandatoryStates (UnitStateID) values(7000)
insert into #MandatoryStates (UnitStateID) values(2000102)

-------------------------------------------------------------------------
---- ADDING MANDATORY STATES
-------------------------------------------------------------------------
update #MandatoryStates set StateName= fis.Description, ColumnName= '['+Rtrim(ltrim(str(m.UnitStateID)))+ replace(fis.Description,' ','')+'] '
from #MandatoryStates m 
join ffunitstate fis (nolock) on fis.ID=m.UnitStateID

select @max= max(id) from #MandatoryStates;

while(@min<=@max)
begin
	select 
		@unitstate = UnitStateID,
		@ColumnName = ColumnName 
	FROM #MandatoryStates 
	WHERE ID = @min;
	
	SET @sqlcmd= @sqlcmd+ ' ' + @ColumnName+ ' bit, ';
	SET @min = @min+1;
end

SET @sqlcmd= @sqlcmd+' );'

print @sqlcmd
exec( @sqlcmd)


-------------------------------------------------------------------------
---- GET THE UNIT STATE PER EACH UNIT AND SAVE INTO #APPLICATOR
-------------------------------------------------------------------------
SELECT DISTINCT h.UnitID ,h.UnitStateID ,snb.Value UnitSN ,sn.Value UID
INTO #Applicator
FROM ffHistory h
INNER JOIN #MandatoryStates ms WITH(nolock) ON h.UnitStateID = ms.UnitStateID
INNER JOIN ffSerialNumber sn WITH(nolock) ON h.UnitID = sn.UnitID AND sn.SerialNumberTypeID = 3
INNER JOIN ffSerialNumber snb WITH(nolock) ON h.UnitID = snb.UnitID AND snb.SerialNumberTypeID = 0
WHERE h.UnitID IN 
(   
	--- SELECT THE UNITS INSIDE THE WO ON THE HISTORY
	SELECT DISTINCT h.UnitID 
	FROM ffHistory h WITH(nolock)
	INNER JOIN ffproductionorder po WITH(nolock) ON po.id = h.productionorderid
	WHERE 
		--po.ID = @ApplicatorOrderNumber
		po.productionordernumber = @ApplicatorOrderNumber
--		AND h.UnitID = -2052299443
)

-------------------------------------------------------------------------
---- ADDING IDENTIFIED APPLICATOR UNITS and avoiding scrapped units
-------------------------------------------------------------------------
INSERT INTO #KUnitsAPP (ID ,SN ,IsSystemE)
SELECT DISTINCT a.UnitID ,a.UnitSN ,CASE WHEN SUBSTRING(a.UnitSN,1,2) = 'L2' THEN 1 ELSE 0 END 
FROM #Applicator a
INNER JOIN ffUnit u WITH(nolock) ON a.UnitID = u.ID 
WHERE u.StatusID <> 3

-------------------------------------------------------------------------
---- ADDING STATION FLAGS FOR EACH UNIT
-------------------------------------------------------------------------
SET @min = 1
WHILE(@min <= @max)
BEGIN
	SELECT 
		@unitstate = UnitStateID,
		@ColumnName = ColumnName 
	FROM #MandatoryStates 
	WHERE id = @min;

	set @sqlcmd ='update u set ' + @ColumnName + ' = 1
	from #KUnitsAPP u 
	join #Applicator a on a.unitid = u.id and a.UnitStateID = '+ str(@unitstate) + ''

	exec (@sqlcmd)

	SET @min = @min +1
END


-------------------------------------------------------------------------
---- ASSIGN VALUES FOR EBOM VALIDATIONS
-------------------------------------------------------------------------
select @familyAPP = id from luPartFamily where name ='APP'
select @familyPUCK = id from luPartFamily where name ='PUC'
select @familyPCA  = id from luPartFamily where name ='PCA'
select @UCPUCKstation  = id from ffStationType where Description ='Puck Machine chk'
select @UCSMTstation  = id from ffStationType where Description ='UC_Panel_POC'

-------------------------------------------------------------------------
---- GETTING PUCK TO APPLICATOR EBOM Validation
-------------------------------------------------------------------------
select 
	u.ID,
	p2.PartNumber ApplicatorOrderEBOMPuckPN,
	pf.Name ApplicatorOrderEBOMFamily,
	p3.PartNumber PUCKtoAPPPNToUpgrade,
	pf2.Name  PUCKtoAPPFamilyToUpgrade,
	CASE WHEN p2.PartNumber <> p3.PartNumber THEN 'EBOM issue' ELSE 'N/A' END EBOMPUCValidation 
INTO #EPUC
from #KUnitsAPP app
join ffunit u (nolock) ON app.ID = u.ID AND u.StatusID <> 3
join ffpart p (nolock)on p.id = u.partid and p.partfamilyid = @familyAPP
join ffProductionOrder po (nolock)on po.ID = u.ProductionOrderID
join ffebom e (nolock) on e.productionorderid = po.id
join ffpart p2 (nolock)on p2.ID = e.PartID  and p2.PartFamilyID = @familyPUCK
join ffhistory h (nolock) on h.unitid = u.id
join ffstation st (nolock)  on st.id = h.StationID
join ffstationtype stt (nolock)  on stt.id = st.StationTypeID and stt.id = @UCPUCKstation
join ffpart p3 (nolock) on p3.ID = h.PartID
join luPartFamily pf (nolock) on pf.ID = p2.PartFamilyID
join luPartFamily pf2 (nolock) on pf2.ID = p3.PartFamilyID
WHERE p2.PartNumber <> p3.PartNumber

-------------------------------------------------------------------------
---- GETTING SMT TO PUCK EBOM Validation
-------------------------------------------------------------------------
select 
	u.id,
	p2.PartNumber PuckOrderEBOMPuckPN,
	pf.Name PuckOrderEBOMFamily,
	p3.PartNumber PCAtoPUCPNToUpgrade,
	pf2.Name PCAtoPUCFamilyToUpgrade,
	CASE WHEN p2.PartNumber <> p3.PartNumber THEN 'EBOM issue' ELSE 'N/A' END EBOMPCAValidation 
INTO #EPCA
from #KUnitsAPP app
join ffunit u (nolock) ON app.ID = u.ID AND u.StatusID <> 3
join ffpart p (nolock)on p.id = u.partid and p.partfamilyid = @familyPUCK
join ffProductionOrder po (nolock)on po.id = u.productionorderid
join ffebom e (nolock) on e.productionorderid = po.id
join ffpart p2 (nolock)on p2.ID = e.PartID  and p2.PartFamilyID = @familyPCA
join ffhistory h (nolock) on h.unitid = u.id
join ffstation st (nolock)  on st.id = h.StationID
join ffstationtype stt (nolock)  on stt.id = st.StationTypeID and stt.id = @UCSMTstation
join ffpart p3 (nolock) on p3.ID = h.PartID
join luPartFamily pf (nolock) on pf.ID = p2.PartFamilyID
join luPartFamily pf2 (nolock) on pf2.ID = p3.PartFamilyID
WHERE p2.PartNumber <> p3.PartNumber

-------------------------------------------------------------------------
---- GETTING MDS RESULTA DATA Tray Sorter issue
-------------------------------------------------------------------------
;WITH Unit AS
(
	SELECT Unit.Unit_Id, Unit.SerialNumber, Unit.PartNumber_Id, Unit.Workorder_Id, Unit.ParentUnit_Id, Unit.SampleUnit, Unit.CreateDttm
	FROM p_REP_LIBRE_MDS.dbo.DS_FT_Unit Unit WITH(nolock)
	INNER JOIN #KUnitsAPP t ON Unit.SerialNumber = t.SN 
	where t.[710SMTTraySorter-Pass] IS NULL
	UNION 
	SELECT Unit.Unit_Id, Unit.SerialNumber, Unit.PartNumber_Id, Unit.Workorder_Id, Unit.ParentUnit_Id, Unit.SampleUnit, Unit.CreateDttm
	FROM p_REP_LIBRE_MDS.dbo.DS_FT_Unit Unit WITH(nolock)
	INNER JOIN #KUnitsAPP t ON Unit.SerialNumber = t.SN 
	where t.IsSystemE = 1 and t.[706SMTRFPrograming-Pass] IS NULL	
)
SELECT 
	Unit.SerialNumber,
	SPITest.TestResult SPITestResult,
	AOITest.TestResult AOITestResult,
	CASE WHEN LEFT (Unit.SerialNumber,2) != 'L2' THEN 'N/A' ELSE CAST(RFTest.TestResult AS varchar(1)) END RFTestResult,
	FCTest.TestResult FCTestResult,
	CASE WHEN (tray.trayResult IS NULL) THEN 0 ELSE 1 END TraySorterTest,
	f.FileName SPIFileName,
	AOITest.TestEndDate AOITestEndDate,  ff.FileName AOIFileName,
	CASE WHEN LEFT (Unit.SerialNumber,2) != 'L2' THEN 'N/A' ELSE CONVERT(varchar(20),RFTest.TestEndDate,121) END RFTestEndDate,  
	CASE WHEN LEFT (Unit.SerialNumber,2) != 'L2' THEN 'N/A' ELSE ffff.FileName END RFFileName,
	FCTest.TestEndDate FCTestEndDate,  fff.FileName FCFileName,
	ftray.FileName TraySorterFileName
INTO #MDSResult
FROM Unit 
LEFT JOIN p_REP_LIBRE_MDS.[dbo].[DS_FT_SPITest] SPITest WITH(nolock) on Unit.Unit_Id = SPITest.UNit_Id
LEFT JOIN p_REP_LIBRE_MDS.[dbo].[Log_InFileProcess] f WITH(nolock) ON f.[InFileProcess_Id] = SPITest.InFileProcess_Id
LEFT JOIN p_REP_LIBRE_MDS.[dbo].[DS_FT_AOITest] AOITest WITH(nolock) ON Unit.Unit_Id = AOITest.UNit_Id
LEFT JOIN p_REP_LIBRE_MDS.[dbo].[Log_InFileProcess] ff WITH(nolock) ON ff.[InFileProcess_Id] = AOITest.InFileProcess_Id
LEFT JOIN p_REP_LIBRE_MDS.[dbo].DS_FT_FCTest FCTest WITH(nolock) on Unit.Unit_Id = FCTest.UNit_Id
LEFT JOIN p_REP_LIBRE_MDS.[dbo].[Log_InFileProcess] fff WITH(nolock) ON fff.[InFileProcess_Id] = FCTest.InFileProcess_Id
LEFT JOIN p_REP_LIBRE_MDS.[dbo].[DS_FT_RFTest] RFTest WITH(nolock) ON Unit.Unit_Id = RFTest.UNit_Id
LEFT JOIN p_REP_LIBRE_MDS.[dbo].[Log_InFileProcess] ffff WITH(nolock) ON ffff.[InFileProcess_Id] = RFTest.InFileProcess_Id
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
		FROM p_REP_LIBRE_MDS.[dbo].DS_FT_TraySorter ts WITH(nolock)
		INNER JOIN
		(
			select Unit.Unit_Id, InFileProcess_Id
			from Unit
			INNER JOIN p_REP_LIBRE_MDS.dbo.DS_FT_TraySorter tray WITH(nolock) on tray.Unit_Id=Unit.Unit_Id
		)t ON t.InFileProcess_Id =  ts.InFileProcess_Id
		INNER JOIN p_REP_LIBRE_MDS.[dbo].[DS_FT_SPITest] SPITest WITH(nolock) on ts.Unit_Id = SPITest.UNit_Id
		INNER JOIN p_REP_LIBRE_MDS.[dbo].[DS_FT_AOITest] AOITest WITH(nolock) ON ts.Unit_Id = AOITest.UNit_Id
		INNER JOIN p_REP_LIBRE_MDS.[dbo].DS_FT_FCTest FCTest WITH(nolock) on ts.Unit_Id = FCTest.UNit_Id
		LEFT JOIN p_REP_LIBRE_MDS.[dbo].[DS_FT_RFTest] RFTest WITH(nolock) ON ts.Unit_Id = RFTest.UNit_Id
		GROUP BY t.Unit_Id
	)tray
)tray on tray.Unit_Id = Unit.Unit_Id
	left JOIN p_REP_LIBRE_MDS.[dbo].DS_FT_TraySorter tray2 WITH(nolock) on tray2.Unit_Id=Unit.Unit_Id
	left JOIN p_REP_LIBRE_MDS.[dbo].[Log_InFileProcess] ftray WITH(nolock) ON tray2.[InFileProcess_Id] = ftray.InFileProcess_Id

-------------------------------------------------------------------------
---- GET DATA RELATION
-------------------------------------------------------------------------

;WITH Issues AS
(
SELECT ---- TRAY SORTER ISSUES
	k.ID UnitID 
	,k.SN UnitSN 
	,k.IsSystemE
	,CASE WHEN k.[710SMTTraySorter-Pass] = 1 THEN 'Yes' ELSE 'SMT TraySorter' END [MissingStep]
	,mds.TraySorterFileName FileName
FROM #KUnitsAPP k
INNER JOIN #MDSResult mds WITH(nolock) ON k.SN = mds.SerialNumber
WHERE k.[710SMTTraySorter-Pass] IS NULL
UNION
SELECT ---- MISSING PUCK STEP
	k.ID UnitID 
	,k.SN UnitSN 
	,k.IsSystemE
	,'Puck Unit creation' [MissingStep]
	,'N/A' FileName
FROM #KUnitsAPP k
WHERE k.[7000PuckUnitCreation] IS NULL
UNION
SELECT ---- MISSING PUCK STEP
	k.ID UnitID 
	,k.SN UnitSN 
	,k.IsSystemE
	,'Applicator Unit creation' [MissingStep]
	,'N/A' FileName
FROM #KUnitsAPP k
WHERE k.[2000102ApplicatorMachineUnitPass] IS NULL
UNION
SELECT ---- RF Programming ISSUES
	k.ID UnitID 
	,k.SN UnitSN 
	,k.IsSystemE
	,CASE WHEN k.[710SMTTraySorter-Pass] = 1 THEN 'Yes' ELSE 'SMT RFTest' END [MissingStep]
	,ISNULL(mds.RFFileName,'N/A') FileName
FROM #KUnitsAPP k
INNER JOIN #MDSResult mds WITH(nolock) ON k.SN = mds.SerialNumber
WHERE k.IsSystemE = 1 AND k.[706SMTRFPrograming-Pass] IS NULL
UNION
SELECT ---- SMT TO PUCK ISSUES
	k.ID UnitID 
	,k.SN UnitSN 
	,k.IsSystemE
	,'SMT to Puck EBOM Issue' [MissingStep]
	,'N/A' FileName
FROM #KUnitsAPP k
INNER JOIN #EPCA e ON k.ID = e.ID
WHERE e.EBOMPCAValidation = 'EBOM issue'
UNION
SELECT ---- PUCK TO APPLICATOR ISSUES 
	k.ID UnitID 
	,k.SN UnitSN 
	,k.IsSystemE
	,'Puck to Applicator EBOM Issue' [MissingStep]
	,'N/A' FileName
FROM #KUnitsAPP k
INNER JOIN #EPUC e ON k.ID = e.ID
WHERE e.EBOMPUCValidation = 'EBOM issue'
)
SELECT  --------- FINAL RESULT JUST UNITS WITH ISSUES
	k.MissingStep
	,k.UnitID 
	,k.UnitSN
	,sn.Value UnitUID 
	,IsSystemE 
	,FileName
	,SUBSTRING(ud.reserved_14,1,12) Tray
	,ISNULL(c.SerialNumber,'N/A') CartID
	,po.ProductionOrderNumber WO
	,l.Description WOLine
	,p.PartNumber WOPartNumber
	,k.UnitSN + ' > ' + Filename AS Deliverable
FROM Issues k
INNER JOIN ffUnit u WITH(nolock) ON k.UnitID = u.ID
INNER JOIN ffSerialNumber sn WITH(nolock) ON k.UnitID = sn.UnitID AND sn.SerialNumberTypeID = 3
INNER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
INNER JOIN ffproductionorder po WITH(nolock) on po.ID = u.ProductionOrderID
INNER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
INNER JOIN ffLineOrder lo WITH(nolock) ON po.ID = lo.ProductionOrderID
INNER JOIN ffLine l WITH(nolock) ON lo.LineID = l.ID
LEFT OUTER JOIN udtTray t WITH(nolock) ON u.PanelID = t.UnitID
LEFT OUTER JOIN udtCart c WITH(nolock) ON t.CartID = c.ID
ORDER BY 1,2




-------------------------------------------------------------------------
---- CLEAN TABLES
-------------------------------------------------------------------------
DROP TABLE IF EXISTS #App;
DROP TABLE IF EXISTS #MandatoryStates;
DROP TABLE IF EXISTS #KUnitsAPP;
DROP TABLE IF EXISTS #Applicator;
DROP TABLE IF EXISTS #EPUC;
DROP TABLE IF EXISTS #EPCA;
DROP TABLE IF EXISTS #MDSResult;

--END