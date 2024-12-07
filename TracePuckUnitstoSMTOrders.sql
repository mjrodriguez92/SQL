select o2.ProductionOrderNumber, sn.Value SN
  into #temp
  from ffProductionOrder o with (nolock)
  join ffunit u with (nolock) on o.ID = u.ProductionOrderID 
  join ffSerialNumber sn with (nolock) on u.ID = sn.UnitID and sn.SerialNumberTypeID = 0 
  join ffHistory h with (nolock) on u.ID = h.UnitID 
  join ffProductionOrder o2 with (nolock) on h.ProductionOrderID = o2.ID
 where o.ProductionOrderNumber = 'P30000009'
-- group by o2.ProductionOrderNumber 

--drop table #temp 

 select distinct t.ProductionOrderNumber, t.SN
   into #temp2
   from #temp t

 select t.ProductionOrderNumber, count(t.SN) TotalUnits
   from #temp2 t
  group by t.ProductionOrderNumber
  order by t.ProductionOrderNumber desc

select t.SN
  from #temp2 t
  left join #temp2 t2 on t.SN = t2.SN and t2.ProductionOrderNumber <> 'P30000009'
 where t.ProductionOrderNumber = 'P30000009'
   and t2.SN is null

select h.*, p.PartNumber 
  from ffSerialNumber sn
  join ffunit u on sn.UNitID = u.ID 
  join ffhistory h on u.ID = h.UnitID 
  join ffpart p on h.PartID = p.ID
 where sn.value = 'P36190016'


