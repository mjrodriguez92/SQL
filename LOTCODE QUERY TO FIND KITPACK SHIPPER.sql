SELECT mud.Reserved_02 LotCode ,po.ProductionOrderNumber WO ,sn.Value UnitSN ,us.Description UnitState,ksn.Value,kP.SerialNumber as ShipperBox,kpp.SerialNumber,kpo.ProductionOrderNumber
FROM ffmaterialUnitDetail mud WITH(nolock)
INNER JOIN udtSensorData sd WITH(nolock) ON mud.Reserved_02 = sd.LotCode
INNER JOIN udtSensorSerials ss WITH(nolock) ON sd.ID = ss.SensorDataID
INNER JOIN ffSerialNumber sn WITH(nolock) ON ss.Serial = sn.Value
INNER JOIN ffUnit u WITH(nolock) ON sn.UnitID = u.ID
INNER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID AND mud.Reserved_04 = po.ProductionOrderNumber
INNER JOIN luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.ChildUnitID
LEFT OUTER JOIN ffUnit ku WITH(nolock) ON ku.ID = uc.UnitID
LEFT OUTER JOIN ffSerialNumber ksn WITH(nolock) ON ksn.UnitID = ku.ID
LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON kpo.id = ku.ProductionOrderID
LEFT OUTER JOIN ffUnitDetail kud WITH(nolock) ON kud.UnitID = ku.ID
LEFT OUTER JOIN ffPackage kp WITH(nolock) ON kp.ID = kud.InmostPackageID
LEFT OUTER JOIN ffPackage kpp WITH(nolock) ON kpp.ID = kud.OutmostPackageID
--LEFT OUTER JOIN luUnitStatus kus WITH(nolock) on kus.ID = ku.StatusID
WHERE mud.Reserved_02 = '1000601426' AND MUD.Reserved_04 = 'C5B000112'


--SELECT TOP 10 * FROM ffUnitDetail WITH(NOLOCK)
--SELECT TOP 10 * FROM ffUnitComponent WITH(NOLOCK)

--select * from ffSerialNumber
--where UnitID = '-2119696093'

--select * from ffUnitComponent
--where ChildUnitID = '-2097692631'