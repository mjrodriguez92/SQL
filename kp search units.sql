USE P_LIBRE_FF
GO

SELECT 
	pokit.ProductionOrderNumber KitpackWO
	,pkpal.SerialNumber AS KitpackPallet
	,'''' + pkbox.SerialNumber AS KitpackBox
	,'''' + snkit.Value KitpackSN
	,uckit.ChildUnitID
	,uckit.ChildSerialNumber
FROM ffPackage pkbox WITH(nolock)
LEFT OUTER JOIN ffUnitDetail udkit WITH(nolock) ON pkbox.ID = udkit.inmostpackageID 
LEFT OUTER JOIN ffpackage pkpal WITH(nolock) ON udkit.OutmostPackageID = pkpal.ID
lEFT OUTER JOIN ffUnit ukit WITH(nolock) ON udkit.UnitID = ukit.ID 
LEFT OUTER JOIN ffProductionOrder pokit WITH(nolock) ON ukit.ProductionOrderID = pokit.ID 
LEFT OUTER JOIN ffSerialNumber snkit WITH(nolock) ON ukit.ID = snkit.UnitID AND SUBSTRING(snkit.Value,1,1) = '3'  
LEFT OUTER JOIN ffUnitComponent uckit WITH(nolock) ON udkit.UnitID = uckit.UnitID
LEFT OUTER JOIN ffUnit ucon WITH(nolock) ON uckit.ChildUnitID = ucon.ID
WHERE pkbox.SerialNumber IN ('000013155','000013151','000013148')