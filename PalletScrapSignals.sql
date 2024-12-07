select * from ffProductionOrder po with(nolock)
where po.ProductionOrderNumber in (
'KTP001456',--done

'KTP001275',
'KTP002446',
'KTP002452',
'KTP002521',
'KTP001114',--done
'KTP003114',--done
'KTP003314',--done
'KTP003651',--done
'KTP003714',--done
'KTP003109',--done
'KTP002520',--done
'KTP003313',--done
'KTP001182',--done
'KTP003201'--done
)
order by po.ActualStartTime

--KTP001275--done
--KTP002521--done
--KTP002452
--KTP002446--DONE

select distinct p.ID,p.SerialNumber,p.CurrentCount,po.ProductionOrderNumber from ffProductionOrder po with(nolock)
inner join ffPackage p with(nolock) on p.CurrProductionOrderID = po.ID
where po.ProductionOrderNumber in ('KTP002452')



update ffPackage
set CurrentCount = '8'
where ID in (
'2756817'
)

2756615
2756617
2756619
2756620
2756621
2756714
2756715
2756717
2756749
2756817


select distinct p.SerialNumber,p.CurrentCount,po.ProductionOrderNumber,ud.UnitID from ffProductionOrder po with(nolock)
inner join ffPackage p with(nolock) on p.CurrProductionOrderID = po.ID
inner join ffUnitDetail ud with(nolock) on ud.ProductionOrderID = po.ID
where po.ProductionOrderNumber in ('KTP002452')

select * from ffPackage
where SerialNumber = '01350217910008772130492630'

--UPDATE P
--SET P.CurrPartID='6739',CurrProductionOrderID='9900',CurrentCount='1080',StatusID=1,ParentID=NULL
--from ffPackage P
--where SerialNumber = '01350217910008772130492630'

--PartID 
BEGIN TRAN
UPDATE
UD
SET UD.InmostPackageID = null
FROM ffUnitDetail UD WITH(NOLOCK)
INNER JOIN ffUnit U WITH(NOLOCK) ON U.ID = UD.UnitID
WHERE U.StatusID <> 1 AND UD.InmostPackageID = 1716002
ROLLBACK TRAN
select * from ffPackage
where SerialNumber = '01350217910008772130492630'

--UPDATE P
--SET P.CurrPartID='7698',CurrProductionOrderID='9902',CurrentCount='80',StatusID=1,ParentID=NULL
--from ffPackage P
--where SerialNumber = '01350217910008772130492630'

SELECT *
from ffUnit u with(nolock)
inner join ffUnitDetail ud with(nolock) on ud.UnitID = u.ID
inner join ffProductionOrder po with(nolock) on po.ID = u.ProductionOrderID
where  po.ProductionOrderNumber = 'KTP002452' and u.StatusID = 1





update ffunit
set UnitStateID = 8005
where id in
('-1966027863',
'-1966027862',
'-1966027861',
'-1966027860',
'-1966027859',
'-1966027858',
'-1966027857',
'-1966027856',
'-1966027855',
'-1966027854',
'-1966027853',
'-1966027852',
'-1966027851',
'-1966027850',
'-1966027849',
'-1966027848',
'-1966027847',
'-1966027846',
'-1966027845',
'-1966027844',
'-1966027843',
'-1966027842',
'-1966027841',
'-1966027840',
'-1966027839',
'-1966027838',
'-1966027837',
'-1966027836',
'-1966027835',
'-1966027834',
'-1966027833',
'-1966027832',
'-1966027831',
'-1966027830',
'-1966027829',
'-1966027828',
'-1966027827',
'-1966027826',
'-1966027825',
'-1966027824',
'-1966026368',
'-1966026367',
'-1966026366',
'-1966026365',
'-1966026364',
'-1966026363',
'-1966026362',
'-1966026361',
'-1966026360',
'-1966026359',
'-1966026358',
'-1966026357',
'-1966026356',
'-1966026355',
'-1966026354',
'-1966026353',
'-1966026352',
'-1966026351',
'-1966026350',
'-1966026349',
'-1966026348',
'-1966026347',
'-1966026346',
'-1966026345',
'-1966026344',
'-1966026343',
'-1966026342',
'-1966026341',
'-1966026340',
'-1966026339',
'-1966026338',
'-1966026337',
'-1966026336',
'-1966026335',
'-1966026334',
'-1966026333',
'-1966026332',
'-1966026331',
'-1966026330',
'-1966026329',
'-1966027863',
'-1966027862',
'-1966027861',
'-1966027860',
'-1966027859',
'-1966027858',
'-1966027857',
'-1966027856',
'-1966027855',
'-1966027854',
'-1966027853',
'-1966027852',
'-1966027851',
'-1966027850',
'-1966027849',
'-1966027848',
'-1966027847',
'-1966027846',
'-1966027845',
'-1966027844',
'-1966027843',
'-1966027842',
'-1966027841',
'-1966027840',
'-1966027839',
'-1966027838',
'-1966027837',
'-1966027836',
'-1966027835',
'-1966027834',
'-1966027833',
'-1966027832',
'-1966027831',
'-1966027830',
'-1966027829',
'-1966027828',
'-1966027827',
'-1966027826',
'-1966027825',
'-1966027824',
'-1966026368',
'-1966026367',
'-1966026366',
'-1966026365',
'-1966026364',
'-1966026363',
'-1966026362',
'-1966026361',
'-1966026360',
'-1966026359',
'-1966026358',
'-1966026357',
'-1966026356',
'-1966026355',
'-1966026354',
'-1966026353',
'-1966026352',
'-1966026351',
'-1966026350',
'-1966026349',
'-1966026348',
'-1966026347',
'-1966026346',
'-1966026345',
'-1966026344',
'-1966026343',
'-1966026342',
'-1966026341',
'-1966026340',
'-1966026339',
'-1966026338',
'-1966026337',
'-1966026336',
'-1966026335',
'-1966026334',
'-1966026333',
'-1966026332',
'-1966026331',
'-1966026330',
'-1966026329')

