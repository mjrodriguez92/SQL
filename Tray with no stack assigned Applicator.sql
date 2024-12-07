-- TO FIX ---> "There is a tray with no Stack Assigned. Please check"---- Confirm that Tray's contain the StackID as Null value  SELECT t.Id TrayID, * FROM ffSerialNumber sn 	LEFT OUTER JOIN udtTray t ON sn.UnitID = t.UnitID  WHERE sn.value in ('P0068233-K19',
'P0077084-K19',
'P0102959-L19',
'P0137880-A20',
'P0137988-A20',
'P0158644-K20',
'P0162118-K20',
'P0162259-K20',
'P0162889-K20',
'P0166960-K20'
)-- Get WO IDselect * from ffProductionOrder with(nolock) where ProductionOrderNumber = 'P30001532'-- Get Station IDselect * from ffStation with(nolock) where Description like '%ABW04%'-- To Fix-- 1. Follow The Format From The Result Of This Stack To Create A New One. Current Count Is The Max Count Of Trays Allowed In A Stack.SELECT * FROM udtStack where SerialNumber = 'StackP20050020_INC11874191'-- 2. In Order To Fix We Will Insert A New Stack With The Same Values--INSERT INTO udtStack SELECT 'StackP20050020_INC11874191',GETDATE(),GETDATE(),2,10711,'P30001532',1000,550,20  -- 3. Get the Stack IDSELECT * FROM udtStack where SerialNumber = 'StackP20050020_INC11874191'    -- 4. Insert New StackID For Trays --  SELECT t.Id TrayID, * FROM ffSerialNumber sn with(nolock)--	LEFT OUTER JOIN udtTray t with(nolock) on sn.UnitID = t.UnitID--  WHERE sn.value in ('P0077001-K19',
--'P0168459-K20',
--'P0164805-K20',
--'P0138576-A20',
--'P0166144-K20',
--'P0031338-J19',
--'P0161126-K20',
--'P0162737-K20',
--'P0148360-A20',
--'P0219955-K21',
--'P0219956-K21',
--'P0148244-A20',
--'P0158738-K20',
--'P0159231-K20',
--'P0161492-K20',
--'P0031832-J19',
--'P0166910-K20',
--'P0004500-G19',
--'P0163160-K20'
--)--Begin tran--	UPDATE udtTray--	SET StackID = 771808--	WHERE ID IN (2523,
--31754,
--32248,
--78251,
--144821,
--154658,
--154774,
--179851,
--180346,
--182252,
--182618,
--184073,
--184499,
--186149,
--187491,
--188257,
--189806,
--246011,
--246012--)--  SELECT t.Id TrayID, * FROM ffSerialNumber sn with(nolock)--	LEFT OUTER JOIN udtTray t with(nolock) on sn.UnitID = t.UnitID--  WHERE sn.value in ('P0077001-K19',
--'P0168459-K20',
--'P0164805-K20',
--'P0138576-A20',
--'P0166144-K20',
--'P0031338-J19',
--'P0161126-K20',
--'P0162737-K20',
--'P0148360-A20',
--'P0219955-K21',
--'P0219956-K21',
--'P0148244-A20',
--'P0158738-K20',
--'P0159231-K20',
--'P0161492-K20',
--'P0031832-J19',
--'P0166910-K20',
--'P0004500-G19',
--'P0163160-K20'
--)--Rollback tran--  SELECT t.Id TrayID, * FROM ffSerialNumber sn with(nolock)--	LEFT OUTER JOIN udtTray t with(nolock) on sn.UnitID = t.UnitID--  WHERE sn.value in ('P0077001-K19',
--'P0168459-K20',
--'P0164805-K20',
--'P0138576-A20',
--'P0166144-K20',
--'P0031338-J19',
--'P0161126-K20',
--'P0162737-K20',
--'P0148360-A20',
--'P0219955-K21',
--'P0219956-K21',
--'P0148244-A20',
--'P0158738-K20',
--'P0159231-K20',
--'P0161492-K20',
--'P0031832-J19',
--'P0166910-K20',
--'P0004500-G19',
--'P0163160-K20'
--)