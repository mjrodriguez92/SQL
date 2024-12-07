USE P_LIBRE_FF
GO

DROP TABLE #T
DROP TABLE #TT
go

SELECT DISTINCT tus.Description TrayState, tsn.Value Tray, ud.UnitID, sn.Value UnitSN, us.Description UnitState, po.ProductionOrderNumber WO
INTO #T
FROM ffHistory h WITH(nolock)  
INNER JOIN ffSerialNumber tsn WITH(nolock) ON h.UnitID = tsn.UnitID 
INNER JOIN ffUnitState tus WITH(nolock) ON h.UnitStateID = tus.ID
INNER JOIN ffUnitDetail ud WITH(nolock) ON tsn.Value = SUBSTRING(ud.reserved_14,1,12)
INNER JOIN ffUnit u WITH(nolock) ON ud.UnitID = u.ID
INNER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
INNER JOIN ffUnitState us WITH(nolock) ON u.UnitStateID = us.ID
INNER JOIN ffSerialNumber sn WITH(nolock) ON u.ID = sn.UnitID AND sn.SerialNumberTypeID = 0 and sn.Value like '3%'
WHERE tus.Description = 'Container Retain Pass' 
--AND tsn.Value = 'E0093421-L19'
--AND po.ProductionOrderNumber = 'C50000272'
AND us.Description = 'Sterilization Beagle Test Pass'
AND po.CreationTime between '2020-09-17 00:00:00.000' and '2020-10-15 00:00:00.000'

--SELECT DISTINCT TrayState, Tray, UnitState, WO ,UnitID ,UnitSN
--FROM #T

SELECT DISTINCT t.t.WO ,t.Tray --,t.UnitSN 
	,sd.LotCode ,mu.SerialNumber Skid
FROM #T t
INNER JOIN udtSensorSerials ss WITH(nolock) ON t.UnitSN = ss.Serial
INNER JOIN udtSensorData sd WITH(nolock) ON ss.SensorDataID = sd.ID
INNER JOIN ffmaterialunitdetail mud WITH(nolock) ON sd.LotCode =  mud.Reserved_02
INNER JOIN ffMaterialUnit mu WITH(nolock) ON mud.MaterialUnitID = mu.ID and mu.LooperCount =  mud.LooperCount



