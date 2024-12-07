USE p_REP_LIBRE_FF
GO

select distinct po.ProductionOrderNumber as ContainerWO, po2.ProductionOrderNumber as KTPWO 
from ffunit u (nolock)
left outer join ffSerialNumber sn1 WITH(nolock) on sn1.UnitID = u.id and sn1.SerialNumberTypeID = 0
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
left outer join ffUnitDetail ud2 WITH(nolock) on ud2.UnitID = u2.id

WHERE po.ProductionOrderNumber in ('C5B000570 ',
'C5B000571 ',
'C5B000572 ',
'C5B000575 ',
'C5B000576 ',
'C5B000577')

GROUP BY Po.ProductionOrderNumber, po2.ProductionOrderNumber