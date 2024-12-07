/***********************************************************************************************************************************************************          
         Author : Michael Rodriguez
  Creation Date : 20th Jan 2022  
    Explanation : Get STPSTA Information  
      Parameter : None  
         Output : Return skids information  
       Is used  : Libre all Factories  
  
Version    Date                   FlexPM Task    Author                Description                        
---------  ---------------------  -------------  --------------------  ------------------------------------                        
1.0        01/17/2022             None           Michael Rodriguez     INITIAL VERSION  
***************************************************************************************************************************************************************/ 

--CREATE proc [dbo].[ruspCheckSTPSTA]

declare @SignalUpdateTime datetime
--set @SignalUpdateTime = '2022-01-20 18:00:00.000'
declare @ResponseTime datetime
--set @ResponseTime = '2022-01-21 00:00:00.000'
--as  
--begin 

 select top 10 x.UpdateDt [Signal Update Time], x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   x.StatusID, x.Content [XML], 
     t.s.value('(orno)[1]','varchar(100)') OrderNumber,   
     t.s.value('(item)[1]','varchar(100)') Item,   
     t.s.value('(qty_deliver)[1]','int') Qty,   
     t.s.value('(qty_reject)[1]','int') QtyRejected,   
     t.s.value('(close)[1]','int') CloseFlag,   
     case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],  
     isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],  
     r.Content RespXML, r.CreateDt RespTime   
   from fbitSignalXML x cross apply x.Content.nodes('/flxint/app/data/rec') t(s)  
   left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 16
  where x.SignalTypeID = 16 
	and x.UpdateDt >= @SignalUpdateTime AND r.CreateDt < @ResponseTime
  order by x.Content.value('(flxint/app/sigref)[1]','varchar(100)') desc 
  
  --end