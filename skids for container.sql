select o.ProductionOrderNumber, o.OrderQuantity, sd.LotCode, (cast(sd.LastSensorSerial as bigint)) - cast(sd.FirstSensorSerial as bigint) ReelTotal,  count(u.ID) TotalUsed 
  from ffUnit u
  join ffProductionOrder o on u.ProductionOrderID = o.ID
  join ffSerialNumber sn on u.ID = sn.UnitID and sn.SerialNumberTypeID = 0
  join udtSensorSerials ss on sn.Value = ss.Serial 
  join udtSensorData sd on ss.SensorDataID = sd.ID 
 where o.ProductionOrderNumber in ('C5b000355')
 group by o.ProductionOrderNumber, o.OrderQuantity, sd.LotCode, sd.FirstSensorSerial, sd.LastSensorSerial
 order by o.ProductionOrderNumber, sd.LotCode


 