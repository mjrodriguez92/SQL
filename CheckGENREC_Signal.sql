
/* Check order signal status */

/*
30248584 -- 
30248623 -- Listo
30248556 -- Listo
30204149 -- Listo
*/


declare @Skid varchar(100)
set @Skid = '30204149'

select t.s.value('(skid)[1]','varchar(100)'), x.Content, x.*
  from fbitSignalXML x with (nolock) cross apply x.Content.nodes('/flxint/app/data/rec/skids/skid_rec') t(s)
 where x.SignalTypeID = 1
   and t.s.value('(skid)[1]','varchar(100)') = @Skid
 order by x.id desc



