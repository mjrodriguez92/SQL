/*

The material report for KP WO KTP003089 has incorrect use by date for the Lot 668548(2022/06/03) & Lot 668587(2022/05/04).

The UBD for the lost listed below are incorrect and needs to be updated as listed in the KP material report:
1.Lot 672186 (2022/09/30)
2.Lot 671028 (2022/09/08)
3.Lot 671023 (2022/09/07)
4.Lot 668587 (2022/05/04)
5.Lot 668548 (2022/06/03)
6.Lot 672184 (2022/10/04)
*/


Select * from ffMaterialUnitDetail mus with(nolock)
where mus.Reserved_02 = '672186'

Select * from ffMaterialUnitDetail mus with(nolock)
where mus.Reserved_02 = '671028'

Select * from ffMaterialUnitDetail mus with(nolock)
where mus.Reserved_02 = '671023'

Select * from ffMaterialUnitDetail mus with(nolock)
where mus.Reserved_02 = '668587'

Select * from ffMaterialUnitDetail mus with(nolock)
where mus.Reserved_02 = '668548'

Select * from ffMaterialUnitDetail mus with(nolock)
where mus.Reserved_02 = '672184'



Update ffMaterialUnitDetail
set Reserved_11 = '30092022'
where ffMaterialUnitDetail.Reserved_02 = '672186'

Update ffMaterialUnitDetail
set Reserved_11 = '08092022'
where ffMaterialUnitDetail.Reserved_02 = '671028'

Update ffMaterialUnitDetail
set Reserved_11 = '07092022'
where ffMaterialUnitDetail.Reserved_02 = '671023'

Update ffMaterialUnitDetail
set Reserved_11 = '04052022'
where ffMaterialUnitDetail.Reserved_02 = '668587'

Update ffMaterialUnitDetail
set Reserved_11 = '03062022'
where ffMaterialUnitDetail.Reserved_02 = '668548'

Update ffMaterialUnitDetail
set Reserved_11 = '04102022'
where ffMaterialUnitDetail.Reserved_02 = '672184'

