select top 5 *
from udtKitPackProductionOrderQueue poq with(nolock)
where poq.MachineName = 'MSI05'

select top 100*
from udtKitPackLog with(nolock)
order by id desc

select *
from udtKitPackProductionOrderQueue poq with(nolock)
where poq.ProductionOrderID = 7857




Select * 
from ffProductionOrder po with(nolock)
where po.ProductionOrderNumber = 'KTP001838'

Begin tran
DELETE udtKitPackProductionOrderQueue where ProductionOrderID = 7857

update ffProductionOrder
set StatusID = 5 -- Force-Closed  2 = Active 
where ID = 7857

Select * 
from ffProductionOrder po with(nolock)
where po.ProductionOrderNumber = 'KTP001838'

Rollback tran

Select * 
from ffProductionOrder po with(nolock)
where po.ProductionOrderNumber = 'KTP001838'