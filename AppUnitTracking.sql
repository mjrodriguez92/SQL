select sn3.Value UID,sn.Value UNIT,us.Description UnitStatus,s.Description Station,sn2.Value TraySN,c.SerialNumber CartSN,PO.ProductionOrderNumber from ffSerialNumber sN with(nolock) 
inner join ffSerialNumber sn3 with(nolock) on sn3.UnitID = sn.UnitID and sn3.SerialNumberTypeID = 3
inner join ffUnit u with(nolock) on u.ID = sn.UnitID
inner join ffStation s with(nolock) on s.ID = u.StationID
inner join luUnitStatus us with(nolock) on us.ID = u.StatusID
inner join ffProductionOrder po with(nolock) on po.ID = u.ProductionOrderID
left join ffUnit u2 with(nolock) on u2.ID = u.PanelID
left join ffSerialNumber sn2 with(nolock) on u2.ID = sn2.UnitID
left join udtTray t with(nolock) on t.UnitID = sn2.UnitID
left join udtCart c with(nolock) on c.ID = t.CartID
where sn.Value in (
'E007A00007068193',
'E007A00007068192'
) 

select top 100 * from udtcart
select top 100 * from udtTray


select * from ffSerialNumber
where UnitID = '-2053598292'