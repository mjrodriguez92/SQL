use P_LIBRE_FF
GO
----------------------------------------------------------------------------
----------------MATERIAL TRACEABILITY REPORT DANILO REPORT
----------------------------------------------------------------------------
----------------------------------------------------------------------------
declare @poNumber varchar(10), 
@ContainerPOid int, 
@ContCreationStationID int,
@ContainerUSCreationID int,
@ContainerLineID int, 
@ContainerIntSteriLineID int,
@recordIDCounter int,
@recordNumber int,
@ContainerReleaseSFGStationID int,
@BeagleStationID int


Set @poNumber = 'C50000099'

SELECT @ContainerPOid = ID FROM ffProductionOrder po (nolock) where po.productionordernumber = @poNumber
SELECT @ContCreationStationID = ID FROM ffstation st (nolock) where st.Description = 'Information Flow Confirmation AAL04'
SELECT @ContainerUSCreationID = id FROM ffUnitstate st (nolock) where Description = 'Container Unit Creation Looper'
SELECT @ContainerLineID = ID FROM ffLine (nolock) where [Description] = 'AAL04'
SELECT @ContainerIntSteriLineID = ID FROM ffLine (nolock) where [Description] = 'Container 1-Cart'
SELECT @ContainerReleaseSFGStationID = ID FROM ffstation st (nolock) where st.Description = 'Container Cart Release to SFG 1'
SELECT @BeagleStationID = ID FROM ffstation st (nolock) where st.Description = 'Beagle_L01'


IF OBJECT_ID('tempdb..#WOUnitList') IS NOT NULL  
  DROP TABLE #WOUnitList
  
 CREATE TABLE #WOUnitList
 (  
  unitID      INT
 )  

--select * from #WOUnitList


INSERT INTO #WOUnitList(unitID)
SELECT DISTINCT(h.unitid)
from ffhistory h (nolock)
join ffProductionOrder po (nolock) on po.id = h.productionorderid and h.partid = po.partid
join ffstation st (nolock) on st.id = h.stationid
join ffLineorder LO (nolock) on LO.LineID = st.Lineid and lo.ProductionOrderID = po.ID
join ffunitDetail ud (nolock) on ud.unitid = h.unitid
where h.productionOrderid = @ContainerPOid
and h.stationid = @ContCreationStationID
and h.unitstateid = @ContainerUSCreationID 



IF OBJECT_ID('tempdb..#WOUnitsTray') IS NOT NULL  
  DROP TABLE #WOUnitsTray
  
 CREATE TABLE #WOUnitsTray
 (  
  recordID			int identity(1,1),
  unitID			INT,
  ContainerFile		varchar(50),
  TrayUnitID		INT,
  TraySN			varchar(20),
  TrayLooper		varchar(2),
  unitStateID		int,
  unitStatusID		int,
  ReleaseSFGHistorydt		datetime,
  BeagleHistorydt	datetime
 )  



INSERT INTO #WOUnitsTray(unitID, ContainerFile, TrayUnitID, TraySN, TrayLooper)
SELECT tmp.unitid 'unitID', ud.reserved_13 as 'ContainerFile', 
tSN.unitid AS TrayUnitID,
left(isnull(ud.reserved_14, 'SAMPLEDATA_SAMPLEDATA'), 12) as 'TraySN',
left(right(isnull(ud.reserved_14, 'SAMPLEDATA_SAMPLEDATA'), 2),1) as 'TrayLooper'
FROM #WOUnitList tmp
join ffunitDetail ud (nolock) on ud.unitid = tmp.unitid
left join ffSerialNumber tSN (nolock) on tSN.value = left(isnull(ud.reserved_14, 'SAMPLEDATA_SAMPLEDATA'), 12)


-----------------------------UPDATE unitStateID------------------------
set @recordIDCounter = 1
select @recordNumber = count(1) FROM #WOUnitsTray


WHILE (@recordIDCounter <= @recordNumber)
BEGIN

	UPDATE TMP
	SET tmp.unitStateID = (
							select top 1 h.UnitStateID
							from ffHistory h (nolock)
								join ffStation st (nolock) on st.id = h.stationid
							where h.unitid = tmp.Unitid
							and st.lineid in (@ContainerLineID, @ContainerIntSteriLineID)
							order by h.id desc
						)
	FROM #WOUnitsTray TMP
	where recordID = @recordIDCounter

	PRINT @recordIDCounter

	set @recordIDCounter = @recordIDCounter + 1
END


-------------------------------UPDATE unitStatusID------------------------
set @recordIDCounter = 1
select @recordNumber = count(1) FROM #WOUnitsTray

WHILE (@recordIDCounter <= @recordNumber)
BEGIN
	UPDATE TMP
	SET	tmp.unitStatusID = (
						select top 1 sh.UnitStatusID 
						from ffUnitStatusHistory sh (NOLOCK)
						join ffStation st (NOLOCK) on st.id = sh.stationid
						where sh.unitid = tmp.Unitid 
						and st.lineid in (@ContainerLineID, @ContainerIntSteriLineID)
						order by sh.id desc
						)
	FROM #WOUnitsTray TMP
	where recordID = @recordIDCounter

	PRINT @recordIDCounter

	set @recordIDCounter = @recordIDCounter + 1
END




-----------------------------UPDATE ReleaseSFGHistorydt------------------------
set @recordIDCounter = 1
select @recordNumber = count(1) FROM #WOUnitsTray

