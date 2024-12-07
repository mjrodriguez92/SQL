Select *
from ffProductionOrder po with(nolock) 
where po.ProductionOrderNumber = 'P30001170'

Select distinct u.ID UID, sn.Value Unit, snt.Value Tray
from ffUnit u with(nolock)
inner join ffSerialNumber sn WITH(nolock) on sn.UnitID = u.ID and sn.SerialNumberTypeID = 3
inner join ffSerialNumber sn0 with(nolock) on sn0.UnitID = u.ID --and sn0.SerialNumberTypeID = 0
inner join ffProductionOrder po WITH(nolock) on u.ProductionOrderID = po.ID
inner join ffUnitDetail ud WITH(nolock) on ud.UnitID = u.ID
left outer join udtTray t WITH(nolock) on t.UnitID = u.PanelID
left outer join ffSerialNumber snt WITH(nolock) on t.UnitID = snt.UnitID
left outer join udtCart c WITH(nolock) on c.ID = t.CartID
where u.ProductionOrderID = 7477