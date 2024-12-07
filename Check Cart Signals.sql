Select t.s.value('(attributes/attribute/attrno)[1]','varchar(100)') Attribute,	   t.s.value('(attributes/attribute/attval)[1]','varchar(100)') OrderNumber,	   t.s.value('(ref2skid)[1]','varchar(100)') CartSN,	   x.Content.value('(flxint/app/data/rec/source)[1]','varchar(100)') Source,	   x.Content.value('(flxint/app/data/rec/destination)[1]','varchar(100)') Destination,	   t.s.value('(qty)[1]','varchar(100)') Qty,	   x.CreateDt,	   x.Content,	   x.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref,	   case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],	   isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],	   r.Content RespXML, r.CreateDt RespTime  from fbitSignalXML x with(nolock) cross apply x.Content.nodes('/flxint/app/data/rec/stockpoints/stockpoint') t(s)   left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 13 where x.SignalTypeID = 13   and t.s.value('(ref2skid)[1]','varchar(100)') in ('A-27210337') --   and x.Content.value('(flxint/app/data/rec/source)[1]','varchar(100)') <> '768088'--   and x.Content.value('(flxint/app/data/rec/destination)[1]','varchar(100)') = '768078' order by x.CreateDt --Check signal has ACK 
select o.ProductionOrderNumber, c.ID, c.SerialNumber Cart, count(u.ID) Total
  from ffProductionOrder o with (nolock)
  join ffunit u with (nolock) on o.ID = u.ProductionOrderID 
  join ffunit Tray with (nolock) on u.PanelID = Tray.ID
  join udtTray t with (nolock) on Tray.ID = t.UnitID 
  join udtCart c with (nolock) on t.CartID = c.ID
 where --u.StatusID <> 3 and 
 o.ProductionOrderNumber = 'A40001412'
 group by o.ProductionOrderNumber, c.SerialNumber, c.ID
 order by c.SerialNumber
  