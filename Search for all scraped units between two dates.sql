
---------------------------How to count how many units there are per Work Order (based on specific filters [Scraped, from SMT, and between 10/1/2019 - 12/31/2019]) (#UnitQty)-----------------------
SELECT 
		COUNT(DISTINCT u.ID) UnitQty
		,po.ID WOID
INTO #UnitQty
FROM ffUnit u WITH(nolock)
INNER JOIN ffProductionOrder po ON po.ID = u.ProductionOrderID
LEFT OUTER JOIN ffPart p WITH(nolock) ON u.PartID = p.ID
LEFT OUTER JOIN luPartFamily pf WITH(nolock) ON pf.ID = p.PartFamilyID
WHERE u.StatusID = 3 AND pf.Name = 'PCA' AND (u.LastUpdate >= '2019-10-1 00:00:00' AND u.LastUpdate <= '2019-12-31 00:00:00')
GROUP BY po.ID
ORDER BY po.ID



--SELECT *
--FROM #UnitQty





----------------------Details of all SMT units that were scrapped between the given two dates (#BaseTable)------------
SELECT
		po.ID WOID
		,po.ProductionOrderNumber WO
		,l.Description WOLineID
		,p.ID PartID
		,p.PartNumber
		,p.Revision
		,u.UnitStateID
		,us.Description UnitState
		,s.ID StationID
		,s.Description Station
		,u.LastUpdate
		,datepart(year, u.LastUpdate) YearUnitLU
		,datepart(month, u.LastUpdate) MonthUnitLU
		,datepart(week, u.LastUpdate) WkUnitLU
		,datepart(day, u.LastUpdate) DayUnitLU
		,datepart(hour, u.LastUpdate) HRUnitLU
INTO #BaseTable
FROM ffUnit u WITH(nolock)
LEFT OUTER JOIN ffPart p WITH(nolock) ON u.PartID = p.ID
LEFT OUTER JOIN luPartFamily pf WITH(nolock) ON pf.ID = p.PartFamilyID
INNER JOIN ffProductionOrder po WITH(nolock) ON po.ID = u.ProductionOrderID
LEFT OUTER JOIN ffLine l WITH(nolock) ON l.ID = u.LineID
LEFT OUTER JOIN ffStation s WITH(nolock) ON s.ID = u.StationID
LEFT OUTER JOIN ffUnitState us WITH(nolock) ON u.UnitStateID = us.ID
WHERE u.StatusID = 3 AND pf.Name = 'PCA' AND (u.LastUpdate >= '2019-10-1 00:00:00' AND u.LastUpdate <= '2019-12-31 23:59:59.999')


--SELECT *
--FROM #BaseTable WITH(nolock)


------------------------------------Putting the Details and the amount scrapped together (#BaseTable and #UnitQty)-------------------

SELECT --TOP 30000
		bt.WOID
		,bt.WO
		,bt.WOLineID
		,bt.PartID
		,bt.PartNumber
		,bt.Revision
		,uq.UnitQty
		,bt.UnitStateID
		,bt.UnitState
		,bt.StationID
		,bt.Station
		,bt.LastUpdate
		,bt.YearUnitLU
		,bt.MonthUnitLU
		,bt.WkUnitLU
		,bt.DayUnitLU
		,bt.HRUnitLU
FROM #BaseTable bt WITH(nolock)
INNER JOIN #UnitQty uq WITH(nolock) ON uq.WOID = bt.WOID
GROUP BY bt.WOID
		,bt.WO
		,bt.WOLineID
		,bt.PartID
		,bt.PartNumber
		,bt.Revision
		,uq.UnitQty
		,bt.UnitStateID
		,bt.UnitState
		,bt.StationID
		,bt.Station
		,bt.LastUpdate
		,bt.YearUnitLU
		,bt.MonthUnitLU
		,bt.WkUnitLU
		,bt.DayUnitLU
		,bt.HRUnitLU
ORDER BY bt.LastUpdate





--DROP TABLE #BaseTable
--DROP TABLE #UnitQty