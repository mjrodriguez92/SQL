
/* Check PackSN signal status */

declare @Pallet varchar(100)
set @Pallet = 'PLT00000000724'

select top 100 t.s.value('(pack_id)[1]','varchar(100)') Pallet, 
	   x.UpdateDt [Signal Update Time], x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   x.StatusID, x.Content [XML],
	   case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],
	   isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],
	   r.Content RespXML, r.CreateDt RespTime
  from fbitSignalXML x cross apply x.Content.nodes('/flxint/app/data/rec/pack') t(s)
  left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 14
 where x.SignalTypeID = 14
   and t.s.value('(pack_id)[1]','varchar(100)') = @Pallet
 order by x.ID 





