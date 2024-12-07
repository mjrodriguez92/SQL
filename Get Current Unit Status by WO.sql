--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- BY CURRENT UNIT STATUS---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE #T
GO

SELECT u.ID UnitID ,sn.Value UnitSN ,us.Description UnitStatus ,u.UnitStateID ,ust.Description UnitState ,SN.SerialNumberTypeID ,u.StationID 
	,s.Description Station ,st.Description StationType 
	,u.CreationTime ,u.LastUpdate ,u.ProductionOrderID ,po.ProductionOrderNumber ,SUBSTRING(ud.reserved_14,1,12) [Tray] ,CASE WHEN ud.reserved_19 IS NULL THEN 'No Sample' ELSE 'Sample' END [Sample] ,ud.InmostPackageID ,''''+pBox.SerialNumber BoxSN ,ud.OutmostPackageID ,pPallet.SerialNumber PalletSN
INTO #T
FROM ffUnit u WITH(nolock)
INNER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
INNER JOIN luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
INNER JOIN ffUnitState ust WITH(nolock) ON u.UnitStateID = ust.ID
INNER JOIN ffStation s WITH(nolock) ON u.StationID = s.ID
INNER JOIN ffStationType st WITH(nolock) ON s.StationTypeID = st.ID
INNER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
INNER JOIN ffSerialNumber sn WITH(nolock) ON u.ID = sn.UnitID
INNER JOIN ffPart p WITH(nolock) ON u.PartID = p.ID
LEFT OUTER JOIN ffPackage pBox WITH(nolock) ON ud.InmostPackageID = pBox.ID
LEFT OUTER JOIN ffPackage pPallet WITH(nolock) ON ud.OutmostPackageID = pPallet.ID
WHERE po.ProductionOrderNumber = 'K60000044' 

SELECT DISTINCT '''' + UnitSN AS UnitSN ,* 
FROM #T
WHERE SerialNumberTypeID = 0 --and UnitStatus = 'Scrap'


