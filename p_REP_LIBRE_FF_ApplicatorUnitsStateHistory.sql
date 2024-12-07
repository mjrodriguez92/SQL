USE p_REP_LIBRE_FF
GO


drop table if exists #MandatoryStates;

declare @ApplicatorOrderNumber varchar(50)='A40000739'
--'A40000382' System E Tray Sorter and RF Issues
--'A40000300' NO Upgrade using EBOM


if(not exists (select * from ffProductionOrder where ProductionOrderNumber =@ApplicatorOrderNumber))
begin 

	RAISERROR ('The order doesnt exists', 18, 5000) WITH NOWAIT
	return
end

if(not exists (select * from ffProductionOrder where ProductionOrderNumber =@ApplicatorOrderNumber and StatusID  in (4,5)))
begin 

	RAISERROR ('The order is not closed', 18, 5000) WITH NOWAIT
	return
end

create table  #MandatoryStates (id int identity(1,1),UnitStateID int ,StateName varchar(100),ColumnName varchar(120)) ;
declare @sqlcmd  varchar (max);
 /******************************Change Family************************************/
declare @Family varchar(3) = 'APP' 
/******************************Change Serial Number Type************************************/
declare @SNType int = 0
/******************************Insert per UnitState to analaze************************************/
--10,702,704,706,708,710,716,717,7000,7200,7600,2000102,11000,12900 

insert into #MandatoryStates (UnitStateID) values( 10 )
insert into #MandatoryStates (UnitStateID) values( 702 )
insert into #MandatoryStates (UnitStateID) values( 704 )
insert into #MandatoryStates (UnitStateID) values( 706 )
insert into #MandatoryStates (UnitStateID) values( 708 )
insert into #MandatoryStates (UnitStateID) values( 710 )
--insert into #MandatoryStates (UnitStateID) values( 716 )
--insert into #MandatoryStates (UnitStateID) values( 717 )
insert into #MandatoryStates (UnitStateID) values( 7000 )
--insert into #MandatoryStates (UnitStateID) values( 7200 )
--insert into #MandatoryStates (UnitStateID) values( 7600 )
insert into #MandatoryStates (UnitStateID) values( 2000102 )
--insert into #MandatoryStates (UnitStateID) values( 11000 )
--insert into #MandatoryStates (UnitStateID) values( 12900 )


/*
insert into #MandatoryStates (UnitStateID) values( 9000 )
insert into #MandatoryStates  (UnitStateID) values( 9150)
insert into #MandatoryStates  (UnitStateID) values( 9100)
--insert into #MandatoryStates  (UnitStateID) values( 9101)
insert into #MandatoryStates  (UnitStateID) values( 9600)
*/

declare @min int=1;
declare @max int;
declare @RaiseErrorMessage varchar(max)


select @max= max(id) from #MandatoryStates;
set  @sqlcmd   ='drop table if exists dbo.kaunits'+@family+' create table dbo.kaunits'+@family+' (ID int primary key,SN varchar(50), IsSystemE bit default 0 ,'
declare @unitstate int
declare @ColumnName varchar(128)
update #MandatoryStates set StateName= fis.Description, ColumnName= '['+Rtrim(ltrim(str(m.UnitStateID)))+ replace(fis.Description,' ','')+'] '
from #MandatoryStates m 
join ffunitstate fis (nolock) on fis.ID=m.UnitStateID


while(@min<=@max)
begin
	select @unitstate= UnitStateID,@ColumnName=ColumnName from #MandatoryStates where id = @min;
	set @sqlcmd= @sqlcmd+ ' '+ @ColumnName+ ' bit, ';
	set @min = @min+1;
end
set @sqlcmd= @sqlcmd+' );  

'
print @sqlcmd
exec( @sqlcmd)

--unitsapp

/******************************Change Units Candidates Query************************************/
set @sqlcmd ='
insert into dbo.kaunits'+@family+' (ID)
select u.id from ffunit u
join ffpart p on p.id=u.partid
join lupartfamily pf on pf.id=p.partfamilyid
 
join ffproductionorder po on po.id=u.productionorderid
where u.statusid <> 3 and pf.name = '''+@Family+ ''' and 
po.productionordernumber = '''+@ApplicatorOrderNumber+ '''

'

exec( @sqlcmd)
--select * from #MandatoryStates

set @min =1
while(@min<=@max)
begin
	select @unitstate= UnitStateID,@ColumnName=ColumnName from #MandatoryStates where id = @min;
	set @RaiseErrorMessage= 'Starting to update ' +@ColumnName
	RAISERROR (@RaiseErrorMessage, 0, 1) WITH NOWAIT

	set @sqlcmd ='

	

	update u set ' + @ColumnName + ' = 1
	from dbo.kaunits' +@family+ ' u 
	join ffhistory h on h.unitid =u.id and h.unitstateid= '+ str(@unitstate) + '




	'

	set @RaiseErrorMessage= @sqlcmd
	RAISERROR (@RaiseErrorMessage, 0, 1) WITH NOWAIT
	exec (@sqlcmd)

		set @RaiseErrorMessage= 'end to update ' +@ColumnName
	RAISERROR (@RaiseErrorMessage, 0, 1) WITH NOWAIT

	set @min = @min +1


end




  declare @familyAPP int
