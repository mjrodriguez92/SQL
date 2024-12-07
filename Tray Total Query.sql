use p_REP_LIBRE_FF
GO

DROP TABLE #T
GO

DROP TABLE #TT
GO

DROP TABLE #TTT
GO

--'THRL-PRT23200-750'
--THRL-PRT23200-750

DECLARE @DateStart varchar(50)
DECLARE @DateEnd varchar(50)
DECLARE @PN varchar(200)

SET @PN = 'THRL-PRT23200-750'
SET @DateStart = '2020-04-24 00:00:00'
SET @DateEnd = '2020-08-01 23:59:00'



---- GETTING HIST DATA
SELECT h.UnitID, H.ProductionOrderID ,max(h.ID) HistoryID
INTO #T
	FROM ffHistory h WITH(nolock)
	INNER JOIN 
	(
			SELECT h.UnitID, p.ID PartID ,po.ID WOID 
			FROM ffHistory h WITH(nolock)  
			INNER JOIN ffProductionOrder po WITH(nolock) ON h.ProductionOrderID = po.ID  
			INNER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
			WHERE p.PartNumber = @PN
				AND h.EnterTime >= @DateStart and h.EnterTime < @DateEnd
	) p ON h.UnitID = p.UnitID AND h.PartID = p.PartID AND h.ProductionOrderID = p.WOID
GROUP BY h.UnitID ,h.ProductionOrderID 


SELECT 
	po.ProductionOrderNumber WO, 
	p.PartNumber, 
	u.ID UnitID, sn.Value UnitSN, 
	ud.reserved_07 RetainUnit,
	ust.Description UnitStatus,  
	u.UnitStateID ,us2.Description UnitState,
	tsn.value CurrentTraySN,
	ISNULL(tr.RetainUnit,'N') Retain,
	--tr.CreationTime RetainCreationTime,
	po.ActualStartTime WOCreationTime,
	SUBSTRING(ud.reserved_14,1,12) HistTray,
	po.ID
INTO #TT
FROM #T t
LEFT OUTER JOIN ffUnit u WITH(nolock) ON t.UnitID = u.ID
LEFT OUTER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON t.ProductionOrderID = po.ID AND po.ActualStartTime >= @DateStart AND po.ActualStartTime < @DateEnd
LEFT OUTER JOIN ffSerialNumber sn WITH(nolock) ON t.UnitID = sn.UnitID AND sn.SerialNumberTypeID = 0
LEFT OUTER JOIN ffUnitState us2 WITH(nolock) ON u.UnitStateID = us2.ID 
LEFT OUTER JOIN luUnitStatus ust WITH(nolock) ON u.StatusID = ust.ID
LEFT OUTER JOIN ffPart p WITH(nolock) ON u.PartID = p.ID 
LEFT OUTER JOIN udtTray tr WITH(nolock) ON u.PanelID = tr.UnitID
LEFT OUTER JOIN ffSerialNumber tsn WITH(nolock) ON u.PanelID = tsn.UnitID 
--WHERE ud.reserved_07 = 'Y'


----------------- MANPREET NEEDS
SELECT 
	t.WO ProductionOrderNumber,
	ISNULL(t.CurrentTraySN, t.HistTray) TraySN,
	t.WOCreationTime,
	ISNULL(t.RetainUnit,'N') RetainUnit,
	--mu.SerialNumber SensorReel,
	--mud.reserved_02 LotCode,
	COUNT(t.UnitSN) TrayTotal
	--pod.Content WOExpDate
	--mud.*
	--kpo.ProductionOrderNumber KitpackWO, 
	--ku.ID KitpackUnitID, 
	--ksn.value Kitpack,
	--kus.Description KitpackUnitState,
	--kust.Description KitpackUnitStatus,
	--kpbox.SerialNumber KitpackBox,
	--kppallet.SerialNumber KitpackPallet
	--t.WO,
	--t.PartNumber,
	--t.UnitSN,
	--t.RetainUnit,
	--t.UnitStatus,
	--t.UnitStateID,
	--t.UnitState,
	--ISNULL(t.CurrentTraySN, t.HistTray) TraySN,
	--t.RetainCreationTime CreationTime,
	--mu.SerialNumber SensorReel,
	--mud.reserved_02 LotCode,
	--pod.Content WOExpDate

