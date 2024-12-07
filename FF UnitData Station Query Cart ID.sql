/*
Comment can be false but Code don't
*/


-- Step 1  

select * from ffMaterialUnit mu -- Look up Cart ID which don't belong to Unit Data Station or Pick List or Cancel in the PickList.
  join ffMaterialUnitDetail mud on mu.ID = mud.MaterialUnitID
  where mud.Reserved_04 = 'K60000203' -- Write the current WO number.


--- Step 2

  begin tran
select * from ffMaterialUnitDetail where ID = -2147100614 -- Use the ID from the table ffMaterialUnitDetail
update ffMaterialUnitDetail set Reserved_04 = null where ID = -2147100614
select * from ffMaterialUnitDetail where ID = -2147100614
rollback tran