
select o.ProductionOrderNumber, c.ID, c.SerialNumber Cart, count(u.ID) Total
  from ffProductionOrder o with (nolock)
  join ffunit u with (nolock) on o.ID = u.ProductionOrderID 
  join ffunit Tray with (nolock) on u.PanelID = Tray.ID
  join udtTray t with (nolock) on Tray.ID = t.UnitID 
  join udtCart c with (nolock) on t.CartID = c.ID
 where u.StatusID <> 3
   and o.ProductionOrderNumber = 'P30000022'
 group by o.ProductionOrderNumber, c.SerialNumber, c.ID
 order by c.ID 
  






