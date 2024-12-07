--SELECT HashCode ,ClientName ,Count(clientName)--FROM #Api--WHERE Response LIKE '%critical%'--GROUP BY HashCode ,ClientName


select *
from ffpackage p with(nolock)
where SerialNumber in ('PLTK2145000548')

select * from luPackageStatus

select * from ffPackageHistory with(nolock)
where PackageID in (506104)

select * from ffEmployee with(nolock) where Firstname like '%amir%'

select * from ffstation with(nolock) where ID in (513,661)

begin tran

update ffPackage
set StatusID = 0
where SerialNumber in ('PLTK3100000280')
insert into ffPackageHistory select 506104,0,513,1191, GETDATE()

rollback tran