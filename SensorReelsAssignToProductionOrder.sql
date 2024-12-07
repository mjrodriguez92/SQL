
/*************************************
	Check Skids (Reels) for a Order
************************************/

declare @OrderNumber varchar(100)
declare @IsRetain varchar(10) 

set @OrderNumber = 'C50000034'
set @IsRetain = 'N'

select isnull(TraySN.Value,'No Tray Assigned') TraySN, Tray.CreationTime, isnull(ud.reserved_07, 'N') Retain, mu.SerialNumber SensorReel, Count(u.ID) TrayTotal
  from ffProductionOrder o with (nolock)
  join ffunit u with (nolock) on o.ID = u.ProductionOrderID 
  join ffUnitDetail ud with (nolock) on u.ID = ud.UnitID and u.LooperCount = ud.LooperCount
  left join ffSerialNumber sn with (nolock) on u.ID = sn.UnitID and sn.SerialNumberTypeID = 0
  left join udtSensorSerials ss with (nolock) on sn.Value = ss.Serial 
  left join udtSensorData sd with (nolock) on ss.SensorDataID = sd.ID 
  left join ffmaterialunitdetail mud with (nolock) on sd.LotCode =  mud.Reserved_02
  left join ffmaterialunit mu with (nolock) on mu.ID = mud.MaterialUnitID 
  left join ffunit Tray with (nolock) on u.PanelID = Tray.ID 
  left join ffSerialNumber TraySN with (nolock) on Tray.ID = TraySN.UnitID and TraySN.SerialNumberTypeID = 0
 where u.StatusID <> 3 --Scrap
   and o.ProductionOrderNumber = @OrderNumber
   and (ud.InmostPackageID is null or ud.InmostPackageID = ud.OutmostPackageID)
   and isnull(ud.reserved_07,'N') = @IsRetain
 group by TraySN.Value, Tray.CreationTime, ud.reserved_07, mu.SerialNumber
 order by TraySN.Value desc
 


 




