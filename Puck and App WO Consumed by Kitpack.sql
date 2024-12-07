USE P_LIBRE_FF
GO

DROP TABLE #History 
Drop Table #A

------------------------------
----- GET HISTORY OF FROM KITPACK DATA 
-------------------------------


--DECLARE @WO varchar(20)
--SET @WO = 'K60000473'

Select hh.ProductionOrderID, hh.UnitID, MAX(hh.id) HistoryID
INTO #History
from ffHistory hh with(nolock)
where UnitID IN
(
Select h.UnitID from ffHistory h with(nolock)
where h.ProductionOrderID IN (
Select po.id WOID --po.ProductionOrderNumber
From ffProductionOrder po with(nolock)
join ffpart p with(nolock) on po.PartID = p.ID
join luPartFamily pf with(nolock) on p.PartFamilyID = pf.ID
Where po.ProductionOrderNumber in ('P30001509',
'P30001516',
'P30001517',
'P30001518',
'P30001412',
'P30001397',
'P30001398',
'P30001387',
'P30001391',
'P30001392',
'P30001384',
'P30001385',
'P30001446',
'P30001440',
'P30001456',
'P30001459',
'P30001467',
'P30001479',
'P30001493',
'P30001484',
'P30001486',
'P30001485',
'P30001501',
'P30001504')
) 
)
Group by hh.UnitID, hh.ProductionOrderID


Select * from #History h
join ffSerialNumber sn with(nolock) on h.UnitID = sn.UnitID and sn.SerialNumberTypeID = 3


SELECT h.unitID, 
	MAX(CASE WHEN PartFamily = 'APP' THEN h.ProductionOrderNumber END) ApplicatorWO,
	MAX(CASE WHEN PartFamily = 'APP' THEN h.WOID END) ApplicatorWOID,
	MAX(CASE WHEN PartFamily = 'PUC' THEN h.ProductionOrderNumber END) PuckWO,
	MAX(CASE WHEN PartFamily = 'PUC' THEN h.WOID END) PuckWOID,
	MAX(CASE WHEN PartFamily = 'PCA' THEN h.ProductionOrderNumber END) SMTWO,
	MAX(CASE WHEN PartFamily = 'PCA' THEN h.WOID END) SMTWOID
INTO #A
FROM (
SELECT h.UnitID ,H.HistoryID ,po.ID WOID ,po.ProductionOrderNumber, pf.Name PartFamily, ROW_NUMBER() OVER(PARTITION BY h.UnitID ORDER BY h.HistoryID DESC) AS HOrder
FROM #History h
join ffSerialNumber sn with(nolock) on h.UnitID = sn.UnitID and sn.SerialNumberTypeID = 3
join ffProductionOrder po WITH(nolock) ON h.ProductionOrderID = po.ID
join ffpart p with(nolock) on po.PartID = p.ID
join luPartFamily pf with(nolock) on p.PartFamilyID = pf.ID
) h
GROUP BY h.UnitID 

Select * from #A


SELECT DISTINCT
	-- a.UnitID
	--,u.StatusID
	--,us.Description UnitStatus
	--,
	a.PuckWO
	,ppo.ActualStartTime PuckActualStartTime
	,ppo.ActualFinishTime PuckActualFinishTime
	,a.ApplicatorWO
	,apo.ActualStartTime ApplicatorActualStartTime
	,apo.ActualFinishTime ApplicatorActualFinishTime
	,kpo.ProductionOrderNumber KitpackWO
	,kpo.ActualStartTime KitpackActualStartTime
	,kpo.ActualFinishTime KitpackActualFinishTime
	--,ksn.Value KitpackUnitSN
	--,kud.reserved_06 KitpackUnitExpDate
	--,ku.CreationTime ManufacturingDate
	--,kpo.ProductionOrderNumber KitPO
FROM #A a
join ffUnit u with(nolock) on a.UnitID = u.ID
join luUnitStatus us with(nolock) on u.StatusID = us.ID
join ffProductionOrder ppo with(nolock) on a.PuckWOID = ppo.ID
join ffProductionOrder apo with(nolock) on a.ApplicatorWOID = apo.ID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.ChildUnitID
LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID
LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID
Where kpo.ProductionOrderNumber IS NOT NULL;



