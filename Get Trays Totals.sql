/*
select sn.Value TraySN, UnitSN.Value UnitSN, Unit.StatusID, t.* 
  from ffSerialNumber sn with (nolock)
  join ffunit u with (nolock) on sn.UnitID = u.ID
  join ffunit Unit with (nolock) on u.ID = Unit.PanelID 
  join ffSerialNumber UnitSN with (nolock) on Unit.ID = UnitSN.UnitID and UnitSN.SerialNumberTypeID = 0
  join fftest t with (nolock) on Unit.ID = t.UnitID and t.IsPass = 0
 where sn.SerialNumberTypeID = 0 
   and sn.value = 'S0002077-F19'
  */ 

   select sn.Value, count(UnitSN.UnitID) Total  
     from udtCart c with (nolock)
	 join udtTray t with (nolock) on c.ID = t.CartID 
	 join ffSerialNumber sn with (nolock) on t.UnitID = sn.UnitID and sn.SerialNumberTypeID = 0 
	 join ffunit u with (nolock) on sn.UnitID = u.ID
	 join ffunit Unit with (nolock) on u.ID = Unit.PanelID 
	 join ffSerialNumber UnitSN with (nolock) on Unit.ID = UnitSN.UnitID and UnitSN.SerialNumberTypeID = 0
	where c.SerialNumber = 'S-38190064'
	group by sn.Value 




  