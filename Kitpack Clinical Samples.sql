SELECT mud.Reserved_01 as SensorSerial,
	ss.Serial SensorUID,
	mud.Reserved_05 as LotExpiryDate,
	sd.LotCode as SensorLotNumber, 
	KU.CreationTime AS PackAssemblyDate,
	APPUNIT.ChildSerialNumber as ApplicatorUID,
	--,us.Description UnitStatus 
	--,ust.Description UnitState
	--ISNULL(ksn.Value,'N/A') KitPackYellowBox,
	case when isnull(ud.reserved_07, '') = 'Y' then 'Retain'    when isnull(ud.reserved_30, '') = 'Y' then 'Clinical'    when isnull(ud.reserved_31, '') = 'Y' then 'Stability'    else 'ZProduction' end As 'UnitType'
	--,ISNULL(kus.Description,'N/A') UnitStatus 
	,ISNULL(kpo.ProductionOrderNumber,'N/A') KitpackWO 
	,ISNULL(kpbox.SerialNumber,'N/A') KitpackBox 
	,ISNULL(kppallet.SerialNumber,'N/A') KitpackPallet
INTO #T
FROM udtSensorData sd WITH(nolock) 
INNER JOIN udtSensorSerials ss WITH(nolock) ON sd.ID = ss.SensorDataID
INNER JOIN ffSerialNumber sn WITH(nolock) ON ss.Serial = sn.Value
left outer join ffmaterialunitdetail mud on mud.Reserved_02 = sd.LotCode
LEFT OUTER JOIN ffUnit u WITH(nolock) ON sn.UnitID = u.ID
LEFT OUTER JOIN luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
LEFT OUTER JOIN ffUnitState ust WITH(nolock) ON u.UnitStateID = ust.ID
LEFT OUTER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON sn.UnitID = uc.ChildUnitID
LEFT OUTER JOIN ffUnitComponent APPUNIT WITH(NOLOCK) ON APPUNIT.UnitID = UC.UnitID and APPUNIT.ChildSerialNumber like 'E%'
LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID and ku.StatusID <> 3
LEFT OUTER JOIN ffSerialNumber ksn WITH(nolock) ON ku.ID = ksn.UnitID
LEFT OUTER JOIN luUnitStatus kus WITH(nolock) ON ku.StatusID = kus.ID
LEFT OUTER JOIN ffUnitDetail kud WITH(nolock) ON ku.ID = kud.UnitID
LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID
LEFT OUTER JOIN ffPackage kpbox WITH(nolock) ON kud.InmostPackageID = kpbox.ID
LEFT OUTER JOIN ffPackage kppallet WITH(nolock) ON kud.OutmostPackageID = kppallet.ID
WHERE kpo.productionordernumber in 
('KTP003089'
--'KTP000417',	---Requested on 01/18/2021
--'KTP000507',	---Requested on 01/18/2021
--'KTP000508',	---Requested on 01/18/2021
--'KTP000531'	---Requested on 01/18/2021
--'KTP000677',	---Requested on 02/09/2021
--'KTP000678',	---Requested on 02/09/2021
--'KTP000693'		---Requested on 02/09/2021
) and ud.reserved_30 = 'Y'

SELECT * 
FROM #T t

Drop table #T