SELECT
po.ProductionOrderNumber WO
,c.SerialNumber CartID
,tsn.value TraySN
,u.ID UnitID
,sn.value UnitSN
,u.StatusID UnitStatusID
,us.Description UnitStatus
,u.UnitStateID
,ust.Description UnitState
FROM ffProductionOrder po WITH(nolock)
INNER JOIN ffUnit u WITH(nolock) ON po.ID = u.ProductionOrderID
INNER JOIN luUnitStatus us WITH(nolock) ON u.StatusId = us.ID
INNER JOIN ffUnitState ust WITH(nolock) ON u.UnitStateID = ust.ID
INNER JOIN ffSerialNumber sn WITH(nolock) ON u.ID = sn.UnitID AND sn.SerialNumberTypeID = 0
INNER JOIN ffSerialNumber tsn WITH(nolock) ON u.PanelID = tsn.UnitID
LEFT OUTER JOIN udtTray t WITH(nolock) ON u.PanelID = t.UnitID
LEFT OUTER JOIN udtCart c WITH(nolock) ON t.CartID = c.ID
WHERE po.ProductionOrderNumber = 'S20000605'
and tsn.value = ''