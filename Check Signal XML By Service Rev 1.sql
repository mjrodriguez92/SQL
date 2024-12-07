
--Check Recent Signal
 select top 2   x.UpdateDt [Signal Update Time], x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   x.StatusID, x.Content [XML], 
     --t.s.value('(orno)[1]','varchar(100)') OrderNumber,   
     --t.s.value('(item)[1]','varchar(100)') Item,   
     --t.s.value('(qty_deliver)[1]','int') Qty,   
     --t.s.value('(qty_reject)[1]','int') QtyRejected,   
     --t.s.value('(close)[1]','int') CloseFlag,   
     case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],  
     isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],  
     r.Content RespXML, r.CreateDt RespTime  
     --x.Content XMLContent, x.CreateDt   
   from fbitSignalXML x with (nolock) ---cross apply x.Content.nodes('/flxint/app/data/rec') t(s)  
   left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 16
  where x.SignalTypeID = 16 
    --and t.s.value('(orno)[1]','varchar(100)') = @Pallet 
  order by x.Content.value('(flxint/app/sigref)[1]','varchar(100)') desc 

--Check by Pallet
declare @Pallet varchar(100)
set @Pallet = 'PLTK2202000190'

select top 1 --t.s.value('(pack_id)[1]','varchar(100)') Pallet, 
	   x.UpdateDt [Signal Update Time], x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   x.StatusID, x.Content [XML],
	   case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],
	   isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],
	   r.Content RespXML, r.CreateDt RespTime
  from fbitSignalXML x --cross apply x.Content.nodes('/flxint/app/data/rec/pack') t(s)
  left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 16
 where x.SignalTypeID = 16
    --t.s.value('(pack_id)[1]','varchar(100)') = @Pallet
 order by x.UpdateDt


 --Selecting distinct signals will not allow for xml content
--STPSTA
select distinct sx.id ID, sx.SignalID, sx.FileName, sx.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref, sx.SignalTypeID, st.Name, sx.StatusID, ls.StatusName, sx.UpdateDt, sx.UpdateBy, ls.TableName
from fbitSignalXML sx with(nolock)
left outer join fbitLuStatus ls with(nolock) on sx.StatusID = ls.StatusID 
join fbitLuSignalType st with(nolock) on sx.SignalTypeID = st.id
where sx.FileName like '%STPSTA%' and ls.TableName = 'fbitSignalXML' and sx.CreateDt between '2022-01-12 18:00:00.000' and '2022-01-13 04:00:00.000'

----SFCCOM
--select distinct sx.id ID, sx.SignalID, sx.FileName, sx.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref, sx.SignalTypeID, st.Name, sx.StatusID, ls.StatusName, sx.UpdateDt, sx.UpdateBy, ls.TableName
--from fbitSignalXML sx with(nolock)
--left outer join fbitLuStatus ls with(nolock) on sx.StatusID = ls.StatusID 
--join fbitLuSignalType st with(nolock) on sx.SignalTypeID = st.id
--where sx.FileName like '%SFCCOM%' and ls.TableName = 'fbitSignalXML' and sx.CreateDt between '2022-01-12 18:00:00.000' and '2022-01-13 04:00:00.000'

----INVMOV
--select distinct sx.id ID, sx.SignalID, sx.FileName, sx.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref, sx.SignalTypeID, st.Name, sx.StatusID, ls.StatusName, sx.UpdateDt, sx.UpdateBy, ls.TableName
--from fbitSignalXML sx with(nolock)
--left outer join fbitLuStatus ls with(nolock) on sx.StatusID = ls.StatusID 
--join fbitLuSignalType st with(nolock) on sx.SignalTypeID = st.id
--where sx.FileName like '%INVMOV%' and ls.TableName = 'fbitSignalXML' and sx.CreateDt between '2022-01-12 18:00:00.000' and '2022-01-13 04:00:00.000'

