-- Searches WO history/location. Also provides qty used for sensor serials and when they were used.

select Distinct o.ProductionOrderNumber, l.Description, l.Location, o.ActualStartTime, o.ActualFinishTime, lo.LineQuantity, lo.ReadyQuantity,  
sd.LotCode, u.id, sn.value,
(cast(sd.LastSensorSerial as bigint)) - cast(sd.FirstSensorSerial as bigint) ReelTotal,  count(u.ID) TotalUsed,
(cast(sd.LastSensorSerial as bigint)) - cast(sd.FirstSensorSerial as bigint) - count(u.ID) BalanceQty, mud.Reserved_13 UsedOnDateTime
  from ffUnit u
  join ffProductionOrder o with(nolock) on u.ProductionOrderID = o.ID
  join ffLineOrder lo with(nolock) on o.ID = lo.ProductionOrderID
  join ffpart p with(nolock) on o.PartID = p.ID
  join ffline l with(nolock) on lo.LineID = l.id
  join ffSerialNumber sn with(nolock) on u.ID = sn.UnitID and sn.SerialNumberTypeID = 0
  join udtSensorSerials ss with(nolock) on sn.Value = ss.Serial 
  join udtSensorData sd with(nolock) on ss.SensorDataID = sd.ID 
  join ffMaterialUnitDetail mud with(nolock) on sd.LotCode = mud.Reserved_02
 where o.ProductionOrderNumber in ('C5B000726')
 group by o.ProductionOrderNumber, l.Description, l.Location, o.ActualStartTime, o.ActualFinishTime, 
 lo.LineQuantity, lo.ReadyQuantity, sd.LotCode, u.id, sn.value, sd.FirstSensorSerial, sd.LastSensorSerial, mud.Reserved_13
 order by 1, 13 asc


-- Unit Check ffHistory
/*
  Select Distinct po.ID, po.ProductionOrderNumber, u.id, sn.value
 from ffHistory h with(nolock) 
 join ffProductionOrder po with(nolock) on h.ProductionOrderID = po.ID
 join ffUnit u with(nolock) on h.ProductionOrderID = u.ProductionOrderID
 join ffSerialNumber sn with(nolock) on u.ID = sn.UnitID and sn.SerialNumberTypeID = 0
 where po.ProductionOrderNumber = 'C5B000726'
 */