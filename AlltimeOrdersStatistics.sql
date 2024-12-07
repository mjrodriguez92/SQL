if object_id('tempdb..#temp') is not null
	drop table #temp

select o.ID, o.ProductionOrderNumber, o.OrderQuantity,
	   sum(case when u.statusID = 1 then 1 else 0 end) Good,
	   sum(case when u.statusID = 3 then 1 else 0 end) Bad,
	   sum(case when u.statusID = 0 then 1 else 0 end) Processing,
	   (select max(oh.ID) 
		 from ffProductionOrderHistory oh with (nolock)
	    where oh.ProductionOrderID = o.ID) HistoryID
  into #temp
  from ffProductionOrder o with (nolock)
  join ffunit u with (nolock) on o.ID = u.ProductionOrderID 
  join luUnitStatus us with (nolock) on u.StatusID = us.ID
 group by o.ID, o.ProductionOrderNumber, o.OrderQuantity

select t.ProductionOrderNumber, t.OrderQuantity, t.Good, t.Bad, t.Processing, os.[Description] OrderStatus, oh.[Time] LastStatus, oh2.[Time] ActivateStatus
  from #temp t
  join ffProductionOrderHistory oh with (nolock) on t.HistoryID = oh.ID
  join luProductionOrderStatus os on oh.ProductionOrderStatusID = os.ID
  left join ffProductionOrderHistory oh2 with (nolock) on t.ID = oh2.ProductionOrderID and oh2.ProductionOrderStatusID = 3
 order by t.ProductionOrderNumber


