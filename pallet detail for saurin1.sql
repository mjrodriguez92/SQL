DROP TABLE #T
GO
 
DROP TABLE #TT
GO
 
DROP TABLE #TTT
GO
 
--'THRL-PRT23200-750'
--THRL-PRT23200-750
 
SELECT h.UnitID, H.ProductionOrderID ,max(h.ID) HistoryID
INTO #T
FROM ffHistory h WITH(nolock)
INNER JOIN 
(
SELECT h.UnitID, p.ID PartID ,po.ID WOID 
FROM ffHistory h WITH(nolock)  
INNER JOIN ffProductionOrder po WITH(nolock) ON h.ProductionOrderID = po.ID  
INNER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
WHERE p.PartNumber = 'THRL-PRT23200-750'
--AND po.ProductionOrderNumber = 'C50000471'
AND h.EnterTime >= '2020-11-01 00:00:00' and h.EnterTime < '2021-03-23 00:00:00'
) p ON h.UnitID = p.UnitID AND h.PartID = p.PartID AND h.ProductionOrderID = p.WOID
GROUP BY h.UnitID ,h.ProductionOrderID 
 
 
--SELECT * FROM #T
--SELECT * FROM ffSerialNumber WHERE UnitID = -2088308946
 
-- 42867 Units
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
LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON t.ProductionOrderID = po.ID AND po.ActualStartTime >= '2020-11-01 00:00:00' AND po.ActualStartTime < '2021-03-23 00:00:00'
LEFT OUTER JOIN ffSerialNumber sn WITH(nolock) ON t.UnitID = sn.UnitID AND sn.SerialNumberTypeID = 0
LEFT OUTER JOIN ffUnitState us2 WITH(nolock) ON u.UnitStateID = us2.ID 
LEFT OUTER JOIN luUnitStatus ust WITH(nolock) ON u.StatusID = ust.ID
LEFT OUTER JOIN ffPart p WITH(nolock) ON u.PartID = p.ID 
LEFT OUTER JOIN udtTray tr WITH(nolock) ON u.PanelID = tr.UnitID
LEFT OUTER JOIN ffSerialNumber tsn WITH(nolock) ON u.PanelID = tsn.UnitID 
WHERE ud.reserved_07 = 'Y'
 
 


 DROP TABLE #TTT
GO
----------------- MANPREET NEEDS
SELECT 
t.WO ProductionOrderNumber,
ISNULL(t.CurrentTraySN, t.HistTray) TraySN,
t.WOCreationTime,
ISNULL(t.RetainUnit,'N') RetainUnit,
mu.SerialNumber SensorReel,
mud.reserved_02 LotCode,
--COUNT(t.UnitSN) TrayTotal,
pod.Content WOExpDate,
--mud.*
--kpo.ProductionOrderNumber KitpackWO, 
--ku.ID KitpackUnitID, 
--ksn.value Kitpack,
--kus.Description KitpackUnitState,
--kust.Description KitpackUnitStatus,
--kpbox.SerialNumber KitpackBox,
KP2.SerialNumber KitpackPallet,
t.WO,
--t.PartNumber,
t.UnitSN
--t.RetainUnit,
--t.UnitStatus,
--t.UnitStateID,
--t.UnitState,
--ISNULL(t.CurrentTraySN, t.HistTray) TraySN,
--t.RetainCreationTime CreationTime,
--mu.SerialNumber SensorReel,
--mud.reserved_02 LotCode,
--pod.Content WOExpDate
--INTO #TTT
FROM #TT t
LEFT OUTER JOIN udtSensorSerials ss WITH(nolock) ON t.UnitSN = ss.Serial
LEFT OUTER JOIN udtSensorData sd WITH(nolock) ON sd.ID = ss.SensorDataID 
LEFT OUTER JOIN ffMaterialUnitDetail mud WITH(nolock) ON mud.Reserved_02 = sd.LotCode AND mud.Reserved_04 = t.WO
LEFT OUTER JOIN ffMaterialUnit mu WITH(nolock) ON mud.MaterialUnitID = mu.ID
LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON t.WO = po.ProductionOrderNumber
INNER JOIN ffProductionOrderDetail pod WITH(nolock) ON po.ID = pod.ProductionOrderID  AND pod.ProductionOrderDetailDefID = 24
--LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON t.UnitID = uc.ChildUnitID
--LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID 
--LEFT OUTER JOIN ffSerialNumber ksn WITH(nolock) ON ku.ID = ksn.UnitID 
--LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID
--LEFT OUTER JOIN ffUnitState kus WITH(nolock) ON ku.UnitStateID = kus.ID
--LEFT OUTER JOIN luUnitStatus kust WITH(nolock) ON ku.StatusID = kust.ID
--LEFT OUTER JOIN ffUnitDetail kud WITH(nolock) ON ku.ID = kud.UnitID
--LEFT OUTER JOIN ffPackage kpbox WITH(nolock) ON kud.inmostpackageID = kpbox.ID
--LEFT OUTER JOIN ffPackage kppallet WITH(nolock) ON kud.OutmostpackageID = kppallet.ID
INNER JOIN ffSerialNumber WITH(NOLOCK) ON ffSerialNumber.Value = ss.Serial
--INNER JOIN ffUnit WITH(NOLOCK) ON FFUNIT.ID = ffSerialNumber.UnitID
--INNER JOIN ffUnit tray with(nolock) on tray.ID = ffunit.PanelID
--INNER JOIN ffSerialNumber sn WITH(NOLOCK) ON SN.UnitID = tray.ID
INNER JOIN ffUnitDetail WITH(NOLOCK) ON ffUnitDetail.UnitID = ffSerialNumber.UnitID 
left outer join ffUnitComponent with(nolock) on ffUnitComponent.ChildUnitID = ffUnitDetail.UnitID
left outer join ffUnitDetail u2 with(nolock) on u2.UnitID = ffUnitComponent.UnitID
--left outer join ffUnit u with(nolock) on u.ID = u2.UnitID
--left outer join ffUnitState us with(nolock) on us.ID = u.UnitStateID
left outer join ffPackage with(nolock) on ffPackage.ID = u2.InmostPackageID 
left outer join ffPackage kp2 with(nolock) on kp2.ID = u2.OutmostPackageID



