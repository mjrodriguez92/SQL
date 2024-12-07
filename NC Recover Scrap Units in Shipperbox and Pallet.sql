USE P_LIBRE_FF
GO


DROP TABLE #T
GO

-------------------------------------------------------------------------
--- GET Qty of units by Lotcode, Skid and WO with Scrapped data to recover
-------------------------------------------------------------------------

--1. GET ALL THE SCRAPPED UNITS BY WO 
SELECT 'CurrentStatus' CurrentWO, u.ID UnitID, u.ProductionOrderID ,po.ProductionOrderNumber ,u.StatusID ,us.Description UnitStatus ,u.StationID ,st.Description Station ,u.LineID ,l.Description Line ,u.UnitStateID
INTO #T
from ffUnit u WITH(nolock) --Get KitUnits
join ffProductionOrder po  WITH(nolock)  on po.id=u.ProductionOrderID
join ffUnitDetail d WITH(nolock) on d.UnitID = u.ID
join ffPackage p WITH(nolock) on p.ID=d.InmostPackageID--AT least in ShipperBox
join ffstation st WITH(nolock) on u.StationID = st.ID
JOIN ffline l WITH(nolock) on u.LineID = l.ID AND st.LineID = l.ID
join luUnitStatus us WITH(nolock) on u.StatusID = us.ID
where po.ProductionOrderNumber IN ('KTP001103')  
and u.StatusID=3

select * from #T

-- 2. get Qty of units by Lotcode, Skid and WO with Scrapped data to recover
-------------------------------------------------------------------------
SELECT mud.Reserved_02 LotCode 
	,mu.SerialNumber Skid 
	,t.ProductionOrderNumber
	,Count(t.UnitID) QtyUnits
FROM #T t
INNER JOIN ffUnitComponent uc WITH(nolock) ON t.UnitID = uc.UnitID
INNER JOIN ffUnit cu WITH(nolock) ON uc.ChildUnitID = cu.ID AND uc.ChildSerialNumber LIKE '3%'
INNER JOIN ffProductionOrder po WITH(nolock) ON cu.ProductionOrderID = po.ID
LEFT OUTER JOIN udtSensorSerials ss WITH(nolock) ON uc.ChildSerialNumber = ss.Serial 
LEFT OUTER JOIN udtSensorData sd WITH(nolock) ON sd.ID = ss.SensorDataID 
LEFT OUTER JOIN ffmaterialunitdetail mud WITH(nolock) ON sd.LotCode = mud.Reserved_02 AND po.ProductionOrderNumber = mud.Reserved_04
LEFT OUTER JOIN ffmaterialunit mu WITH(nolock) ON mud.MaterialUnitID = mu.ID
GROUP BY mud.Reserved_02 
	,mu.SerialNumber  
	,t.ProductionOrderNumber


--3. SEND THE RESULT DATA BY EMAIL AND REQUEST THE APPROVAL


-- 4. WITH THE APPROVAL THEN WE NEED TO CREATE THE INCIDENT TICKET.

begin tran

DROP TABLE IF EXISTS #UnitsIds
DROP TABLE IF EXISTS #T
DROP TABLE IF EXISTS #TT

declare @NCMR as varchar (50)='INC10820452'
declare @ORDER as varchar (50)='KTP001103'
Declare @EOBSTationID int 
Declare @UnitState int = 8005  --- NOT MOVE

--select u.id into #UnitsIds 
SELECT 'CurrentStatus' CurrentWO, u.ID UnitID, u.ProductionOrderID ,po.ProductionOrderNumber ,u.StatusID ,us.Description UnitStatus ,u.StationID ,st.Description Station ,u.LineID ,l.Description Line
INTO #T
from ffUnit u WITH(nolock) --Get KitUnits
join ffProductionOrder po  WITH(nolock)  on po.id=u.ProductionOrderID
join ffUnitDetail d WITH(nolock) on d.UnitID = u.ID
join ffPackage p WITH(nolock) on p.ID=d.InmostPackageID--AT least in ShipperBox
join ffstation st WITH(nolock) on u.StationID = st.ID
JOIN ffline l WITH(nolock) on u.LineID = l.ID AND st.LineID = l.ID
join luUnitStatus us WITH(nolock) on u.StatusID = us.ID
where po.ProductionOrderNumber = @ORDER  and u.StatusID=3

SELECT StationID ,Station INTO #TT
FROM #T GROUP BY StationID ,Station

SELECT * FROM #T
SELECT * FROM #TT

IF (SELECT COUNT(*) FROM #TT) = 1
BEGIN 

	--- Station Assignation 
	SET @EOBSTationID = (SELECT StationID FROM #TT)

	----------- Amadeus Query
	select u.id into #UnitsIds 
	from ffUnit u with(nolock) --Get KitUnits
	join ffProductionOrder po  with(nolock)  on po.id=u.ProductionOrderID
	join ffUnitDetail d on d.UnitID = u.ID
	join ffPackage p on p.ID=d.InmostPackageID--AT least in ShipperBox
	where po.ProductionOrderNumber =@ORDER and u.StatusID=3

	insert into #UnitsIds--Get App and Cont
	select uc.ChildUnitID from #UnitsIds u with(nolock) 
	join ffUnitComponent uc on uc.UnitID = u.ID


	update u 
	set StatusID = 1 ,UnitStateID=@UnitState ,StationID = @EOBSTationID
	from ffUnit u --Set Status COmpleted State 8005
	join #UnitsIds ui on ui.ID =u.ID

	insert ffUnitStatusHistory --Save Tracebility Status Histpory
	select ID,1,NULL,'Undo Scrap due '+ @NCMR, 1000,@EOBSTationID,GETDATE(),1 FROM   #UnitsIds

	insert ffHistory --Save Tracebility Statate History
	select u.ID,@UnitState,1000,@EOBSTationID,GETDATE(),GETDATE(),u.ProductionOrderID,u.PartID,u.LooperCount,1,0,null FROM   #UnitsIds uds
	join ffUnit u on uds.ID=u.ID

	SELECT *
	from ffUnit u with(nolock) --Get KitUnits
	join ffProductionOrder po  with(nolock)  on po.id=u.ProductionOrderID
	join ffUnitDetail d on d.UnitID = u.ID
	join ffPackage p on p.ID=d.InmostPackageID--AT least in ShipperBox
	where po.ProductionOrderNumber =@ORDER and u.StatusID=3

END 
ELSE 
	SELECT 'We have more of one Station involved'


rollback tran

