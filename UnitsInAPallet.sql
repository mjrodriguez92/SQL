

declare @Pallet varchar(100)

set @Pallet = 'PLT00000000635'

select p.SerialNumber Pallet, Box.SerialNumber BoxSN, TraySN.value TraySN, sn.Value UnitSN
  from ffPackage p with (nolock)
  join ffunitdetail ud with (nolock) on p.ID = ud.OutmostPackageID
  join ffunit u with (nolock) on ud.UnitID = u.ID and ud.LooperCount = u.LooperCount 
  join ffSerialNumber sn with (nolock) on u.ID = sn.UnitID and sn.SerialNumberTypeID = 0
  join ffPackage Box with (nolock) on ud.InmostPackageID = Box.ID
  join ffunit Tray with (nolock) on u.PanelID = Tray.ID
  join ffSerialNumber TraySN with (nolock) on Tray.ID = TraySN.UnitID and TraySN.SerialNumberTypeID = 0
 where p.SerialNumber in ('PLT00000000635','PLT00000000637','PLT00000000638','PLT00000000639','PLT00000000640','PLT00000000641','PLT00000000642','PLT00000000643','PLT00000000645','PLT00000000646','PLT00000000652','PLT00000000653')   --@Pallet 
 order by p.SerialNumber, Box.SerialNumber, TraySN.value, sn.Value

