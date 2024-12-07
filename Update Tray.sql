 select * 
  from udtTray t
  join ffSerialNumber sn with(nolock) on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0
 where sn.value = 'S0017761-F20'

begin tran

Update udtTray
set CartID = NULL
Where CartID = 0
 select * 
  from udtTray t
  join ffSerialNumber sn with(nolock) on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0
 where sn.value = 'S0017761-F20'

Rollback Tran

 select * 
  from udtTray t
  join ffSerialNumber sn with(nolock) on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0
 where sn.value = 'S0017761-F20'