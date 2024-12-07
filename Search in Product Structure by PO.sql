USE P_LIBRE_FF
GO 


----------------- SEARCH ON PRODUCT STRUCTURE
SELECT DISTINCT 
wp.PartNumber + ' [' +  wp.Revision + ']' AS WOPN
,p.PartNumber + ' [' + p.Revision + ']' AS ComponentPN, ps.PartPosition
,wpdd.Description PartDetail ,wpd.Content PartDetailData
FROM ffProductionOrder po WITH(nolock)
INNER JOIN luProductionOrderStatus pos WITH(nolock) ON po.StatusID = pos.ID
LEFT OUTER JOIN ffPart wp WITH(nolock) ON po.PartID = wp.ID
LEFT OUTER JOIN ffProductStructure ps WITH(nolock) ON wp.ID = ps.ParentPartID
LEFT OUTER JOIN ffPart p WITH(nolock) ON ps.PartID = p.ID
LEFT OUTER JOIN ffPartDetail wpd WITH(nolock) ON  wp.ID = wpd.PartID
LEFT OUTER JOIN luPartFamilyDetailDef wpdd WITH(nolock) ON wpd.PartDetailDefID = wpdd.ID
--WHERE --po.ProductionOrderNumber IN ('EOQ000376')
where wp.PartNumber = 'THRL-71635-01F-0001' AND wp.Revision IN ('C-2')--,'D')


----------------- EBOM
SELECT 
	po.ProductionOrderNumber WO, 
	po.OrderQuantity,
	pos.Description WOStatus, 
	wp.PartNumber + ' [' +  wp.Revision + ']' AS WOPN
	,wpf.Name WPartFamily
	,wpd.Content
	,wpdd.Description
	,p.PartNumber + ' [' + p.Revision + ']' AS ComponentPN, eb.PartPosition
	,pf.Name PartFamily
	,pd.Content
	,pdd.Description
FROM ffProductionOrder po WITH(nolock)
LEFT OUTER  JOIN luProductionOrderStatus pos WITH(nolock) ON po.StatusID = pos.ID
LEFT OUTER JOIN ffPart wp WITH(nolock) ON po.PartID = wp.ID
LEFT OUTER JOIN ffPartDetail wpd WITH(nolock) ON wp.ID = wpd.PartID
LEFT OUTER JOIN luPartDetailDef wpdd WITH(nolock) On wpd.PartDetailDefID = wpdd.ID
LEFT OUTER JOIN luPartFamily wpf WITH(nolock) ON wp.PartFamilyID = wpf.ID
LEFT OUTER JOIN ffEBOM eb WITH(nolock) ON po.ID = eb.ProductionOrderID
LEFT OUTER JOIN ffPart p WITH(nolock) ON eb.PartID = p.ID
LEFT OUTER JOIN ffPartDetail pd WITH(nolock) ON p.ID = pd.PartID
LEFT OUTER JOIN luPartFamily pf WITH(nolock) ON p.PartFamilyID = pf.ID
LEFT OUTER JOIN luPartDetailDef pdd WITH(nolock) On pd.PartDetailDefID = pdd.ID
WHERE po.ProductionOrderNumber IN ('KTP000012')