select @familyAPP = id from luPartFamily where name ='APP'
declare @familyPUCK int
select @familyPUCK = id from luPartFamily where name ='PUC'
declare @familyPCA int
select @familyPCA  = id from luPartFamily where name ='PCA'
declare @UCPUCKstation int
select @UCPUCKstation  = id from ffStationType where Description ='Puck Machine chk'

declare @UCSMTstation int
select @UCSMTstation  = id from ffStationType where Description ='UC_Panel_POC'




drop table if exists #PuckToAppllicatorUpgrade
--PUCK a APPLICATOR
select  
u.id as ApplicatorID,p2.PartNumber ApplicatorOrderEBOMPuckPN,pf.Name ApplicatorOrderEBOMFamily,p3.PartNumber PUCKtoAPPPNToUpgrade,pf2.Name  PUCKtoAPPFamilyToUpgrade

from ffunit u (nolock)
join dbo.kaunitsapp app on app.id =u.ID
join ffpart p (nolock)on p.id=u.partid and p.partfamilyid=@familyAPP
join ffProductionOrder po (nolock)on po.id=u.productionorderid
join ffebom e (nolock) on e.productionorderid=po.id
join ffpart p2 (nolock)on p2.ID=e.PartID  and p2.PartFamilyID =@familyPUCK
join ffhistory h (nolock) on h.unitid=u.id
join ffstation st (nolock)  on st.id=h.StationID
join ffstationtype stt (nolock)  on stt.id=st.StationTypeID and stt.id =@UCPUCKstation
join ffpart p3 (nolock) on p3.ID=h.PartID
--join ffSerialNumber sn (nolock)on sn.unitid=u.id
join luPartFamily pf (nolock) on pf.ID =p2.PartFamilyID
join luPartFamily pf2 (nolock) on pf2.ID =p3.PartFamilyID
where p2.PartNumber <>p3.PartNumber --and h.EnterTime >'2020-01-15'




drop table if exists #PCATOPUCUpgrade
--PCA a PUCK
select  
u.id as ApplicatorID,p2.PartNumber PuckOrderEBOMPuckPN,pf.Name PuckOrderEBOMFamily,p3.PartNumber PCAtoPUCPNToUpgrade,pf2.Name PCAtoPUCFamilyToUpgrade


from ffunit u (nolock)
join dbo.kaunitsapp app on app.id =u.ID
join ffpart p (nolock)on p.id=u.partid and p.partfamilyid=@familyPUCK
join ffProductionOrder po (nolock)on po.id=u.productionorderid
join ffebom e (nolock) on e.productionorderid=po.id
join ffpart p2 (nolock)on p2.ID=e.PartID  and p2.PartFamilyID =@familyPCA
join ffhistory h (nolock) on h.unitid=u.id
join ffstation st (nolock)  on st.id=h.StationID
join ffstationtype stt (nolock)  on stt.id=st.StationTypeID and stt.id =@UCSMTstation
join ffpart p3 (nolock) on p3.ID=h.PartID
--join ffSerialNumber sn (nolock)on sn.unitid=u.id
join luPartFamily pf (nolock) on pf.ID =p2.PartFamilyID
join luPartFamily pf2 (nolock) on pf2.ID =p3.PartFamilyID
where p2.PartNumber <>p3.PartNumber --and h.EnterTime >'2020-01-15'



set @sqlcmd =' 
update u set sn = sn.value, IsSystemE = case when left(sn.value,2) = ''l2''  then 1 else 0 end   
from  dbo.kaunits'+@family+' u
join ffserialnumber sn on sn.unitid=u.id and sn.serialnumbertypeid = '+ str(@SNType ) +'
'
print @sqlcmd
exec( @sqlcmd)

set @sqlcmd =' 
delete u
from  dbo.kaunits'+@family+' u
where not(
[10SNCreation] is null or
[702SMTSPITest-Pass] is null or
[704SMTAOI-Pass] is null or
(IsSystemE =1 and [706SMTRFPrograming-Pass] is null) or
[708SMTFTCTester-Pass] is null or
[710SMTTraySorter-Pass] is null or
[7000PuckUnitCreation] is null or
[2000102ApplicatorMachineUnitPass] is null 
)
'
print @sqlcmd
exec( @sqlcmd)




/*
select top 10  * from ffunit u (nolock)
join ffpart p (nolock)on p.id=u.partid and p.partfamilyid=@familyPUCK
join ffserialnumber sn on sn.UnitID=u.ID
join ffstation st (nolock)  on st.id=u.StationID
join ffstationtype stt (nolock)  on stt.id=st.StationTypeID and stt.id =@UCPUCKstation
*/






select  uu.*,po.ProductionOrderNumber,po.ActualFinishTime,snk.Value as KitPack, pok.ProductionOrderNumber 
,'INSERT INTO #TMP SELECT ''' + uu.SN + '''' SearchOnMDS
from dbo.kaunitsapp  uu
join ffUnit u on u.ID=uu.ID 
join ffproductionorder po on po.id=u.productionorderid

left join ffUnitComponent uc (nolock) on uc.childunitid=uu.id
left join ffUnit uk (nolock) on uk.ID=uc.UnitID
left join ffserialnumber snk on snk.UnitID =uk.id
left join ffproductionorder pok on pok.id=uk.productionorderid
