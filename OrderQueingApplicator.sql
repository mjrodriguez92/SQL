
select * from ffProductionOrder with(nolock)
where ProductionOrderNumber = 'A40000965'

--begin tran
----update udtOrderQueueingProductionOrder
--set MachineID = 1,POMachineAssignationStatusID = 0,LotConfigFileName = NULL,LotConfigFileCreateDate  = NULL
--WHERE ProductionOrderID = '4929'
--rollback tran

select TOP 100 * from udtOrderQueueingProductionOrder with(nolock)
WHERE ProductionOrderID = '4929'

SELECT * FROM udtOrderQueueingPOMachineAssignationStatus with(nolock)

SELECT TOP 10 * FROM udtLog with(nolock)
WHERE ProductionOrderID = '4929'

SELECT TOP 1000 * FROM udtLog with(nolock)
WHERE Message LIKE '%Successfully%' 

SELECT TOP 100 * FROM udtOrderQueueingProductionOrder  with(nolock)