--WHERE WO = 'C50000325'
--WHERE t. CurrentTraySN = 'E0123849-M19'
WHERE KP2.SerialNumber IN (
'PLT00000005074',
'PLT00000005083',
'PLT00000005086',
'PLT00000005085'
)
GROUP BY 
t.WO ,
ISNULL(t.CurrentTraySN, t.HistTray) ,
t.WOCreationTime,
ISNULL(t.RetainUnit,'N'),
mu.SerialNumber ,
mud.reserved_02 ,
pod.Content,
--t.UnitSN,
KP2.SerialNumber,
t.UnitSN
 
 
SELECT * 
FROM #TT


SELECT 
       t.WO as WO,
     --  t.PartNumber, donot need it
       '''' + mud.reserved_02 as LotCode,
   t.CurrentTraySN as RetainTrayID,
   t.WOCreationTime,
   COUNT(t.CurrentTraySN) as TrayTotal,
   --t.UnitState as CurrentTrayState,
   --t.UnitState as LastTrayState,
   
       mu.SerialNumber Skid,
       '''' + t.UnitSN UnitSN,
       --t.UnitStatus,
       --t.UnitStateID,
       
       
       --t.HistTray HistoryRetainTraySN,
       ISNULL(t.RetainUnit,'N') RetainUnit,
       pod.Content WOExpDate,
       
       Pallet.SerialNumber as PalletID
FROM #TT t
LEFT OUTER JOIN udtSensorSerials ss WITH(nolock) ON t.UnitSN = ss.Serial
LEFT OUTER JOIN udtSensorData sd WITH(nolock) ON sd.ID = ss.SensorDataID 
LEFT OUTER JOIN ffMaterialUnitDetail mud WITH(nolock) ON mud.Reserved_02 = sd.LotCode AND mud.Reserved_04 = t.WO
LEFT OUTER JOIN ffMaterialUnit mu WITH(nolock) ON mud.MaterialUnitID = mu.ID
LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON t.WO = po.ProductionOrderNumber
INNER JOIN ffProductionOrderDetail pod WITH(nolock) ON po.ID = pod.ProductionOrderID  AND pod.ProductionOrderDetailDefID = 24
inner join ffUnitDetail with(nolock) on T.UnitID = ffUnitDetail.UnitID
inner join ffPackage shipper with(nolock) on shipper.ID = ffUnitDetail.InmostPackageID
inner join ffPackage Pallet with(nolock) on pallet.ID = ffUnitDetail.OutmostPackageID
where Pallet.SerialNumber in ('PLT00000005074',
'PLT00000005083',
'PLT00000005086',
'PLT00000005085')
GROUP BY 
       t.WO ,
       ISNULL(t.CurrentTraySN, t.HistTray) ,
       t.WOCreationTime,
       ISNULL(t.RetainUnit,'N'),
       mu.SerialNumber ,
       mud.reserved_02 ,
       pod.Content,
   --t.CurrentTraySN,
   --t.UnitState,
   Pallet.SerialNumber ,
    t.UnitSN,
	 pod.Content,
	 t.CurrentTraySN
	



--SELECT * FROM #TT
----WHERE WOCreationTime is not NULL
--UNION
--select t.ProductionOrderNumber ,t.TraySN ,ISNULL(t.CreationTime,ut.CreationTime) CreationTime, t.RetainUnit ,t.SensorReel ,t.LotCode ,t.TrayTotal ,t.WOExpDate from #TTT t
--INNER JOIN ffSerialNumber sn WITH(nolock) ON t.TraySN = sn.Value
--INNER JOIN udtTray ut WITH(nolock) ON sn.UnitID = ut.UnitID
--WHERE t.CreationTime is NULL
 
