

drop table if exists #applicatorsinkitpackOrder
select u.ID Applicator 
into #applicatorsinkitpackOrder 
from ffunit u(nolock)
join ffProductionOrder apo (nolock) ON u.ProductionOrderID = apo.ID
join ffunitcomponent uc(nolock) on uc.ChildUnitID=u.id
join ffunit uk (nolock)on uk.id=uc.unitid
join ffproductionorder po (nolock)on po.id=uk.productionorderid
join ffPart p(nolock) on p.ID=u.PartID 
join luPartFamily pf (nolock)on pf.ID =p.PartFamilyID 
where pf.Name='APP' 
AND	po.ProductionOrderNumber = 'po'



drop table if exists #PNLessThan2Applicators 
select
u.ID as AplicatorID,
count(distinct ph.ID) ApplicatorPartNumberCount
into #PNLessThan2Applicators
from ffunit u (nolock) 
join #applicatorsinkitpackOrder app on app.Applicator =u.ID
join ffPart p (nolock) on p.ID=u.PartID
join luPartFamily pf (nolock) on pf.id=p.partfamilyid 
join ffhistory h (nolock)on h.unitid=u.id
join ffPart ph (nolock) on ph.ID=h.PartID
where  pf.Name='APP' 
group by u.ID
having  count( distinct ph.ID) <3


drop table if exists #ScrappedinStatuSHistoryApplicators 
select
u.ID as AplicatorID,
max(sh.UnitStatusID)  'MaxStatus',
sta.Description as ScrapStation,stt.Description as ScrapStationType
into #ScrappedinStatuSHistoryApplicators
from ffunit u (nolock) 
join #applicatorsinkitpackOrder app on app.Applicator =u.ID
join ffPart p (nolock) on p.ID=u.PartID
join luPartFamily pf (nolock) on pf.id=p.partfamilyid 
join ffUnitStatusHistory sh(nolock)  on sh.unitid=u.id and sh.UnitStatusID <>0--<>Processing
join ffStation sta (nolock) on sta.ID = sh.StationID 
join ffStationType stt (nolock)on stt.id=sta.stationtypeid
where  pf.Name='APP'  and
 stt.id not in (289,290)--KP_UC_Assy_Interim,KP_UC_Assy_Pack_Report
 and u.StatusID <>3
group by u.ID,sta.Description ,stt.Description 
having max(sh.UnitStatusID)=3



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
into #PuckToAppllicatorUpgrade
from ffunit u (nolock)
join #applicatorsinkitpackOrder app on app.Applicator =u.ID
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
select  u.id as ApplicatorID,p2.PartNumber PuckOrderEBOMPuckPN,pf.Name PuckOrderEBOMFamily,p3.PartNumber PCAtoPUCPNToUpgrade,pf2.Name PCAtoPUCFamilyToUpgrade
into #PCATOPUCUpgrade
from ffunit u (nolock)
join #applicatorsinkitpackOrder app on app.Applicator =u.ID
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








