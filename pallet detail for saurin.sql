--USE p_REP_LIBRE_FF
--GO

select
--''''+sn1.value as UnitSN,
po.ProductionOrderNumber as ProductionOrderNumber, -----ContainerWO
--po2.ProductionOrderNumber as KTPWO,
--''''+ip2.SerialNumber as KTPShipperBox,
sn.value as TraySN,  ---TrayNumber
po.CreationTime as WOCreationTime,
--count (u.id) Units,     
case when isnull(ud.reserved_07, '') = 'Y' then 'Retain'      when isnull(ud.reserved_30, '') = 'Y' then 'Clinical'      when isnull(ud.reserved_31, '') = 'Y' then 'Stability' else 'ZProduction' end As 'Type',
--US.description as UnitStatus,
--COUNT (SN.Value),
--po.expirydate as WOExpDate,

case when ud.Reserved_30 = 'Y' Then isnull(c.SerialNumber, '') ,
--when isnull(ud.reserved_31, '') = 'Y' then 'N/A' else isnull(c.SerialNumber, '') end As CartID       ,
isnull(p.serialnumber, '') as ContainerShipperBox     ,isnull(pp.serialnumber, '') As ContainerPallet,
''''+sn1.value as UnitSN
from ffunit u (nolock)
left outer join ffSerialNumber sn1 WITH(nolock) on sn1.UnitID = u.id and sn1.SerialNumberTypeID = 0
left outer join ffproductionorder po WITH(nolock) on po.id = u.productionorderid
left outer join ffMaterialUnit mu WITH(nolock) on mu.PartID = po.PartID
left outer join ffmaterialunitdetail mud on mud.MaterialUnitID = mu.ID
left join ffUnitComponent uc WITH(nolock) on uc.ChildUnitID = u.id
left join ffunit u2 WITH(nolock) on u2.id = uc.UnitID 
left outer join ffProductionOrder po2 WITH(nolock) on po2.id = u2.ProductionOrderID --KITWO
left outer join ffUnitDetail ud2 WITH(nolock) on ud2.UnitID = u2.id
left outer join ffPackage ip2 WITH(nolock) on ip2.id =ud2.InmostPackageID --KTP ShipperBox
left outer join ffPackage op2 WITH(nolock) on op2.id = ud2.OutmostPackageID
left outer join ffunitdetail ud (nolock)on u.id = ud.unitid   
left outer join udtTray t (nolock) on t.unitid = u.panelid    
left outer join ffserialnumber sn (nolock) on t.unitid = sn.unitid   
left outer join ffUnitState us (nolock) on u.UnitStateID = US.id     
left outer join udtCart c (nolock) on t.cartid = c.id  
left outer join ffpackage p (nolock) on ud.inmostpackageid = p.id --Container Shipper Box 
left outer join ffpackage pp (nolock) on ud.outmostpackageid = pp.id and ud.inmostpackageid <> ud.outmostpackageid
where po.productionordernumber in (select mud.Reserved_04  
from ffMaterialUnitDetail mud join ffMaterialUnit mu (nolock) on  mu.id=mud.MaterialUnitID and mu.LooperCount=mud.LooperCount where isnull(reserved_19,'')<>'')
AND  PP.SerialNumber = 'PLT00000005074'
--po2.productionordernumber in ('C5B000279')
--,'C5B000452','C5B000424','C5B000425')


--,
--'C5B000342',
--'C5B000343',
--'C5B000344',
--'C5B000345',
--'C5B000346',
--'C5B000347')


--p.SerialNumber in ('01350217917153512100098295',
--'01350217917153512100098292',
--'01350217917153512100098293',
--'01350217917153512100098296')

--AND po.ActualStartTime between '2020-09-01 00:00:00.000' and '2020-10-31 00:00:00.000'


group by sn1.value, po.ProductionOrderNumber,po2.ProductionOrderNumber, ip2.serialnumber, op2.serialnumber, sn.value, ud.reserved_07, 
ud.reserved_30, 
po.CreationTime,
ud.reserved_31, 
t.LastUpdate,
US.description, c.SerialNumber, p.SerialNumber, pp.SerialNumber order by [Type], t.LastUpdate asc
