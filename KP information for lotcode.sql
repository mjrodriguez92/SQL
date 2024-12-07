----------------------------------------------------------------------------------------------------------------------
--- GET KITPACK INFORMATION BASED ON CONTAINER LOT CODE 
----------------------------------------------------------------------------------------------------------------------
SELECT sd.LotCode, '''' + ss.Serial UnitSN
	,us.Description UnitStatus 
	,u.UnitStateID UnitStateID
	,ust.Description UnitState
	,ud.InmostPackageID 
	,ud.OutmostPackageID 
	,ku.ID KitpackUnitID 
	,ISNULL(ksn.Value,'N/A') KitpackUnitSN 
	,ISNULL(kus.Description,'N/A') KitpackUnitStatus 
	,ISNULL(kpo.ProductionOrderNumber,'N/A') KitpackWO 
	,ISNULL('''' + kpbox.SerialNumber,'N/A') KitpackBox 
	,ISNULL(kppallet.SerialNumber,'N/A') KitpackPallet
FROM udtSensorData sd WITH(nolock) 
INNER JOIN udtSensorSerials ss WITH(nolock) ON sd.ID = ss.SensorDataID
INNER JOIN ffSerialNumber sn WITH(nolock) ON ss.Serial = sn.Value
LEFT OUTER JOIN ffUnit u WITH(nolock) ON sn.UnitID = u.ID
LEFT OUTER JOIN luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
LEFT OUTER JOIN ffUnitState ust WITH(nolock) ON u.UnitStateID = ust.ID
LEFT OUTER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON sn.UnitID = uc.ChildUnitID
LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID
LEFT OUTER JOIN ffSerialNumber ksn WITH(nolock) ON ku.ID = ksn.UnitID
LEFT OUTER JOIN luUnitStatus kus WITH(nolock) ON ku.StatusID = kus.ID
LEFT OUTER JOIN ffUnitDetail kud WITH(nolock) ON ku.ID = kud.UnitID
LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID
LEFT OUTER JOIN ffPackage kpbox WITH(nolock) ON kud.InmostPackageID = kpbox.ID
LEFT OUTER JOIN ffPackage kppallet WITH(nolock) ON kud.OutmostPackageID = kppallet.ID
WHERE sd.LotCode IN (
'1000542117',
'1000540387',
'1000542825',
'1000542126',
'1000550170',
'1000551321',
'1000551779',
'1000553029',
'1000553032',
'1000552772',
'1000553026',
'1000552207',
'1000555005',
'1000554628',
'1000556298',
'1000557589',
'1000558306',
'1000559772',
'1000560240',
'1000560209',
'1000565421',
'1000568367',
'1000563565',
'1000564922',
'1000563592',
'1000568347',
'1000566894',
'1000563528',
'1000564301',
'1000570321',
'1000560229',
'1000575218',
'1000578433',
'1000580090',
'1000582268',
'1000582258',
'1000584055',
'1000568998',
'1000584768',
'1000573040',
'1000582311',
'1000584031',
'1000580022',
'1000584077'
)

