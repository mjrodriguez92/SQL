--EOQ000629

--S20001405
--S20001406
--S20001407



--Serach the WO want to force closed manually.
select top 10 * from ffProductionOrderHistory with(nolock)
where ProductionOrderID = 6678
order by 1 desc

select * from ffProductionOrder po
where po.ProductionOrderNumber = 'A40002056'

select * from luProductionOrderStatus



--Insert in FF History to force closed the WO.
begin tran
Insert into ffProductionOrderHistory (ProductionOrderID,ProductionOrderStatusID,Time,Comment,EmployeeID)
Values (11231,5,GETDATE(),NULL,NULL)

select top 10 * from ffProductionOrderHistory with(nolock)
where ProductionOrderID = 11231
order by 1 desc
rollback tran


--Set status for workorder to force close
BEGIN TRAN
UPDATE ffProductionOrder
SET StatusID = 5
WHERE ProductionOrderNumber = 'A40002056'
ROLLBACK TRAN


