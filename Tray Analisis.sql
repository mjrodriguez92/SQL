select * 
  from udtTray t
  join ffSerialNumber sn on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0
 where sn.value = 'E0019944-H19'

select sn.Value,  t.* 
  from udtTray t
  join ffSerialNumber sn on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0
 where t.StackID = 2456 

select sn.Value, count(u.ID) Units
  from udtTray t
  join ffSerialNumber sn on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0
  join ffunit u on t.UnitID = u.PanelID 
 where t.StackID = 2456 
 group by sn.Value

select sn.Value, sn2.Value
  from udtTray t
  join ffSerialNumber sn on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0
  join ffunit u on t.UnitID = u.PanelID 
  join ffSerialNumber sn2 on u.ID = sn2.UnitID and sn2.SerialNumberTypeID = 0
 where sn.Value = 'E0017553-H19' 

select * from udtAPILog with (nolock) where Request like '%E0017553-H19%' 

