SELECT * FROM ffMaterialUnitDetail WITH(NOLOCK)
WHERE reserved_02 = '1000608000'

SELECT * FROM ffMaterialUnitDetail WITH(NOLOCK)
WHERE Reserved_04 = 'C5B000219'

--LooperCount = '2' AND 
--Reserved_04 LIKE 'C5B000219' 
--reserved_02 = '1000608000'

SELECT * FROM udtSensorData WITH(NOLOCK)
WHERE LotCode = '1000608000'

SELECT * FROM udtSensorSerials WITH(NOLOCK)
WHERE SensorDataID = '4031'


SELECT ffMaterialUnitDetail.Reserved_02 AS LotCode,
ffMaterialUnitDetail.Reserved_01 as Skid,
--sn.Value as Tray,
ffSerialNumber.Value as UnitSN,
--ffUnitDetail.reserved_14 as TraySN,
--udtSensorSerials.Serial,
ffMaterialUnitDetail.Reserved_04 as ProductionOrder,
ffMaterialUnitDetail.LooperCount
--ffUnitDetail.reserved_07 AS RetainUnit
FROM ffMaterialUnitDetail WITH(NOLOCK)
INNER JOIN udtSensorData WITH(NOLOCK) ON udtSensorData.LotCode = ffMaterialUnitDetail.Reserved_02
INNER JOIN udtSensorSerials WITH(NOLOCK) ON udtSensorSerials.SensorDataID = udtSensorData.ID
INNER JOIN ffSerialNumber WITH(NOLOCK) ON ffSerialNumber.Value = udtSensorSerials.Serial
--INNER JOIN ffUnit WITH(NOLOCK) ON FFUNIT.ID = ffSerialNumber.UnitID
--INNER JOIN ffUnit tray with(nolock) on tray.ID = ffunit.PanelID
--INNER JOIN ffSerialNumber sn WITH(NOLOCK) ON SN.UnitID = tray.ID
--INNER JOIN ffUnitDetail WITH(NOLOCK) ON ffUnitDetail.UnitID = ffSerialNumber.Value AND ffUnitDetail.reserved_07 = 'Y'
WHERE ffMaterialUnitDetail.Reserved_02 = '1000608000' AND ffMaterialUnitDetail.LooperCount = 2


--select * from ffSerialNumber
--where Value = '3109200804000001'

--select * from ffUnit with(nolock)
--where id = '-2039124625'

select * from ffProductionOrder
where ID = 3975


select * from ffUnit WITH(NOLOCK)
INNER JOIN ffUnitDetail WITH(NOLOCK) ON FFUNITDETAIL.UNITID = FFUNIT.ID
INNER JOIN ffProductionOrder WITH(NOLOCK) ON ffProductionOrder.ID = FFUNIT.PRODUCTIONORDERID
WHERE ffProductionOrder.ProductionOrderNumber = 'C5B000220' AND ffUnitDetail.reserved_07 = 'Y'