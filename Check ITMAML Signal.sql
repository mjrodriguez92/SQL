/* Check ITMAML signal status */

declare @PartNumber varchar(100)
set @PartNumber = 'THRL-ENG-APPIQOQPBOM'


select t.s.value('(item)[1]','varchar(100)') PN, t.s.value('(revi)[1]','varchar(100)') Revision, 
	   x.UpdateDt [Signal Update Time], x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   x.StatusID, x.Content [XML],
	   case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],
	   isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],
	   r.Content RespXML, r.CreateDt RespTime
  from fbitSignalXML x cross apply x.Content.nodes('/flxint/app/data/rec/itemdef') t(s)
  join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber
 where x.SignalTypeID = 3
   and r.ToSignalTypeID = 3
   and t.s.value('(item)[1]','varchar(100)') = @PartNumber
 order by x.ID 





