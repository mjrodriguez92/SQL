Select *
from ffUnit u with(nolock)
inner join ffSerialNumber sn WITH(nolock) on sn.UnitID = u.ID --ContainerSN
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
where u.ProductionOrderID = 6883 and po2.ProductionOrderNumber in ('KTP001532') and sn.SerialNumberTypeID = 0