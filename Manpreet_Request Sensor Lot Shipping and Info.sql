SELECT distinct sd.LotCode,po.ProductionOrderNumber WO, kpo.ProductionOrderNumber,kpp.SerialNumber as shipperbox, ust.Description as GoodORBad
--kpo.ProductionOrderNumber
--us3.Description as ContainerState,
--h.UnitStateID as ContainerUnitStateID,
FROM ffmaterialUnitDetail mud WITH(nolock)
full JOIN udtSensorData sd WITH(nolock) ON mud.Reserved_02 = sd.LotCode
full JOIN udtSensorSerials ss WITH(nolock) ON sd.ID = ss.SensorDataID
full JOIN ffSerialNumber sn WITH(nolock) ON ss.Serial = sn.Value
full JOIN ffUnit u WITH(nolock) ON sn.UnitID = u.ID
full JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID AND mud.Reserved_04 = po.ProductionOrderNumber
full join luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
full JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.ChildUnitID
full JOIN ffUnit ku WITH(nolock) ON ku.ID = uc.UnitID
full JOIN ffSerialNumber ksn WITH(nolock) ON ksn.UnitID = ku.ID
--full JOIN ffProductionOrder kpo WITH(nolock) ON kpo.id = ku.ProductionOrderID
full JOIN ffUnitDetail kud WITH(nolock) ON kud.UnitID = ku.ID
full JOIN  ffPackage ip2 on ip2.id =kud.InmostPackageID
full JOIN ffPackage kp WITH(nolock) ON kp.ID = kud.InmostPackageID
full join ffpart p WITH(nolock) on p.ID = u.PartID
inner JOIN ffPackage kpp WITH(nolock) ON kpp.ID = kud.InmostPackageID
FULL JOIN ffPackage pa WITH(nolock) on pa.CurrPartID =p.ID
inner JOIN ffProductionOrder kpo with(nolock) on ku.ProductionOrderID = kpo.ID
full join luunitstatus ust with(nolock) on ust.ID = u.StatusID --SHIPPER BOX OR Unit OR PALLET
full join ffUnitState uss with(nolock)on us.ID = u.UnitStateID
full join ffHistory h on h.UnitID = u.ID
full join ffUnitState us3 on us3.ID = h.UnitStateID
--LEFT OUTER JOIN luUnitStatus kus WITH(nolock) on kus.ID = ku.StatusID
WHERE po.ProductionOrderNumber in ('C5B000083',
'C5B000120',
'C5B000126',
'C5B000128',
'C5B000133',
'C5B000144',
'C5B000147',
'C5B000164',
'C5B000169') 
ORDER BY po.ProductionOrderNumber



select *
from ffProductionOrderDetail