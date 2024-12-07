Select top 10* from udtKitPackLog with(nolock)
order by ID desc

Select * from udtKitPackProductionOrderQueue with(nolock)
where ProductionOrderID = 10274
order by ProductionOrderID desc