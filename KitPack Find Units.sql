SELECT FS.Value as Unit,
FS2.Value as UIDs,
sn3.Value as YellowBox,
PKG1.SerialNumber AS Pallet, PKG.SerialNumber AS Box,
PO.ProductionOrderNumber AS ApplicatorWO,
kpo.ProductionOrderNumber KitpackWO,
LUS.Description AS Status,
P.PartNumber,
S.Description as Station,
ST.Description as StationType
FROM ffUnit U


--SELECT TOP 10 * FROM ffUnitComponent
--SELECT TOP 10 * FROM ffUnitDetail

INNER JOIN ffSerialNumber FS WITH (NOLOCK) ON FS.UnitID = U.ID
inner join ffSerialNumber fs2 with(nolock) on fs2.UnitID = u.ID and fs2.SerialNumberTypeID = 3
INNER JOIN ffStation S WITH(NOLOCK) ON S.ID = U.StationID
inner join ffPart P with(nolock) on P.ID = U.PartID
inner join ffStationType ST with(nolock) on ST.ID = S.StationTypeID
inner join luUnitStatus LUS with(nolock) on LUS.ID = U.StatusID
inner join ffProductionOrder PO with(nolock) on PO.ID = U.ProductionOrderID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON U.ID = uc.ChildUnitID
left outer join ffUnitDetail ud with(nolock) on ud.UnitID = UC.UnitID 
left outer join ffSerialNumber sn3 with(nolock) on sn3.UnitID = ud.UnitID
left outer join dbo.ffPackage PKG ON PKG.ID = UD.InmostPackageID
left outer join dbo.ffPackage PKG1 ON PKG1.ID = UD.OutmostPackageID
LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID
LEFT OUTER JOIN ffSerialNumber ksn WITH(nolock) ON ku.ID = ksn.UnitID and ksn.SerialNumberTypeID = 0
LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID 
WHERE fs.Value IN (
'E007A00007068193',
'E007A00007068192')