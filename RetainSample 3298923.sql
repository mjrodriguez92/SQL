/*
We had a one issue notice for 2 of the Retain sample trays
(E0079352-K19 & E0035771-J19) linked to shipper box id: 000034072. 
When we try to scan this shipper box in “Container Sterilization Retain Pallet” 
system throw and error and not allowing us to move further.

--Trays ID
-2136397809
-2134222117

*/

--E0079352-K19
--E0035771-J19
--000034072

--1. Need to unpack the  Box 000034072 so trays (E0079352-K19 & E0035771-J19) will not have any box assign to them.

select * from ffSerialNumber with(nolock) 
where Value in ('E0079352-K19','E0035771-J19')

select * from ffPackage with(nolock)
where SerialNumber = '000034072'

--Remove Package CurrentCount
Begin Tran
Update ffPackage
set CurrentCount = 0
where SerialNumber = '000034072'
Rollback Tran

SELECT * FROM ffUnitDetail WITH(NOLOCK)
WHERE InmostPackageID = '1017017'

--Remove Package ID assign to units
begin tran
update ffUnitDetail
set InmostPackageID = NULL,OutmostPackageID = NULL
WHERE UnitID IN (
'-2031490999',
'-2031490998',
'-2031490997',
'-2031490996',
'-2031490995',
'-2031490994',
'-2031490993',
'-2031490992',
'-2031490991',
'-2031490990',
'-2031490989',
'-2031490988',
'-2031490987',
'-2031490986',
'-2031490985',
'-2031490984',
'-2031490983',
'-2031490982',
'-2031490981',
'-2031490980',
'-2031636737',
'-2031636738',
'-2031636739',
'-2031636740',
'-2031636741',
'-2031636742',
'-2031636743',
'-2031636744',
'-2031636745',
'-2031636746',
'-2031636747',
'-2031636748',
'-2031636749',
'-2031636750',
'-2031636751',
'-2031636752',
'-2031636753',
'-2031636754',
'-2031636755',
'-2031636756')
Rollback tran







--2. Change the unit state for trays E0035771-J19 units to 9150 - Sterilization Beagle Test Pass or 9153 - Container Sample Dashboard


select * from ffSerialNumber with(nolock)
where Value = 'E0035771-J19'

select * from ffUnit with(nolock)
where PanelID = '-2136397809'

begin tran
Update ffUnit
set UnitStateID = 9150 -- 9153
where PanelID = '-2136397809'
Rollback tran

begin tran
Update ffUnit
set UnitStateID = 9150 -- 9153
where ID = '-2136397809'
Rollback tran


--3. Packout the unit in Station

--Staion: Sample: Create Shipper Box








