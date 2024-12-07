select top 1000 * from ffMaterialUnitDetail
where MaterialUnitID in (
'-2146991338',
'-2146990813',
'-2146990688',
'-2146990649',
'-2146990579',
'-2146990575')

--A0132280-A20
--L1B12006069000107000326248
--L1B12006069000107000326249
--A-25200124
--Old Expiry Date '2021-12-05'

begin tran
Update ffMaterialUnitDetail
set Reserved_05 = '202112'
where MaterialUnitID = -2146990649
rollback tran

SELECT TOP 100 * FROM ffUnitDetail
INNER JOIN ffSerialNumber WITH(NOLOCK) ON ffSerialNumber.UnitID = ffUnitDetail.UnitID
WHERE ffSerialNumber.Value = 'L1B12006069000107000326249'


BEGIN TRAN
Update ffUnitDetail
set Reserved_06 = '202112'
where UnitID = -2090973248

SELECT TOP 100 * FROM ffUnitDetail
INNER JOIN ffSerialNumber WITH(NOLOCK) ON ffSerialNumber.UnitID = ffUnitDetail.UnitID
WHERE ffSerialNumber.Value = 'L1B12006069000107000326249'

ROLLBACK TRAN