--Units not consumed by Kitpack
--SELECT DISTINCT
--	-- a.UnitID
--	--,u.StatusID
--	--,us.Description UnitStatus
--	--,
--	a.PuckWO
--	,ppo.ActualStartTime PuckActualStartTime
--	,ppo.ActualFinishTime PuckActualFinishTime
--	,a.ApplicatorWO
--	,apo.ActualStartTime ApplicatorActualStartTime
--	,apo.ActualFinishTime ApplicatorActualFinishTime
--	,au.ID
--	,kpo.ProductionOrderNumber KitpackWO
--	,kpo.ActualStartTime KitpackActualStartTime
--	,kpo.ActualFinishTime KitpackActualFinishTime
--	--,ksn.Value KitpackUnitSN
--	--,kud.reserved_06 KitpackUnitExpDate
--	--,ku.CreationTime ManufacturingDate
--	--,kpo.ProductionOrderNumber KitPO
--FROM #A a
--join ffUnit u with(nolock) on a.UnitID = u.ID
--join luUnitStatus us with(nolock) on u.StatusID = us.ID
--join ffProductionOrder ppo with(nolock) on a.PuckWOID = ppo.ID
--join ffProductionOrder apo with(nolock) on a.ApplicatorWOID = apo.ID
--LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.ChildUnitID
--LEFT OUTER JOIN ffUnit au WITH(nolock) ON uc.ChildUnitID = au.ID AND SUBSTRING(uc.ChildSerialNumber,1,1) = 'E'
--LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID
--LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID
--Where kpo.ProductionOrderNumber IS NULL;








--join ffUnitDetail kud with(nolock) on ku.ID = kud.UnitID
--join ffProductionOrder kpo with(nolock) on kpo.ID = ku.ProductionOrderID
----LEFT OUTER JOIN ffLineOrder lo WITH(nolock) ON po.ID = lo.ProductionOrderID 
----LEFT OUTER JOIN ffLine l WITH(nolock) ON lo.LineID = l.ID
--LEFT OUTER JOIN ffUnit u WITH(nolock) ON po.ID = u.ProductionOrderID 
--LEFT OUTER JOIN ffSerialNumber sn WITH(nolock) ON u.ID = sn.UnitID
--LEFT OUTER JOIN luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
--LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.UnitID
--LEFT OUTER JOIN ffUnit cu WITH(nolock) ON uc.ChildUnitID = cu.ID AND SUBSTRING(uc.ChildSerialNumber,1,1) = '3'
--LEFT OUTER JOIN ffUnit au WITH(nolock) ON uc.ChildUnitID = au.ID AND SUBSTRING(uc.ChildSerialNumber,1,1) = 'E'
--LEFT OUTER JOIN ffProductionOrder cpo WITH(nolock) ON cu.ProductionOrderID = cpo.ID
--LEFT OUTER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
--LEFT OUTER JOIN ffPackage box WITH(nolock) ON ud.InmostPackageID = box.ID
--LEFT OUTER JOIN ffPackage pallet WITH(nolock) ON ud.OutmostPackageID = pallet.ID
WHERE --SUBSTRING(po.ProductionOrderNumber,1,2) like 'K6'	
	--po.ProductionOrderNumber like 'KTP'
	--and po.ActualFinishTime >= '2020-03-01 00:00:00' and po.ActualFinishTime < '2020-04-01 00:00:00'
--GROUP BY po.ID ,po.ProductionOrderNumber ,po.CreationTime ,po.RequestedStartTime ,po.ActualStartTime ,po.RequestedFinishTime ,po.ActualFinishTime 
--	,l.Description 
--	,us.Description 




po.ID KitPOID ,po.ProductionOrderNumber KitPO --,po.CreationTime ,po.RequestedStartTime ,po.ActualStartTime ,po.RequestedFinishTime ,po.ActualFinishTime 
	,l.Description POLine
	,sn.Value KitpackUnitSN
	,us.Description UnitStatus
	,'''' + box.SerialNumber KitpackBox
	,pallet.SerialNumber KitpackPallet
	,cu.ID CUnitID
	,cpo.ProductionOrderNumber ContainerWO
	,au.ID AUnitID