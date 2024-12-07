 select p.SerialNumber, Box.SerialNumber BoxSN, count(u.ID) Total
  from ffProductionOrder o 
  join ffunit u on o.ID = u.ProductionOrderID
  join ffunitdetail ud on u.ID = ud.UnitID and u.LooperCount = ud.LooperCount
  left join ffpackage p on ud.OutMostPackageID = p.ID
  left join ffpackage 
  Box on ud.InMostPackageID = Box.ID
 where o.ProductionOrderNumber = 'KTP003082'
   and u.StatusID <> 3
   and p.SerialNumber in ('PLTK2207000428')
 group by p.SerialNumber, Box.SerialNumber  
 order by p.SerialNumber, Box.SerialNumber