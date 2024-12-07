

-- by Pallet
select t.s.value('(attributes/attribute/attrno)[1]','varchar(100)') Attributo,
	   t.s.value('(attributes/attribute/attval)[1]','varchar(100)') OrderNumber,
	   t.s.value('(ref2skid)[1]','varchar(100)') Pallet,
	   x.Content.value('(flxint/app/data/rec/source)[1]','varchar(100)') Source,
	   x.Content.value('(flxint/app/data/rec/destination)[1]','varchar(100)') Destination,
	   t.s.value('(qty)[1]','varchar(100)') Qty,
	   x.CreateDt,
	   x.Content 
  from fbitSignalXML x cross apply x.Content.nodes('/flxint/app/data/rec/stockpoints/stockpoint') t(s) 
 where x.SignalTypeID = 13
   and t.s.value('(ref2skid)[1]','varchar(100)') in ('S-42190099')
--   and x.Content.value('(flxint/app/data/rec/source)[1]','varchar(100)') <> '768088'
--   and x.Content.value('(flxint/app/data/rec/destination)[1]','varchar(100)') = '768078'
 order by x.CreateDt

/*
-- by Order
select t.s.value('(attributes/attribute/attrno)[1]','varchar(100)') Attributo,
	   t.s.value('(attributes/attribute/attval)[1]','varchar(100)') OrderNumber,
	   t.s.value('(ref2skid)[1]','varchar(100)') Pallet,
	   x.Content.value('(flxint/app/data/rec/source)[1]','varchar(100)') Source,
	   x.Content.value('(flxint/app/data/rec/destination)[1]','varchar(100)') Destination,
	   t.s.value('(qty)[1]','varchar(100)') Qty,
	   x.CreateDt,
	   x.Content 
  from fbitSignalXML x cross apply x.Content.nodes('/flxint/app/data/rec/stockpoints/stockpoint') t(s) 
 where x.SignalTypeID = 13
   and t.s.value('(attributes/attribute/attval)[1]','varchar(100)') = 'A40000012'
 order by t.s.value('(ref2skid)[1]','varchar(100)')
*/
