      
--CREATE proc [dbo].[ruspCheckINVMOVSigref]  
--@Order varchar(100) = NULL  
--as  
--begin  
  
  --By Sigref
 select top 1 x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,  
     --t.s.value('(orno)[1]','varchar(100)') OrderNumber,   
     --t.s.value('(item)[1]','varchar(100)') Item,   
     --t.s.value('(qty_deliver)[1]','int') Qty,   
     --t.s.value('(qty_reject)[1]','int') QtyRejected,   
     --t.s.value('(close)[1]','int') CloseFlag,   
     case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],  
     isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],  
     r.Content RespXML, r.CreateDt RespTime,  
     x.Content XMLContent, x.CreateDt   
   from fbitSignalXML x with (nolock) cross apply x.Content.nodes('/flxint/app/data/rec') t(s)  
   left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 13 
  where x.SignalTypeID = 13 and x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = 003840689
   -- and t.s.value('(orno)[1]','varchar(100)') = @Order  -- Or Check By WO
  order by x.id 
  
--By Cart/Pallet

  select x.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref,  
       t.s.value('(ref2skid)[1]','varchar(100)') Pallet,  
       x.Content.value('(flxint/app/data/rec/source)[1]','varchar(100)') Source,  
       x.Content.value('(flxint/app/data/rec/destination)[1]','varchar(100)') Destination,  
       t.s.value('(qty)[1]','varchar(100)') Qty,  
       x.CreateDt,  
       x.Content,  
       t.s.query('attributes/attribute')  
     from fbitSignalXML x cross apply x.Content.nodes('/flxint/app/data/rec/stockpoints/stockpoint') t(s)   
    where x.SignalTypeID = 13  
      and t.s.value('(ref2skid)[1]','varchar(100)') = --@Pallet  
    order by x.CreateDt  