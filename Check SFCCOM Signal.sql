
/* Check order signal status */

declare @OrderNumber varchar(100)
set @OrderNumber = 'P30000013'

select x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   t.s.value('(orno)[1]','varchar(100)') OrderNumber, 
	   t.s.value('(item)[1]','varchar(100)') Item, 
	   t.s.value('(qty_deliver)[1]','int') Qty, 
	   t.s.value('(qty_reject)[1]','int') QtyRejected, 
	   t.s.value('(close)[1]','int') CloseFlag, 
	   case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],
	   isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],
	   r.Content RespXML, r.CreateDt RespTime,
	   x.Content, x.CreateDt 
  from fbitSignalXML x with (nolock) cross apply x.Content.nodes('/flxint/app/data/rec') t(s)
  left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 12
 where x.SignalTypeID = 12
   and t.s.value('(orno)[1]','varchar(100)') = @OrderNumber
 order by x.Content.value('(flxint/app/sigref)[1]','varchar(100)')

/*
select *
  from ffProductionOrder o
 where o.ProductionOrderNumber in ('P30000005','P30000012','P30000013','P30000014','EOQ000021','C50000018','C50000028')
*/
 
