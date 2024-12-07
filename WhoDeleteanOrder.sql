
declare @OrderNumber varchar(100)

set @OrderNumber = 'PQ0040234'

select e.*
  from EntityLogs e
 where e.[State] = 'Deleted'
   and EntityType = 'Flex.Mespro.Models.ProductionOrder'
   and LogData like '%' + @OrderNumber + '%'




