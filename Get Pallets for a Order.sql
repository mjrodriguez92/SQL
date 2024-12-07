select p.SerialNumber, count(u.ID) Total
  from ffProductionOrder o 
  join ffunit u on o.ID = u.ProductionOrderID
  join ffunitdetail ud on u.ID = ud.UnitID and u.LooperCount = ud.LooperCount
  left join ffpackage p on ud.OutMostPackageID = p.ID
 where o.ProductionOrderNumber = 'C50000034'
   and u.StatusID <> 3
 group by p.SerialNumber  
 order by p.SerialNumber

-- select top 10 * from ffunitdetail

select p.SerialNumber, Box.SerialNumber BoxSN, count(u.ID) Total
  from ffProductionOrder o 
  join ffunit u on o.ID = u.ProductionOrderID
  join ffunitdetail ud on u.ID = ud.UnitID and u.LooperCount = ud.LooperCount
  left join ffpackage p on ud.OutMostPackageID = p.ID
  left join ffpackage 
  Box on ud.InMostPackageID = Box.ID
 where o.ProductionOrderNumber = 'C50000034'
   and u.StatusID <> 3
   and p.SerialNumber in ('PLT00000000465','PLT00000000466')
 group by p.SerialNumber, Box.SerialNumber  
 order by p.SerialNumber, Box.SerialNumber

 --PLT00000000595  7
 --PLT00000000632  6
 --PLT00000000678  1