FROM #TT t
--LEFT OUTER JOIN udtSensorSerials ss WITH(nolock) ON t.UnitSN = ss.Serial
--LEFT OUTER JOIN udtSensorData sd WITH(nolock) ON sd.ID = ss.SensorDataID 
--LEFT OUTER JOIN ffMaterialUnitDetail mud WITH(nolock) ON mud.Reserved_02 = sd.LotCode AND mud.Reserved_04 = t.WO
--LEFT OUTER JOIN ffMaterialUnit mu WITH(nolock) ON mud.MaterialUnitID = mu.ID
--LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON t.WO = po.ProductionOrderNumber
--INNER JOIN ffProductionOrderDetail pod WITH(nolock) ON po.ID = pod.ProductionOrderID  AND pod.ProductionOrderDetailDefID = 24
--LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON t.UnitID = uc.ChildUnitID
--LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID 
--LEFT OUTER JOIN ffSerialNumber ksn WITH(nolock) ON ku.ID = ksn.UnitID 
--LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID
--LEFT OUTER JOIN ffUnitState kus WITH(nolock) ON ku.UnitStateID = kus.ID
--LEFT OUTER JOIN luUnitStatus kust WITH(nolock) ON ku.StatusID = kust.ID
--LEFT OUTER JOIN ffUnitDetail kud WITH(nolock) ON ku.ID = kud.UnitID
--LEFT OUTER JOIN ffPackage kpbox WITH(nolock) ON kud.inmostpackageID = kpbox.ID
--LEFT OUTER JOIN ffPackage kppallet WITH(nolock) ON kud.OutmostpackageID = kppallet.ID
--WHERE WO = 'C50000325'
--WHERE t. CurrentTraySN = 'E0123849-M19'
GROUP BY 
	t.WO ,
	ISNULL(t.CurrentTraySN, t.HistTray) ,
	t.WOCreationTime,
	ISNULL(t.RetainUnit,'N')
	--mu.SerialNumber ,
	--mud.reserved_02 ,
	--pod.Content 


----------------SAURIN DETAIL
--SELECT 
--	t.WO ProductionOrderNumber,
--	t.PartNumber,
--	'''' + mud.reserved_02 LotCode,
--	mu.SerialNumber Skid,
--	'''' + t.UnitSN UnitSN,
--	t.UnitStatus,
--	t.UnitStateID,
--	t.UnitState,
--	t.CurrentTraySN CurrentRetainTraySN,
--	t.HistTray HistoryRetainTraySN,
--	ISNULL(t.RetainUnit,'N') RetainUnit,
--	pod.Content WOExpDate,
--	t.WOCreationTime
--FROM #TT t
--LEFT OUTER JOIN udtSensorSerials ss WITH(nolock) ON t.UnitSN = ss.Serial
--LEFT OUTER JOIN udtSensorData sd WITH(nolock) ON sd.ID = ss.SensorDataID 
--LEFT OUTER JOIN ffMaterialUnitDetail mud WITH(nolock) ON mud.Reserved_02 = sd.LotCode AND mud.Reserved_04 = t.WO
--LEFT OUTER JOIN ffMaterialUnit mu WITH(nolock) ON mud.MaterialUnitID = mu.ID
--LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON t.WO = po.ProductionOrderNumber
--INNER JOIN ffProductionOrderDetail pod WITH(nolock) ON po.ID = pod.ProductionOrderID  AND pod.ProductionOrderDetailDefID = 24
