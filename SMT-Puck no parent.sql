
Select *
from ffpart p with(nolock)
inner join ffProductionOrder po with(nolock) on p.ID = po.ProductionOrderNumber
where po.ProductionOrderNumber = 6665



Select *
from ffProductionOrder po with(nolock)
where po.ProductionOrderNumber = 'S20000911'


SELECT * 
FROM ffProductionOrder po with(nolock) 
WHERE po.ProductionOrderNumber = 'S20000894'   -- SMT 

select * 
from ffPart p with(nolock) 
where p.ID = 6971   ---- SMT Part Number 


SELECT ParentPartID, PartID, [Level]   
FROM ufnPSTGetProdStructByPO (6678, 6971, NULL) ---(WorkOrderID, PartNumberID,NULL) 
