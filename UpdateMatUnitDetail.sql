select * from ffMaterialUnitDetail
where ID in ('-2146454496','-2146454497','-2146454500')

begin tran
update ffMaterialUnitDetail
set Reserved_17 = 'A-39200424_3297779'
WHERE ID in ('-2146454500')
rollback tran

begin tran
update ffMaterialUnitDetail
set Reserved_17 = 'A-39200417_3297779'
WHERE ID in ('-2146454497')
rollback tran

begin tran
update ffMaterialUnitDetail
set Reserved_17 = 'A-39200417_3297779'
WHERE ID in ('-2146454496')
rollback tran