SELECT 
P.PartNumber, 
P.Revision,
COUNT (s1.UnitID) AS 'Quantity',
--li.Src_Warehouse, 
--li.Dest_Warehouse, 
--li.Warehouse_Location,
po.ProductionOrderNumber,
sx.StatusID, 
s.StatusID,
s.SignalRefNumber,
s.CreateDt,
ls.StatusName AS 'SignalXMLStatus'
--, sx.content.value('ref2skid[1]', 'varchar(100)') FROM sx.Content.nodes ('stockpoint') a(b))
--, SELECT (a.b.value('ref2skid[1]', 'varchar(100)') FROM sx.Content.nodes ('stockpoint') a(b))
,ls1.StatusName AS 'SignalStatus'
FROM dbo.udtfbitSFCCOM s1
JOIN dbo.ffPart p ON s1.PartID = p.ID --AND p.PartNumber IN ('THRL-PRT23275-50', 'THRL-PRT23275-12')
JOIN ffUnit u ON s1.UnitID = u.ID
LEFT JOIN dbo.ffProductionOrder po ON u.ProductionOrderID = po.ID
JOIN dbo.fbitSignalXML sx ON s1.SignalXMLID = sx.id
INNER JOIN dbo.fbitSignal s ON sx.SignalID = s.id
JOIN dbo.fbitLuStatus ls ON sx.StatusID = ls.StatusID AND ls.TableName = 'fbitSignalXML'
JOIN dbo.fbitLuStatus ls1 ON s.StatusID = ls1.Statusid AND ls1.TableName = 'fbitSignal'
GROUP BY p.PartNumber, p.Revision, po.ProductionOrderNumber,sx.StatusID, s.StatusID, s.SignalRefNumber, s.CreateDt, ls.StatusName, ls1.StatusName
ORDER BY p.PartNumber, s.CreateDt ASC