drop table if exists #FullJoin1
  select isnull(sh.AplicatorID,pn.AplicatorID) as ApplicatorID,sh.MaxStatus,pn.ApplicatorPartNumberCount,ScrapStation,ScrapStationType into #FullJoin1
  from #ScrappedinStatuSHistoryApplicators sh 
  full outer join  #PNLessThan2Applicators pn on pn.AplicatorID =sh.AplicatorID
  order by sh.AplicatorID desc

  drop table if exists #FullJoin2
  select isnull(f1.ApplicatorID,au.ApplicatorID) as ApplicatorID,f1.MaxStatus,f1.ApplicatorPartNumberCount,ScrapStation,ScrapStationType,au.ApplicatorOrderEBOMFamily,au.ApplicatorOrderEBOMPuckPN,au.PUCKtoAPPFamilyToUpgrade,au.PUCKtoAPPPNToUpgrade into #FullJoin2
  from #FullJoin1 f1
  full outer join  #PuckToAppllicatorUpgrade au on au.ApplicatorID =f1.ApplicatorID
  order by f1.ApplicatorID desc

 
   drop table if exists #FullJoin3
  select isnull(f2.ApplicatorID,au.ApplicatorID) as ApplicatorID,f2.MaxStatus,f2.ApplicatorPartNumberCount,ScrapStation,ScrapStationType,f2.ApplicatorOrderEBOMFamily,f2.ApplicatorOrderEBOMPuckPN,f2.PUCKtoAPPFamilyToUpgrade,f2.PUCKtoAPPPNToUpgrade,au.PCAtoPUCFamilyToUpgrade,au.PCAtoPUCPNToUpgrade,au.PuckOrderEBOMFamily,au.PuckOrderEBOMPuckPN into #FullJoin3
  from #FullJoin2 f2
  full outer join  #PCATOPUCUpgrade au on au.ApplicatorID =f2.ApplicatorID
  order by f2.ApplicatorID desc



    drop table if exists #PucOrder
  select  distinct fj.applicatorid, po.productionordernumber PucOrder  into #PucOrder from #FullJoin3 fj 
  join ffUnit u (nolock)on  u.id=fj.applicatorid
  join ffhistory h (nolock) on h.unitid=u.id
    join ffproductionorder po(nolock) on po.id=h.productionorderid
  join ffpart p (nolock)  on p.id=po.partid
  join lupartfamily pf(nolock) on pf.id=p.partfamilyid
  where pf.name='PUC'
  order by  fj.applicatorid
  

     drop table if exists #SMTOrder
  select  distinct fj.applicatorid, po.productionordernumber SMTOrder into #SMTOrder from #FullJoin3 fj 
  join ffUnit u (nolock)on  u.id=fj.applicatorid

  join ffhistory h (nolock) on h.unitid=u.id
    join ffproductionorder po(nolock) on po.id=h.productionorderid
  join ffpart p (nolock)  on p.id=po.partid
  join lupartfamily pf(nolock) on pf.id=p.partfamilyid
  where pf.name='PCA'
  order by  fj.applicatorid
  --group by po.productionordernumber




     drop table if exists #FinalRawData
  select f3.ApplicatorID as ApplicatorID,MaxStatus,ApplicatorPartNumberCount,ScrapStation,ScrapStationType,ApplicatorOrderEBOMFamily,ApplicatorOrderEBOMPuckPN,
  PUCKtoAPPFamilyToUpgrade,PUCKtoAPPPNToUpgrade,PCAtoPUCFamilyToUpgrade,PCAtoPUCPNToUpgrade,PuckOrderEBOMFamily,PuckOrderEBOMPuckPN,au.PucOrder,au2.SMTOrder into #FinalRawData
  from #FullJoin3 f3
  left join  #PucOrder au on au.ApplicatorID =f3.ApplicatorID
  left join  #SMTOrder au2 on au2.ApplicatorID =f3.ApplicatorID
  order by f3.ApplicatorID desc




select sn.Value,--ba.*,
PO.productionordernumber as ApplicatorOrder,
PucOrder as PuckOrder,
SMTOrder as SMTOrder,
case when maxstatus is null then 'No' else 'Yes' end as wasScrapped,
ScrapStation,ScrapStationType,
case when ApplicatorPartNumberCount is null then 'No' else 'Yes' end as HasOnly2Upgrades,
case when ApplicatorOrderEBOMFamily is not null then FORMATMESSAGE('PNEbom: %s FamilyEbom: %s PNOrigin: %s FamilyOrigin: %s' ,ApplicatorOrderEBOMPuckPN,ApplicatorOrderEBOMFamily,PUCKtoAPPPNToUpgrade,PUCKtoAPPFamilyToUpgrade) else '' end as InvalidPuckToApplicatorUpgrade,
case when PCAtoPUCFamilyToUpgrade is not null then FORMATMESSAGE('PNEbom: %s FamilyEbom: %s PNOrigin: %s FamilyOrigin: %s' ,PuckOrderEBOMPuckPN,PuckOrderEBOMFamily,PCAtoPUCPNToUpgrade,PCAtoPUCFamilyToUpgrade) else '' end as InvalidPuckToApplicatorUpgrade,														
snk.Value as KitPackSN,
stk.Description KitPackStatus,
--uk.ID as KitPackUnitID,
pok.ProductionOrderNumber ,
PS.SERIALNUMBER ShipperSN,
PP.SERIALNUMBER PalletSN,
UDI.SentDate 'UDIReportSendDate'

from #FinalRawData ba
join ffUnit u (nolock) on u.ID=ba.ApplicatorID
join ffSerialNumber sn (nolock) on sn.UnitID=u.ID and sn.SerialNumberTypeID =3
left join ffProductionOrder po (nolock) on po.id=u.ProductionOrderID
left join ffunitcomponent uc (nolock) on uc.ChildUnitID=ba.ApplicatorID
left join ffUnit uk  (nolock)on uk.ID=uc.UnitID
left join luunitstatus stk (nolock) on stk.id=uk.StatusID
left join ffUnitDetail ud(nolock) on ud.unitid=uk.id
left join ffpackage ps (nolock)on ps.id=ud.inmostpackageid
left join ffpackage pp (nolock)on pp.id=ud.outmostpackageid
left join ffSerialNumber snk(nolock) on snk.UnitID=uk.ID 
left join ffProductionOrder pok (nolock) on pok.id=uk.ProductionOrderID
left join udtUDIData udi (nolock)  on udi.SERIAL=snk.Value and udi.LOT =pok.ProductionOrderNumber
 where u.StatusID <>3


