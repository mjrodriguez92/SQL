declare @KitPackProdorder varchar(50)='KTP000241'


declare @conFamily int
select @conFamily=ID from lupartfamily where name ='CON'
declare @LAL int
select @LAL=ID  from luproductionorderdetaildef where description = 'LALOutcome'

drop table if exists #Data
select uc.id,uc.productionorderid into #Data from ffproductionorder po (nolock)
join ffunit uk (nolock)on uk.productionorderid=po.id
join ffunitcomponent ucom (nolock) on ucom.unitid=uk.id
join ffunit uc (nolock)on uc.id=ucom.childunitid
join ffpart p (nolock) on p.id=uc.partid and p.partfamilyid=@conFamily
join ffUnitDetail ud on ud.UnitID =uk.ID  and ud.InmostPackageID is not null
where po.productionordernumber=@KitPackProdorder


select distinct po.id,po.ProductionOrderNumber,pod.Content,'WITHOUT LAL' from #data d
join ffproductionorder po(NOLOCK) on po.id=d.productionorderid
left join ffproductionorderdetail pod(NOLOCK) on pod.productionorderid=d.productionorderid and pod.ProductionOrderDetailDefID=@LAL
where ISNULL(pod.Content,'Empty') <>'PASS'


drop table if exists #Failed
select d.ID, isnull(ud.reserved_24,'EMPTY') as [Status] into #Failed  from #data d
join ffunit u(NOLOCK) on u.id=d.id
left join ffUnitDetail ud(NOLOCK) on ud.unitid=u.id
where isnull(ud.reserved_24,'EMPTY') <> 'PASS'


select po.productionordernumber, sn.Value, [Status]  DoseStatus,'WITHOUT Proper DOSE' from ffUnit u (nolock)
join ffproductionorder po (nolock)on po.id=u.productionorderid
join ffSerialNumber sn (nolock)on sn.UnitID =u.ID
join #Failed f on f.id=u.id


select sn.Value  as SN,reserved_13,'Doesnt Have TrayFileName' as HasTrayFileName from #Data d 
join ffUnit u (nolock) on u.ID=d.ID 
join ffUnitDetail ud on ud.UnitID=u.ID 
join ffSerialNumber sn (nolock)on sn.UnitID =u.ID
where isnull(reserved_13,'') =''


select sn.Value as SN,us.Description as Status   from ffUnit u (nolock)
join  #Data d  on d.ID=u.id
join ffSerialNumber sn (nolock)on sn.UnitID =u.ID
join luUnitStatus us on us.ID=u.StatusID
where u.StatusID <>1
