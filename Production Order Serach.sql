/*
How many of downstream work orders are consumed by M10004363

need all WOs manufactured from SMT, PUCK, Applicator and container between OCT1st 2021-JAN 31st 2022
*/

select po.ProductionOrderNumber,po.ActualStartTime,po.ActualFinishTime,l.Description as Line,lo.ReadyQuantity,l.Location as Factory from ffProductionOrder po with(nolock)
inner join ffLineOrder lo with(nolock) on lo.ProductionOrderID = po.ID
inner join ffLine l with(nolock) on l.ID = lo.LineID
where po.ActualStartTime >= '2021-10-01 00:00:00.000' and po.ActualFinishTime <= '2022-01-31 23:59:30.727'
order by po.ActualStartTime