SELECT 
P.PartNumber, 
P.Revision,
lic.Qty AS 'Quantity',
lic.Src_Warehouse, 
lic.Dest_Warehouse, 
lic.Warehouse_Location,
po.ProductionOrderNumber,
sx.StatusID, 
s.StatusID,
s.SignalRefNumber,
s.CreateDt,
ls.StatusName AS 'SignalXMLStatus'
--, sx.content.value('ref2skid[1]', 'varchar(100)') FROM sx.Content.nodes ('stockpoint') a(b))
--, SELECT (a.b.value('ref2skid[1]', 'varchar(100)') FROM sx.Content.nodes ('stockpoint') a(b))
,ls1.StatusName AS 'SignalStatus'
FROM dbo.udtfbitLibreINVMOVCart lic
JOIN dbo.ffPart p ON lic.PartID = p.ID --AND p.PartNumber IN ('THRL-PRT23275-50', 'THRL-PRT23275-12')
LEFT JOIN dbo.ffProductionOrder po ON lic.ProductionOrderID = po.ID
JOIN dbo.fbitSignalXML sx ON lic.SignalXMLID = sx.id
INNER JOIN dbo.fbitSignal s ON sx.SignalID = s.id
JOIN dbo.fbitLuStatus ls ON sx.StatusID = ls.StatusID AND ls.TableName = 'fbitSignalXML'
JOIN dbo.fbitLuStatus ls1 ON s.StatusID = ls1.Statusid AND ls1.TableName = 'fbitSignal'
GROUP BY p.PartNumber, p.Revision, lic.qty, lic.Src_Warehouse, lic.Dest_Warehouse, lic.Warehouse_Location, po.ProductionOrderNumber,sx.StatusID, s.StatusID, s.SignalRefNumber, s.CreateDt, ls.StatusName, ls1.StatusName
ORDER BY p.PartNumber, s.CreateDt ASC

--SELECT * FROM udtfbitLibreINVMOVCart li

SELECT * FROM fbitSignalXML sx

SELECT * FROM udtCartHistory ch
SELECT * FROM udtCart c
WHERE c.SerialNumber = 'S-29190016'

SELECT * FROM udtfbitLibreINVMOVCart li WHERE li.Qty = 13

SELECT sn.value , u.* FROM ffUnit u
JOIN ffSerialNumber sn ON u.ID = sn.UnitID --AND sn.Value LIKE 'P-%'
WHERE u.StatusID = (SELECT id FROM luUnitStatus us WHERE us.Description = 'scrap')
AND u.EmployeeID <> 1000
AND u.ProductionOrderID IS NULL

SELECT * FROM udtfbitLibreINVMOV li
WHERE li.UnitID IN (-2147405806, -2147403340)

SELECT * FROM fbitSignalXML sx
WHERE id IN (36878, 36880)