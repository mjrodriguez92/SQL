
SELECT 
ffMaterialUnitDetail.Reserved_02 AS LotCode,
ffMaterialUnitDetail.Reserved_01 as Skid,
ffSerialNumber.Value as UnitSN,
cus.Description as ConUnitSate,
clus.Description as CONUnitStatus,
ffUnitDetail.reserved_14 as TraySN,
ffMaterialUnitDetail.Reserved_04 as ContainerProductionOrder,
l.Description as [ConLine],
ffUnit.CreationTime,
ksn.Value as KPSN,
LUS.Description AS KPUnitStatus,
us.Description as KPUnitState,
ffPackage.SerialNumber as ShipperBox,
kp2.SerialNumber as PalletSN,
kpo.ProductionOrderNumber as KPPO,
kl.Description as KPLine,
ffMaterialUnitDetail.LooperCount,
ffUnitDetail.reserved_07 AS RetainUnit,
ffUnitDetail.reserved_30 as ClinicalSample,
ffUnitDetail.reserved_31 as StabilitySampleCompleted
FROM ffMaterialUnitDetail WITH(NOLOCK)
INNER JOIN udtSensorData WITH(NOLOCK) ON udtSensorData.LotCode = ffMaterialUnitDetail.Reserved_02
INNER JOIN udtSensorSerials WITH(NOLOCK) ON udtSensorSerials.SensorDataID = udtSensorData.ID
INNER JOIN ffSerialNumber WITH(NOLOCK) ON ffSerialNumber.Value = udtSensorSerials.Serial
INNER JOIN ffUnit WITH(NOLOCK) ON FFUNIT.ID = ffSerialNumber.UnitID
left outer join ffUnitState cus with(nolock) on cus.ID = ffUnit.UnitStateID
left outer join luUnitStatus clus with(nolock) on clus.ID = ffUnit.StatusID
inner join ffLineOrder lo with(nolock) on lo.Description = ffMaterialUnitDetail.Reserved_04
inner join ffLine l with(nolock) on l.ID = lo.LineID
--INNER JOIN ffUnit tray with(nolock) on tray.ID = ffunit.PanelID
--INNER JOIN ffSerialNumber sn WITH(NOLOCK) ON SN.UnitID = tray.ID
INNER JOIN ffUnitDetail WITH(NOLOCK) ON ffUnitDetail.UnitID = ffSerialNumber.UnitID 
left outer join ffUnitComponent with(nolock) on ffUnitComponent.ChildUnitID = ffUnitDetail.UnitID
left outer join ffUnitDetail u2 with(nolock) on u2.UnitID = ffUnitComponent.UnitID
left outer join ffProductionOrder kpo with(nolock) on kpo.ID = u2.ProductionOrderID
left outer join ffLineOrder klo with(nolock) on klo.ProductionOrderID = kpo.ID
left outer join ffLine kl with(nolock) on kl.ID = klo.LineID
left outer join ffUnit u with(nolock) on u.ID = u2.UnitID
left outer join ffSerialNumber ksn with(nolock) on ksn.UnitID = u.ID
left outer join ffUnitState us with(nolock) on us.ID = u.UnitStateID
left outer join luUnitStatus lus with(nolock) on lus.ID = u.StatusID
left outer join ffStation s with(nolock) on s.ID = u.StationID
left outer join ffPackage with(nolock) on ffPackage.ID = u2.InmostPackageID 
left outer join ffPackage kp2 with(nolock) on kp2.ID = u2.OutmostPackageID
WHERE ffMaterialUnitDetail.Reserved_04 in ('C5B001606','C5B001627','C5B001626','C5B001604',
'C5B001589',
'C5B001597',
'C5B001609',
'C5B001607',
'C5B001614',
'C5B001618',
'C5B001615',
'C5B001621','C5B001580',
'C5B001579',
'C5B001603',
'C5B001612',
'C5B001613',
'C5B001616',
'C5B001592',
'C5B001593',
'C5B001608','C5B001622',
'C5B001620',
'C5B001601',
'C5B001599',
'C5B001590',
'C5B001594',
'C5B001575',
'C5B001571',
'C5B001588') AND ffMaterialUnitDetail.Reserved_13 is not NULL
Order by ffunit.CreationTime ASC