WHILE (@recordIDCounter <= @recordNumber)
BEGIN

	UPDATE TMP
	SET tmp.ReleaseSFGHistorydt = (
							select top 1 h.EnterTime
							from ffHistory h (nolock)								
							where h.unitid = tmp.Unitid
							and h.ProductionOrderID = @ContainerPOid
							and h.stationid = @ContainerReleaseSFGStationID
							order by h.id desc
						)
	FROM #WOUnitsTray TMP
	where recordID = @recordIDCounter

	PRINT @recordIDCounter

	set @recordIDCounter = @recordIDCounter + 1
END


-----------------------------UPDATE BeagleHistorydt------------------------
set @recordIDCounter = 1
select @recordNumber = count(1) FROM #WOUnitsTray

WHILE (@recordIDCounter <= @recordNumber)
BEGIN

	UPDATE TMP
	SET tmp.BeagleHistorydt = (
							select top 1 h.EnterTime
							from ffHistory h (nolock)
							where h.unitid = tmp.Unitid
							and h.ProductionOrderID = @ContainerPOid							
							and h.stationid = @BeagleStationID
							order by h.id desc
						)
	FROM #WOUnitsTray TMP
	where recordID = @recordIDCounter

	PRINT @recordIDCounter

	set @recordIDCounter = @recordIDCounter + 1
END


-----------------------------INSERT #TraysList------------------------

IF OBJECT_ID('tempdb..#TraysList') IS NOT NULL  
  DROP TABLE #TraysList
  
 CREATE TABLE #TraysList
 (  
	recordID				int identity(1,1),
	TrayUnitID				INT,
	TrayReleaseSFGHistorydt	datetime,
	cartID					int
 ) 


INSERT INTO #TraysList(TrayUnitID, TrayReleaseSFGHistorydt)
SELECT TrayUnitID, ReleaseSFGHistorydt
FROM #WOUnitsTray tmp
GROUP BY TrayUnitID, ReleaseSFGHistorydt



---------------------------UPDATE cartID------------------------
set @recordIDCounter = 1
select @recordNumber = count(1) FROM #TraysList

WHILE (@recordIDCounter <= @recordNumber)
BEGIN

	UPDATE TMP
	SET cartID = (
							select top 1 ch.CartID
							from udtCartHistory ch (nolock)
							where ch.StationID = @ContainerReleaseSFGStationID
							and ch.ProductionOrderID = @ContainerPOid
							and ch.LastUpdate = tmp.TrayReleaseSFGHistorydt
							order by ch.id desc
						)
	FROM #TraysList TMP
	where recordID = @recordIDCounter

	PRINT @recordIDCounter

	set @recordIDCounter = @recordIDCounter + 1
END




select 
sn.value 'ContainerSN', 
snL.value 'ContainerLidFoilSN', 
ust.Description 'ContainerStatus',
usta.Description 'ContainerState',
@poNumber 'Container Workorder',
isnull(tmp.TraySN, '') 'ContainerTraySN',
isnull(tmp.TrayLooper, '') 'ContainerTrayLooper',
isnull(tmp.ContainerFile, '') 'ContainerTrayFile',
(CASE isnull(tmp.BeagleHistorydt, '') 
	when '' then ''
	else CONVERT(VARCHAR, tmp.BeagleHistorydt, 120)
END) as 'BeagleHistorydt',
(CASE isnull(tmp.BeagleHistorydt, '')
	when '' then ''
	else	CONVERT(VARCHAR(8), tmp.BeagleHistorydt, 112)
END) as 'BeagleTestDay',
isnull(cart.SerialNumber, '') 'ContainerCartSN',
isnull(snK.value, '') 'KitPackSN', 
isnull(ustk.Description, '') 'KitpackStatus',
isnull(usk.Description, '') 'KitpackState',
isnull(pok.productionordernumber, '') 'KitPackWorkOrder', 
isnull(package.SerialNumber, '') as 'KP_ShipperBox',
isnull(pallet.SerialNumber, '')as 'KP_Pallet'
from #WOUnitsTray tmp
join luUnitStatus ust (nolock) on ust.id = tmp.unitStatusID
join ffUnitState usta (nolock) on usta.id = tmp.unitStateID
join ffSerialNumber sn (nolock) on tmp.unitid = sn.unitid and sn.SerialNumberTypeID = 0
join ffSerialNumber snL (nolock) on tmp.unitid = snL.unitid and snL.SerialNumberTypeID = 7
left join #TraysList  Trays with(nolock) on Trays.trayUnitID = tmp.trayUnitID
left join udtCart  cart with(nolock) on cart.ID = Trays.CartID
left join ffUnitComponent  uc with(nolock) on uc.ChildUnitID = sn.UnitID
left join ffSerialNumber snK (nolock) on snk.unitid = uc.unitid and snk.SerialNumberTypeID = 0
left join ffunit uK (nolock) on uK.id = uc.unitid
left join luUnitStatus ustk (nolock) on ustk.id = uk.StatusID
left join ffunitstate usk (nolock) on usk.id = uk.unitstateid
left join ffProductionOrder poK (nolock) on poK.id = uk.productionorderid
left join ffUnitDetail ud (nolock) on ud.UnitID = uk.id
left join ffPackage package (nolock) on package.id = ud.Inmostpackageid
left join ffPackage pallet (nolock) on pallet.id = ud.OutmostPackageID
ORDER BY cart.SerialNumber, tmp.TraySN



