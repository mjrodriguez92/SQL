
/* Check order signal status */

declare @OrderNumber varchar(100)
set @OrderNumber = 'C50000046'

select top 10 x.Content.value('(flxint/app/data/rec/order/orno)[1]','varchar(100)') OrderNumber, 
	   x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   x.StatusID, x.CreateDt OrderCreationDate, x.UpdateDt,x.Content [XML],
	   r.Content Resp,
	   case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],
	   isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],
	   r.CreateDt ResponseCreationDate
  from fbitSignalXML x with (nolock)
  join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber
 where x.SignalTypeID = 4
   and x.Content.value('(flxint/app/data/rec/order/orno)[1]','varchar(100)') = @OrderNumber
 order by x.id desc

-- [udpfbipProcessOrderBookRec][Line:579]Item /Flexpartnumber[THRL-PRT23200-750]cannot be found in Flex flow.



