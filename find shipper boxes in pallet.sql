    select p.SerialNumber, Box.SerialNumber BoxSN, count(u.ID) Total
  from ffProductionOrder o
  join ffunit u on o.ID = u.ProductionOrderID
  join ffunitdetail ud on u.ID = ud.UnitID and u.LooperCount = ud.LooperCount
  left join ffpackage p on ud.OutMostPackageID = p.ID
  left join ffpackage
  Box on ud.InMostPackageID = Box.ID
 where o.ProductionOrderNumber = 'KTP000915'
   and u.StatusID <> 3
   and p.SerialNumber in ('PLTK0900000558',
'PLTK0900000562',
'PLTK0900000564',
'PLTK0900000566',
'PLTK0900000567',
'PLTK0900000569',
'PLTK0900000571',
'PLTK0900000573',
'PLTK0900000575',
'PLTK0900000576',
'PLTK0900000578',
'PLTK0900000580',
'PLTK0900000583',
'PLTK0900000585',
'PLTK0900000587',
'PLTK0900000590',
'PLTK0900000592',
'PLTK0900000594',
'PLTK0900000596',
'PLTK0900000599',
'PLTK0900000602',
'PLTK0900000603',
'PLTK0900000606',
'PLTK0900000610',
'PLTK0900000611',
'PLTK0900000614',
'PLTK0900000616',
'PLTK0900000619',
'PLTK0900000622',
'PLTK0900000624')
 group by p.SerialNumber, Box.SerialNumber
 order by p.SerialNumber, Box.SerialNumber
