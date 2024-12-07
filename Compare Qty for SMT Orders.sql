

declare @OrderNumber varchar(100)
declare @OrderID int
declare @OrderQty int

set @OrderNumber = 'S20000034'

select @OrderID = o.ID, @OrderQty = o.OrderQuantity from ffProductionOrder o where o.ProductionOrderNumber = @OrderNumber

/*
select o.ID, o.ProductionOrderNumber, o.OrderQuantity, count(u.ID) Total
  from ffProductionOrder o
  join ffunit u on o.ID = u.ProductionOrderID 
 where o.ID = @OrderID
 group by o.ProductionOrderNumber, o.OrderQuantity, o.ID
*/

if object_id('tempdb..#units') is not null
	drop table #units

if object_id('tempdb..#TotalUnits') is not null
	drop table #TotalUnits

select distinct h.UnitID
  into #units
  from ffHistory h
 where h.ProductionOrderID = @OrderID

select @OrderNumber SMTOrder, sn.Value SN, us.[Description] UnitStatus, o.ProductionOrderNumber CurrentOrderNumber, @OrderQty PlannedQty, 
	   case us.[Description] when 'Scrap' then 1 else 0 end Scrap,
	   case us.[Description] when 'Completed' then 1 else 0 end Completed,
	   case when us.[Description] not in ('Scrap', 'Completed') then 1 else 0 end Other
  into #TotalUnits
  from #units t
  join ffunit u on t.UnitID = u.ID
  join ffSerialNumber sn on u.ID = sn.UNitID and sn.SerialNumberTypeID = 0
  join luUnitStatus us on u.StatusID = us.ID
  join ffProductionOrder o on u.ProductionOrderID = o.ID

select SMTOrder, PlannedQty, sum(Scrap) + sum(Completed) + sum(Other) OrderTotal, sum(Scrap) TotalScrap, sum(Completed) TotalCompleted, sum(Other) TotalOther
  from #TotalUnits
 group by SMTOrder, PlannedQty



