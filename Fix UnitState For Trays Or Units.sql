-- Update ffUnit For Trays To Either Rollback/Fix UnitStateID


--select po.ID WorkOrderID
--,po.ProductionOrderNumber WorkOrder
--,l.Location Factory
--,l.Description Line
--,t.id TrayID
--,tsn.UnitID TrayUnitID
--,tsn.Value TraySN
--,ust.ID TrayUnitStateID
--,ust.Description TrayUnitState
--  from udtTray t with(nolock)
--join ffProductionOrder po with(nolock) on t.ProductionOrderID = po.ID
--left outer join ffLineOrder lo with(nolock) on t.ProductionOrderID = lo.ProductionOrderID
--left outer join ffline l with(nolock) on lo.LineID = l.ID
--left outer join ffSerialNumber tsn with(nolock) on t.UnitID = tsn.UnitID and tsn.SerialNumberTypeID = 0
--left outer join ffUnit ut with(nolock) on tsn.UnitID = ut.ID
--left outer join ffUnitState ust with(nolock) on ut.UnitStateID = ust.ID
-- where tsn.value in (
--)


--Begin Tran

--Update ffUnit 
--Set UnitStateID = 
--Where ID in (
--)


--Update udtTray
--Set StackID = NULL
--Where ID in (
--)


--select po.ID WorkOrderID
--,po.ProductionOrderNumber WorkOrder
--,l.Location Factory
--,l.Description Line
--,t.id TrayID
--,tsn.UnitID TrayUnitID
--,tsn.Value TraySN
--,ust.ID TrayUnitStateID
--,ust.Description TrayUnitState
--  from udtTray t with(nolock)
--join ffProductionOrder po with(nolock) on t.ProductionOrderID = po.ID
--left outer join ffLineOrder lo with(nolock) on t.ProductionOrderID = lo.ProductionOrderID
--left outer join ffline l with(nolock) on lo.LineID = l.ID
--left outer join ffSerialNumber tsn with(nolock) on t.UnitID = tsn.UnitID and tsn.SerialNumberTypeID = 0
--left outer join ffUnit ut with(nolock) on tsn.UnitID = ut.ID
--left outer join ffUnitState ust with(nolock) on ut.UnitStateID = ust.ID
-- where tsn.value in (
--)

--Rollback Tran



--select po.ID WorkOrderID
--,po.ProductionOrderNumber WorkOrder
--,l.Location Factory
--,l.Description Line
--,t.id TrayID
--,tsn.UnitID TrayUnitID
--,tsn.Value TraySN
--,ust.ID TrayUnitStateID
--,ust.Description TrayUnitState
--  from udtTray t with(nolock)
--join ffProductionOrder po with(nolock) on t.ProductionOrderID = po.ID
--left outer join ffLineOrder lo with(nolock) on t.ProductionOrderID = lo.ProductionOrderID
--left outer join ffline l with(nolock) on lo.LineID = l.ID
--left outer join ffSerialNumber tsn with(nolock) on t.UnitID = tsn.UnitID and tsn.SerialNumberTypeID = 0
--left outer join ffUnit ut with(nolock) on tsn.UnitID = ut.ID
--left outer join ffUnitState ust with(nolock) on ut.UnitStateID = ust.ID
-- where tsn.value in (
--)






-- Update ffUnit For Units To Rollback/Fix UnitStateID



--Select po.ID WorkOrderID
--,po.ProductionOrderNumber WorkOrder
--,l.Location Factory
--,l.Description Line
--,usn.UnitID UnitID
--,usn.Value UnitSN
--,usn.SerialNumberTypeID
--,us.ID UnitStateID
--,us.Description UnitState
--From ffUnit u with(nolock)
--join ffProductionOrder po with(nolock) on u.ProductionOrderID = po.ID
--left outer join ffLineOrder lo with(nolock) on u.ProductionOrderID = lo.ProductionOrderID
--left outer join ffline l with(nolock) on lo.LineID = l.ID
--left outer join ffSerialNumber usn with(nolock) on u.ID = usn.UnitID and usn.SerialNumberTypeID = 3
--left outer join ffUnitState us with(nolock) on u.UnitStateID = us.ID
--where usn.Value in (
--)

--Begin Tran


--Update ffUnit
--Set UnitStateID = 
--Where ID in (
--)



--Select po.ID WorkOrderID
--,po.ProductionOrderNumber WorkOrder
--,l.Location Factory
--,l.Description Line
--,usn.UnitID UnitID
--,usn.Value UnitSN
--,usn.SerialNumberTypeID
--,us.ID UnitStateID
--,us.Description UnitState
--From ffUnit u with(nolock)
--join ffProductionOrder po with(nolock) on u.ProductionOrderID = po.ID
--left outer join ffLineOrder lo with(nolock) on u.ProductionOrderID = lo.ProductionOrderID
--left outer join ffline l with(nolock) on lo.LineID = l.ID
--left outer join ffSerialNumber usn with(nolock) on u.ID = usn.UnitID and usn.SerialNumberTypeID = 3
--left outer join ffUnitState us with(nolock) on u.UnitStateID = us.ID
--where usn.Value in (
--)

--Rollback Tran


--Select po.ID WorkOrderID
--,po.ProductionOrderNumber WorkOrder
--,l.Location Factory
--,l.Description Line
--,usn.UnitID UnitID
--,usn.Value UnitSN
--,usn.SerialNumberTypeID
--,us.ID UnitStateID
--,us.Description UnitState
--From ffUnit u with(nolock)
--join ffProductionOrder po with(nolock) on u.ProductionOrderID = po.ID
--left outer join ffLineOrder lo with(nolock) on u.ProductionOrderID = lo.ProductionOrderID
--left outer join ffline l with(nolock) on lo.LineID = l.ID
--left outer join ffSerialNumber usn with(nolock) on u.ID = usn.UnitID and usn.SerialNumberTypeID = 3
--left outer join ffUnitState us with(nolock) on u.UnitStateID = us.ID
--where usn.Value in (
--)