SELECT 
	po.ProductionOrderNumber
	,po.PartID 
	,p.PartNumber 
	--,pd.PartDetailDefID
	--,pdd.Description 
FROM ffProductionOrder po WITH(nolock) 
INNER JOIN ffPart p WITH(nolock) ON p.ID = po.PartID
INNER JOIN ffPartDetail pd WITH(nolock) ON pd.PartID = p.ID
--INNER JOIN luPartDetailDef pdd WITH(nolock) ON pd.PartDetailDefID = pdd.ID
WHERE po.ProductionOrderNumber = 'A40000234'


SELECT *
FROM ffProductionOrder po WITH(nolock)
INNER JOIN ffUnit u WITH(nolock) ON po.ID = u.ProductionOrderID
INNER JOIN ffUnitDetail ud WITH(nolock) ON u.ID = ud.UnitID
INNER JOIN ffSerialNumber sn WITH(nolock) ON u.ID = sn.UnitID
WHERE po.ProductionOrderNumber = 'A40000234' AND Value = 'E007A00061817F53'


 

po.ProductionOrderNumber ,po.PartID ParentPartID
,wp.PartNumber + ' [' + wp.Revision + ']' ParentPartNumber
--,ps.*
,p.PartNumber + ' [' + p.Revision + ']' AS FirstLevelPN
FROM ffProductionOrder po WITH(nolock)
--INNER JOIN luProductionOrderStatus pos WITH(nolock) ON po.StatusID = pos.ID
LEFT OUTER JOIN ffPart wp WITH(nolock) ON po.PartID = wp.ID
LEFT OUTER JOIN ffProductStructure ps WITH(nolock) ON wp.ID = ps.ParentPartID
LEFT OUTER JOIN ffPart p WITH(nolock) ON ps.PartID = p.ID
--LEFT OUTER JOIN ffPartDetail wpd WITH(nolock) ON  wp.ID = wpd.PartID
--LEFT OUTER JOIN luPartFamilyDetailDef wpdd WITH(nolock) ON wpd.PartDetailDefID = wpdd.ID
where po.ProductionOrderNumber = 'A40000234'

SELECT 
	po.ID WOID 
	,po.ProductionOrderNumber WO
	,po.StatusID WOLineID 
	,po.PartID 
	,p.PartNumber
	,p.Revision
FROM ffProductionorder po WITH(nolock)
INNER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
WHERE po.Productionordernumber = 'S20000606' 




SELECT po.ID WOID
	,po.ProductionOrderNumber WO
	,l.Description WOLineID
	,p.ID PartID 
	,p.PartNumber
	,p.Revision
	,u.ID UnitQty
	,u.UnitStateID
	,us.Description UnitState
	,s.ID StationID
	,s.Description Station 
	,u.LastUpdate UnitLastUpdate
	,YEAR(u.LastUpdate) YearUnitLU
	,Month(u.LastUpdate) MonthUnitLU
	,DATEPART(Week,u.LastUpdate) WkUnitLU
	,DATEPART(Day,u.LastUpdate) DayUnitLU
	,DATEPART(Hour,u.LastUpdate) HrUnitLU 
FROM ffProductionOrder po WITH(nolock)
INNER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
INNER JOIN luPartFamily pf WITH(nolock) ON p.PartFamilyID = pf.ID
INNER JOIN ffUnit u WITH(nolock) ON p.ID = u.PartID
INNER JOIN ffStation s WITH(nolock) ON u.StationID = s.ID
INNER JOIN ffLine l WITH(nolock) ON u.LineID = l.id
INNER JOIN ffUnitState us WITH(nolock) ON u.UnitStateID = us.ID
WHERE u.LastUpdate BETWEEN '2019-10-01 00:00:00' AND '2019-12-31 00:00:00'   
and u.StatusID = 3
and pf.Name = 'PCA'
--and l.location = 'SMT'
--GROUP BY u.LastUpdate


SELECT * 
FROM ffProductionOrder po WITH(nolock)
WHERE   from_date >= '2019-10-01' AND
        to_date   <= '2019-12-31'
AND po.ProductionOrderNumber = 'S20000606'

SELECT h.* 
FROM ffHistory h WITH(nolock)
INNER JOIN ffProductionOrder wo WITH(nolock) ON h.UnitID = wo.ID
WHERE wo.ID = 4254



















