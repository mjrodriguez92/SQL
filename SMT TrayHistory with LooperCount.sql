SELECT sn.Value TraySN,ln.Description Line,tu.UnitStateID TrayUnitStateID ,us.Description TrayUnitState ,MAX(th.LastUpdate) LastUpdate ,COUNT(th.LastUpdate) LooperCount
from udtTray t
INNER JOIN ffSerialNumber sn WITH(NOLOCK) ON sn.UnitID = t.UnitID
LEFT OUTER JOIN udtTrayHistory th WITH(nolock) ON t.UnitID = th.UnitID
INNER JOIN ffUnit tu WITH(nolock) ON t.UnitID = tu.ID
INNER JOIN ffUnitState us WITH(NOLOCK) ON us.ID = tu.UnitStateID
INNER JOIN ffLine ln with(nolock) on ln.ID = tu.LineID
WHERE sn.Value LIKE 'S0%'
GROUP BY sn.Value,tu.UnitStateID , us.Description, ln.Description


