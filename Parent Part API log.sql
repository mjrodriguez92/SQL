    
-------------- Find Response ----------------------------


SELECT * 


FROM udtAPILog WITH(nolock) 


WHERE  


CreationTime >= '2021-08-25 00:00:00' and CreationTime <= '2021-09-03 00:00:00' ----- Check the time of the Ticket and start searching on day before just to be sure 


and Request like '%P0005713-G19%'  ----- Tray from the ticket  


-------------- Stored Procedure ---------------------------
SELECT * FROM ffProductionOrder WHERE ProductionOrderNumber = 'S20001081'   -- SMT 


select * from ffPart where id = 6884   ---- SMT Part Number 





SELECT ParentPartID, PartID, [Level]   


FROM ufnPSTGetProdStructByPO (7766, 6884, NULL) ---(WorkOrderID, PartNumberID,NULL) 


--SELECT * FROM ffPart p with(nolock) where p.PartNumber = 'THRL-PRT28449-750' and p.Revision = 'E'


--SELECT * FROM ffProductionOrder po with(nolock) where po.ProductionOrderNumber = 'S20000899'














