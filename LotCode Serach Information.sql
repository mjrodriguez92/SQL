SELECT sn.Value as UnitSerialNumber,us.Description as UnitStatus,ud.reserved_07 as RetainUnit,u.CreationTime as UnitCreationTime,mud.Reserved_01 as Skid,mud.Reserved_02 as LotCode,MUD.Reserved_13 as OpenBagTime,substring(UD.reserved_14,1,12) as Tray FROM udtSensorData sd with(nolock)
inner join udtSensorSerials ss with(nolock) on sd.ID = ss.SensorDataID
INNER JOIN ffMaterialUnitDetail MUD WITH(NOLOCK) ON MUD.Reserved_02 = SD.LotCode
left outer join ffSerialNumber sn with(nolock) on sn.Value = ss.Serial
left outer join ffUnit u with(nolock) on sn.UnitID = u.ID
left outer join ffUnitDetail ud with(nolock) on ud.UnitID = u.ID
left outer join luUnitStatus us with(nolock) on us.ID = u.StatusID
where sd.LotCode = '1000603634' and sn.Value is not Null --and u.StatusID <> 3 --AND UD.reserved_07 = 'Y'
order by u.CreationTime asc

/*
Very High Priority, this is for audit - 
Request to provide me the Acclimation start time and date 
vs Acclimation End time and date and( time and date) of the first tray data file that was produced by the sensor reel. 
Srnsor lot: 1000603634

first tray data file
Acclimation start time
---Acclimation End time
*/
--select * from fsFieldDefinition where tablename = 'ffMaterialUnitDetail'

--imp

--select * from udtSensorData
--where LotCode = '1000603634'

--select top 100 * from udtSensorSerials
--where SensorDataID = '3709'

--select
--mu.id, mu.SerialNumber Skid
--, ms.Description MaterialStatus
--, mu.BalanceQty
--, P.PartNumber, P.Revision
--, sd.LotCode
--, sd.FirstSensorSerial
--, sd.LastSensorSerial
--, mud.Reserved_02 'LotCode'
--, mu.CreationTime
--, mud.Reserved_13 'Acclimation Finish Time'
--, mud.reserved_04 'PO'
--,e.UserID
--,e.Firstname + ' ' + e.Lastname UserName
--from
--ffmaterialunit(nolock) MU
--join ffmaterialunitdetail(nolock) MUD on MUD.MaterialUnitID = MU.ID and mu.LooperCount = mud.LooperCount
--join ffPart(nolock) P on P.ID = MU.PartID
--join luMaterialUnitStatus(nolock) ms on ms.ID = mu.StatusID
--join udtSensorData(nolock) sd on sd.LotCode = mud.Reserved_02
--join ffMaterialUnitHistory mh on MUD.MaterialUnitID = mh.MaterialUnitID
--left join luMaterialUnitStatus mus on mh.StatusID = mus.ID
--join ffEmployee e on mh.EmployeeID = e.ID
--where mud.reserved_02 = '1000603634'
----MUD.reserved_04 IN('C50000234')
----MUD.reserved_04 IN('C50000018','C50000034','C50000035')
--group by
--mu.id, mu.SerialNumber
--, ms.Description
--, mu.BalanceQty
--, P.PartNumber, P.Revision
--, sd.LotCode
--, sd.FirstSensorSerial
--, sd.LastSensorSerial
--, mud.Reserved_02
--, mud.Reserved_13
--, mu.CreationTime
--, mud.Reserved_04
--,e.UserID
--,e.Firstname + ' ' + e.Lastname
--order by mu.SerialNumber

--select * from ffMaterialUnitDetail with(nolock)
--where Reserved_07 = 'Y'
