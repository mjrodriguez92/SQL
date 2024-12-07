DROP TABLE #T
GO

SELECT h.ProductionOrderID ,po.ProductionOrderNumber WO ,h.UnitID ,MAX(h.ID) HistoryID
into #T
FROM ffProductionOrder po WITH(nolock)
INNER JOIN ffHistory h WITH(nolock) ON po.ID = h.ProductionOrderID
WHERE po.ProductionOrderNumber = 'S20000267'
GROUP BY h.ProductionOrderID ,po.ProductionOrderNumber ,h.UnitID


-- 54518 Total

--54004 units

SELECT t.*, sn.Value UnitSN, u.UnitStateID ,st.Description UnitState ,u.StatusID ,ust.Description UnitStatus
FROM #T t
INNER JOIN ffUnit u WITH(nolock) ON t.UnitID = u.ID
INNER JOIN ffSerialNumber sn WITH(nolock) ON t.UnitID = sn.UnitID AND SUBSTRING(sn.Value,1,1) <> 'S' AND sn.SerialNumberTypeID = 0
INNER JOIN luUnitStatus ust WITH(nolock) ON u.StatusID = ust.ID
INNER JOIN ffUnitState st WITH(nolock) ON u.UnitStateID = st.ID


SELECT * FROM ffProductionOrder po WITH(nolock)
WHERE po.ProductionOrderNumber = 'S20000267'

select * FROM ffLineOrder lo WITH(nolock)
WHERE lo.ProductionOrderID = 1854

SELECT * FROM luProductionOrderStatus

select * from ffProductionOrderHistory
WHERE ProductionOrderID = 1854


SELECT * FROM ffEmployee
WHERE Firstname LIKE '%Diksh%'

begin tran

declare @FT datetime
SET @FT = GETDATE()

SELECT @FT;


UPDATE ffProductionOrder
SET OrderQuantity = 54004 ,StatusID = 5 ,ActualFinishTime = @FT ,EmployeeID = 1479
WHERE ID = 1854

UPDATE ffLineOrder
SET LineQuantity =54004, StartedQuantity = 54004 ,ReadyQuantity = 48825
WHERE ProductionOrderID = 1854

INSERT INTO ffProductionOrderHistory (ProductionOrderID ,ProductionOrderStatusID ,Time, Comment, EmployeeID)
SELECT 1854,5,@FT,'WO Force Closed by Diksha request with 3295482 Monitor Ticket',1479 


SELECT * FROM ffProductionOrder po WITH(nolock)
WHERE po.ProductionOrderNumber = 'S20000267'

select * FROM ffLineOrder lo WITH(nolock)
WHERE lo.ProductionOrderID = 1854

SELECT * FROM luProductionOrderStatus

select * from ffProductionOrderHistory
WHERE ProductionOrderID = 1854

rollback tran


--SELECT po.ProductionOrderNumber, h.UnitID, sn.value UnitSN ,h.*
--FROM ffProductionOrder po WITH(nolock)
--INNER JOIN ffHistory h WITH(nolock) ON po.ID = h.ProductionOrderID
--INNER JOIN ffSerialNumber sn WITH(nolock) ON h.UnitID = sn.UnitID AND SUBSTRING(sn.Value,1,1) <> 'S' AND sn.SerialNumberTypeID = 0
--WHERE po.ProductionOrderNumber = 'S20000267'
--and h.UnitId = -2099557369
--ORDER BY h.ID


