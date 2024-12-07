drop table if exists #Table

CREATE TABLE #Table
(
ID INT IDENTITY(1,1)
,SN VARCHAR(200))

udpMultipleScrap_GetSNInfo






select sn.Value AS [UID],us.Description as APPStatus,tsn.Value as TraySN,c.SerialNumber as CartSN,cpo.productionordernumber as AppPO,kpo.ProductionOrderNumber,ksn.value as KSN,kus.Description as KPUnitStatus,P.SerialNumber as Shipper,PP.SerialNumber AS Pallet into #t from ffSerialNumber sn
inner join ffUnit u with(nolock) on u.ID = sn.UnitID
inner join luUnitStatus us with(nolock) on us.ID = u.StatusID
inner join ffProductionOrder cpo with(nolock) on cpo.id = u.productionorderid
LEFT outer JOIN UDTTRAY T WITH(NOLOCK) ON T.UnitID = U.PanelID
left outer join ffSerialNumber tsn with(nolock) on tsn.UnitID = t.UnitID
LEFT outer JOIN udtCart C WITH(NOLOCK) ON C.ID = T.CartID
LEFT OUTER join ffUnitComponent uc with(nolock) on uc.ChildUnitID = u.ID
LEFT OUTER join ffUnit ku with(nolock) on ku.id = uc.UnitID
left outer join luUnitStatus kus with(nolock) on kus.ID = ku.StatusID
LEFT OUTER join ffUnitDetail ud with(nolock) on ud.unitid = ku.ID
left outer join ffSerialNumber ksn with(nolock) on ksn.unitid = ud.unitid
LEFT OUTER join ffProductionOrder kpo with(nolock) on kpo.ID = ku.ProductionOrderID
LEFT OUTER join ffPackage P WITH(NOLOCK) ON P.ID = UD.InmostPackageID
LEFT OUTER join ffPackage PP WITH(NOLOCK) ON PP.ID = UD.OutmostPackageID
where sn.Value in (select T.SN from #Table T)

--select * from #Table

SELECT * FROM #t