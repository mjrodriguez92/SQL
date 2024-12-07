
--Searching Container Units not consumed by Kitpack by ProductionOrderID

Select *
from ffProductionOrder po with(nolock)
WHERE po.productionordernumber in ('C5B000766');

Select *
from ffUnit u with(nolock)
inner join ffSerialNumber sn WITH(nolock) on sn.UnitID = u.ID --ContainerSN
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
where u.ProductionOrderID = 6883 and po2.ProductionOrderNumber IS NULL and sn.SerialNumberTypeID = 0


Select po.ProductionOrderNumber ContainerWO, po2.ProductionOrderNumber KitpackWO, u.ID ContainterUnitID, sn.Value, po.CreationTime, po.LastUpdate, u.PanelID, u.StatusID UnitStatusID
from ffUnit u with(nolock)
inner join ffSerialNumber sn WITH(nolock) on sn.UnitID = u.ID --ContainerSN
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
where u.ProductionOrderID = 6883 and po2.ProductionOrderNumber IS NULL and sn.SerialNumberTypeID = 0