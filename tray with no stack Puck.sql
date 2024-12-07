-- TO FIX ---> "There is a tray with no Stack Assigned. Please check"

---- Confirm that Tray's contain the StackID as Null value
  SELECT t.Id TrayID, * FROM ffSerialNumber sn with(nolock)
	LEFT OUTER JOIN udtTray t with(nolock) ON sn.UnitID = t.UnitID
  WHERE sn.value IN ('P0103996-L19',
'P0168098-K20',
'P0005651-G19',
'P0166865-K20',
'P0154386-J20',
'P0168027-K20',
'P0164103-K20',
'P0032245-J19',
'P0164065-K20',
'P0126967-M19',
'P0005390-G19',
'P0005127-G19',
'P0166668-K20',
'P0162571-K20',
'P0148422-A20',
'P0004546-G19',
'P0168567-K20',
'P0166054-K20',
'P0158747-K20')


Select * from ffProductionOrder with(nolock) where ID = 10089

--- Search the stackID exists based on the WO
  SELECT * FROM udtStack with(nolock) WHERE LotNumber = 'P30001445'

----To Fix
--- 1. In order to fix we will insert a new stack with the same values
  --INSERT INTO udtStack SELECT 'StackP20050020',GETDATE(),GETDATE(),2,2084,'P30000370',1000,388,10
  
--- 2. Get the Stack ID
  SELECT ID FROM udtStack where SerialNumber = 'StackP20050020'
    
Begin tran
	UPDATE udtTray
	SET StackID = 264351
	WHERE ID IN (132985)

Rollback tran