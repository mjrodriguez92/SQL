Select ud.reserved_03 TrayPosition, sn.Value UnitSN, po.ID WOID, po.ProductionOrderNumber WorkOrder
from ffUnitDetail ud with(nolock) 
join ffSerialNumber sn on ud.UnitID = sn.UnitID and sn.SerialNumberTypeID = 3
join ffProductionOrder po on ud.ProductionOrderID = po.ID
where ud.reserved_14 like '%S0004011-H19%' and ud.ProductionOrderID = 11178 and ud.reserved_03 = NULL
order by 1 asc
