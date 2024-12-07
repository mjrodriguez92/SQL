--USE p_REP_LIBRE_FF
--GO

-- Searching Container units by WO ID. WO C5B000766 units that has not been used for Kitpack W0

Select *
from ffUnit u with(nolock)
inner join ffSerialNumber sn WITH(nolock) on sn.UnitID = u.ID --ContainerSN
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
where u.ProductionOrderID = 6883 and po2.ProductionOrderNumber IS NULL and sn.SerialNumberTypeID = 0

-- More information included between Kitpack and Container including Container Unit SN's

Select *
from ffUnit u with(nolock)
inner join ffSerialNumber sn WITH(nolock) on sn.UnitID = u.ID --ContainerSN
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
where u.ProductionOrderID = 6883 and po2.ProductionOrderNumber in ('KTP001532') and sn.SerialNumberTypeID = 0

-- 1. Search Kitpack WO's by Container WO. Included ActualFiniahTime to reflect KTP WO's that are still running.

select distinct po.ProductionOrderNumber as ContainerWO, po2.ProductionOrderNumber as KTPWO, po2.ActualFinishTime KTPFinishTime 
from ffunit u with(nolock)
left outer join ffSerialNumber sn1 WITH(nolock) on sn1.UnitID = u.id and sn1.SerialNumberTypeID = 0
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
left outer join ffUnitDetail ud2 WITH(nolock) on ud2.UnitID = u2.id
WHERE po.ProductionOrderNumber in ('C5B000245')
GROUP BY Po.ProductionOrderNumber, po2.ProductionOrderNumber, po2.ActualFinishTime
ORDER BY po2.ActualFinishTime DESC

-- 2. Search Kitpack WO History. Can include Container and Applicator WO's. Drop in temp table.

--DECLARE @WO varchar(20)
--SET @WO = 'KTP001521'
DECLARE @WO varchar(20)
SET @WO = 'KTP001532'
--DECLARE @WO varchar(20)
--SET @WO = 'KTP001541'

SELECT  
	po.ID KitPOID
	,po.ProductionOrderNumber KitPO 
	,po.CreationTime KitCreationTime 
	,po.RequestedStartTime KitRequestedStartTime 
	,po.ActualStartTime KitActualStartTime 
	,po.RequestedFinishTime KitRequestedFinishTime 
	,po.ActualFinishTime KitActualFinishTime
	,l.Description POLine
	,sn.Value KitpackUnitSN
	,us.Description UnitStatus
	,'''' + box.SerialNumber KitpackBox
	,pallet.SerialNumber KitpackPallet
	,cu.ID CUnitID
	,cpo.ProductionOrderNumber ContainerWO
	--,au.ID AUnitID
INTO #T
FROM ffProductionOrder po WITH(nolock) 
LEFT OUTER JOIN ffLineOrder lo WITH(nolock) ON po.ID = lo.ProductionOrderID 
LEFT OUTER JOIN ffLine l WITH(nolock) ON lo.LineID = l.ID
LEFT OUTER JOIN ffUnit u WITH(nolock) ON po.ID = u.ProductionOrderID 
LEFT OUTER JOIN ffSerialNumber sn WITH(nolock) ON u.ID = sn.UnitID
LEFT OUTER JOIN luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.UnitID
LEFT OUTER JOIN ffUnit cu WITH(nolock) ON uc.ChildUnitID = cu.ID AND SUBSTRING(uc.ChildSerialNumber,1,1) = '3'
LEFT OUTER JOIN ffUnit au WITH(nolock) ON uc.ChildUnitID = au.ID AND SUBSTRING(uc.ChildSerialNumber,1,1) = 'E'
LEFT OUTER JOIN ffProductionOrder cpo WITH(nolock) ON cu.ProductionOrderID = cpo.ID
LEFT OUTER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
LEFT OUTER JOIN ffPackage box WITH(nolock) ON ud.InmostPackageID = box.ID
LEFT OUTER JOIN ffPackage pallet WITH(nolock) ON ud.OutmostPackageID = pallet.ID
WHERE --SUBSTRING(po.ProductionOrderNumber,1,2) like 'K6'	
	po.ProductionOrderNumber = @WO
	--and po.ActualFinishTime >= '2020-03-01 00:00:00' and po.ActualFinishTime < '2020-04-01 00:00:00'
--GROUP BY po.ID ,po.ProductionOrderNumber ,po.CreationTime ,po.RequestedStartTime ,po.ActualStartTime ,po.RequestedFinishTime ,po.ActualFinishTime 
--	,l.Description 
--	,us.Description


-- 3. Search WO history from temp table #T

SELECT t.KitPO KitpackWO
	, t.ContainerWO ContainerWO
	,t.POLine KitPackLine
	, t.KitpackUnitSN KitUnitSN
	, t.UnitStatus KitUnitStatus
	, t.KitpackBox KitBox
	,t.KitpackPallet Pallet
	,t.KitCreationTime CreationTime
	,t.KitRequestedStartTime RequestedStartTime
	,t.KitActualStartTime ActualStartTime
	,t.KitRequestedFinishTime RequestedFinishTime
	,t.KitActualFinishTime ActualFinishTime
--	--,t.AUnitID
--	--,a.ApplicatorWO
--	--,a.PuckWO
--	--,a.SMTWO

FROM (
SELECT t.KitpackUnitSN
	, t.UnitStatus
	, t.KitpackBox 
	,t.KitpackPallet 
	,t.KitPO
	,t.KitCreationTime 
	,t.KitRequestedStartTime 
	,t.KitActualStartTime 
	,t.KitRequestedFinishTime 
	,t.KitActualFinishTime
	,t.POLine
	,MAX(ContainerWO) ContainerWO
	--,MAX(AUnitID) AUnitID
FROM #T t
WHERE t.ContainerWO in ('C5B000766')
GROUP BY t.KitpackUnitSN
	, t.UnitStatus
	, t.KitpackBox 
	,t.KitpackPallet 
	,t.KitPO
	,t.POLine
	,t.KitCreationTime 
	,t.KitRequestedStartTime 
	,t.KitActualStartTime
	,t.KitRequestedFinishTime
	,t.KitActualFinishTime ) t
--LEFT OUTER JOIN #A a on t.AUnitID = a.AUnitID



DROP TABLE #T