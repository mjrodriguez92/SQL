USE P_LIBRE_FF
GO

Drop table #tempgood2
GO
Drop Table #tempbad2
Go



select COUNT (u.ID) QTY, po.ProductionOrderNumber
   into #tempgood2
  from ffProductionOrder po (nolock)
     join ffUnit u (nolock) on u.ProductionOrderID = po.ID
--join ffUnit u2 on u2.ID = po.ID   and u.StatusID <> 3
where po.ProductionOrderNumber like 'KTP%' and u.StatusID <> 3
group by po.ProductionOrderNumber
order by po.ProductionOrderNumber desc
--union all
   select COUNT (u.ID) QTY, po.ProductionOrderNumber
   into #tempbad2
   from ffProductionOrder po (nolock)
     join ffUnit u on u.ProductionOrderID = po.ID
where po.ProductionOrderNumber like 'KTP%' and u.StatusID = 3
group by po.ProductionOrderNumber
order by po.ProductionOrderNumber desc

select bad.ProductionOrderNumber, bad.QTY QTYGood, good.QTY QTYBad ,LPO.ReadyQuantity OrderQTY,PO.ActualStartTime,L.Description as Line 
from #tempgood2 bad
left join #tempbad2  good  on bad.ProductionOrderNumber = good.ProductionOrderNumber
left join ffProductionOrder po (nolock) on po.ProductionOrderNumber = bad.ProductionOrderNumber
left join ffLineOrder lpo (nolock) on lpo.ProductionOrderID = po.ID
left JOIN ffLine L WITH(NOLOCK) ON L.ID = LPO.LineID
where po.ActualStartTime between '2020-08-18 00:00:00.000' and '2020-08-18 23:59:59.000'
order by bad.ProductionOrderNumber desc