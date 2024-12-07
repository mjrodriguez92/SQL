/*

select t.*
  from udttray t with (nolock)
  join ffProductionOrder o with (nolock) on t.ProductionOrderID = o.ID
 where o.ProductionOrderNumber = 'P30000019'
*/

 select o.ProductionOrderNumber, c.SerialNumber, c.CreationTime, count(u.ID) Total
   from ffProductionOrder o with (nolock)
   join udtCart c with (nolock) on o.ID = c.ProductionOrderID
   join udttray t with (nolock) on c.ID = t.CartID 
   join ffunit u with (nolock) on t.UnitID = u.PanelID 
 where o.ProductionOrderNumber = 'P30000019'
 group by o.ProductionOrderNumber, c.SerialNumber, c.CreationTime
 order by c.CreationTime



