WITH cte_GetInfo AS(
SELECT Distinct
po.ProductionOrderNumber WO
,c.SerialNumber CartID
,tsn.value TraySN
,tsn.UnitID TrayUID
,t.LastUpdate 
--,usn.Value UnitSN
--,usn.UnitID UnitID
,u.StatusID UnitStatusID
,us.Description UnitStatus
,u.UnitStateID UnitStateID
,ust.Description UnitState
--,mu.SerialNumber
--,mu.ID
FROM ffProductionOrder po 
INNER JOIN ffUnit u ON po.ID = u.ProductionOrderID
INNER JOIN luUnitStatus us ON u.StatusId = us.ID
INNER JOIN ffUnitState ust ON u.UnitStateID = ust.ID
INNER JOIN ffSerialNumber sn ON u.PanelID = sn.UnitID 
INNER JOIN ffSerialNumber tsn ON u.PanelID = tsn.UnitID
LEFT OUTER JOIN ffSerialNumber usn ON usn.UnitID = u.ID and usn.SerialNumberTypeID = 0
LEFT OUTER JOIN udtTray t ON u.PanelID = t.UnitID
LEFT OUTER JOIN udtCart c ON t.CartID = c.ID
--LEFT OUTER JOIN ffMaterialUnit mu with(nolock) on c.MaterialUnitID = mu.ID
WHERE tsn.Value IN ('A0223614-M21',
'A0224068-M21',
'A0219377-K21',
'A0085358-K19',
'A0018255-H19',
'A0151834-C20',
'A0128421-M19',
'A0059996-K19',
'A0040428-J19',
'A0059815-K19',
'A0246088-B22',
'A0246087-B22',
'A0012238-G19',
'A0085444-K19',
'A0246075-B22',
'A0221747-L21',
'A0150728-C20',
'A0235396-A22',
'A0224316-M21',
'A0223789-M21',
'A0131891-A20',
'A0011741-G19',
'A0157195-J20',
'A0081644-K19',
'A0041893-J19',
'A0221399-L21',
'A0077917-K19',
'A0088448-K19',
'A0084740-K19'
))

SELECT * FROM cte_GetInfo
