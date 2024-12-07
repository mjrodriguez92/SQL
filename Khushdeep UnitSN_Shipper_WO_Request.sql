USE p_REP_LIBRE_FF
GO


select distinct
''''+sn.Value as UnitSN,
sn2.Value as KitUnitSN,
po2.ProductionOrderNumber as KitWO,
''''+ip2.SerialNumber as ShipperBoxID,
op2.SerialNumber as PalletID


from ffUnitDetail ud
inner join ffunit u on u.id = ud.UnitID
inner join ffSerialNumber sn on sn.UnitID = u.id and sn.SerialNumberTypeID = 0
inner join ffStation s on s.id = u.StationID 
left join luUnitStatus us on us.id = u.StatusID
left join udtPelletTrayAssign upa on upa.PelletSN = ud.reserved_25 --or upa.PelletSN = ud.reserved_26
left join udtTrayPelletTestResults tpr on tpr.TrayPelletID = upa.ID
inner join ffProductionOrder po on po.id = u.ProductionOrderID --KitpackWO
left join ffpart p on p.ID = u.PartID
left join ffPackage ip1 on ip1.ID = ud.InmostPackageID
left join ffPackage op1 on op1.id = ud.OutmostPackageID
left join ffUnitComponent uc on uc.ChildUnitID = u.id
left join ffSerialNumber sn2 on sn2.unitid = uc.UnitID and sn.SerialNumberTypeID = 0
left join ffunit u2 on u2.id = uc.UnitID 
left join ffStation s2 on s2.ID = u2.StationID
left join ffUnitDetail ud2 on ud2.UnitID = u2.id
left join ffUnitState us2 on us2.ID = u2.UnitStateID
left join luUnitStatus u2s on u2s.ID = u2.StatusID-- Beagle status
inner join ffProductionOrder po2 on po2.id = u2.ProductionOrderID --ContainerWO
left join udtSensorData uds on uds.PartNumber = p.PartNumber
--left join ffMaterialUnitDetail mud on mud.Reserved_04 = uds.
left join ffPackage ip2 on ip2.id =ud2.InmostPackageID
left join ffPackage op2 on op2.id = ud2.OutmostPackageID
left join ffHistory h on h.UnitID = u.ID
left join ffUnitStatusHistory sh on sh.UnitID = u.ID
left join ffProductionOrder po3 ON h.ProductionOrderID = po3.ID
left JOIN ffStation st2 ON h.StationID = st2.ID
left join ffUnitState us3 on us3.ID = h.UnitStateID


left join udtTray t on t.unitid = u.PanelID
left join udtcart c on c.id = t.cartid
left join ffProductionOrder cpo on cpo.id = c.ProductionOrderID

WHERE sn.value in ('L2B22010129000141600072676')


---FOR APPLICATOR Shipper Box, Tray for Shipper Box----

select distinct snu.Value as SNID, box.SerialNumber as BoxID, p.SerialNumber as PalletID, o.ProductionOrderNumber as WO
  from ffProductionOrder o 
full join  ffunit u on o.ID = u.ProductionOrderID
full join ffSerialNumber snu on snu.UnitID = u.ID
full join ffunitdetail ud on u.ID = ud.UnitID and u.LooperCount = ud.LooperCount
full join ffpackage p on ud.OutMostPackageID = p.ID
full join ffpackage Box on ud.InMostPackageID = Box.ID
full JOIN udtTray t ON t.unitID = u.PanelID
full join ffSerialNumber va WITH(nolock)on va.UnitID = t.UnitID 
where snu.Value in ('L1B12010279000145600094492',
'L1B1201028900014610020139B',
'L1B1201027900014560009542E',
'L1B1201029900014610028626B',
'L1B12010279000145600094493',
'L1B12010289000146100202001',
'L1B12010279000145600096124')
