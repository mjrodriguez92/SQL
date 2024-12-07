SELECT
	PO.ProductionOrderNumber PO
	, P1.SerialNumber Pallet
	, P.SerialNumber Shipper
	, SN.Value UnitSN
	, US.Description UnitStatus
	, CAST(us1.ID AS VARCHAR(10)) + ' [' + us1.Description + ']' AS UnitState
	, U.LastUpdate
	, UC.ChildSerialNumber AS 'ContainerSN'
	, UC1.ChildSerialNumber AS 'ApplicatorSN'
FROM 
	ffProductionOrder po WITH(NOLOCK)
	JOIN ffUnit u WITH(NOLOCK) ON PO.ID = U.ProductionOrderID
	JOIN ffSerialNumber sn WITH(NOLOCK) ON u.ID = SN.UnitID AND Sn.SerialNumberTypeID = 0
	JOIN ffUnitDetail ud WITH(NOLOCK) ON u.ID = UD.UnitID
	LEFT JOIN ffPackage p WITH(NOLOCK) ON UD.InmostPackageID = p.ID
	LEFT JOIN ffPackage p1 WITH(NOLOCK) ON P.ParentID = P1.ID
	JOIN ffLineOrder lo WITH(NOLOCK) ON po.ID = lo.ProductionOrderID
	JOIN luUnitStatus us WITH(NOLOCK) ON U.StatusID = US.ID
	JOIN ffUnitState us1 WITH(NOLOCK) ON U.UnitStateID = us1.ID
	LEFT JOIN ffUnitComponent uc WITH(NOLOCK) ON U.ID = uc.UnitID AND uc.ChildPartFamilyID IN (SELECT ID FROM luPartFamily WHERE Name = 'CON')
	LEFT JOIN ffUnitComponent uc1 WITH(NOLOCK) ON U.ID = uc1.UnitID AND uc1.ChildPartFamilyID IN (SELECT ID FROM luPartFamily WHERE Name = 'APP')
WHERE
	PO.ProductionOrderNumber = 'KTP002879' and us.Description like 'Scrap'
ORDER BY
	P1.ID DESC, P.ID DESC, U.id