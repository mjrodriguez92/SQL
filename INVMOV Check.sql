   -- by Pallet or Cart 
   Declare @Pallet varchar(100)
   Set @Pallet =
   --Declare @Cart varchar(100) 
   --Set @Cart = 

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
      and t.s.value('(ref2skid)[1]','varchar(100)') = @Pallet  
    order by x.CreateDt  
  
   -- by Order 
   Declare @Order varchar(100)
   Set @Order = 

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
      and t.s.value('(attributes/attribute/attval)[1]','varchar(100)') = @Order  
    order by t.s.value('(ref2skid)[1]','varchar(100)')  

  

  
