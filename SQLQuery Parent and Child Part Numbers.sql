----------------- SEARCH ON PRODUCT STRUCTURE
SELECT DISTINCT 
--wp.PartNumber + ' [' +  wp.Revision + ']' AS WOPN
--,p.PartNumber + ' [' + p.Revision + ']' AS ComponentPN--, ps.PartPosition
----,wpdd.Description PartDetail 
----,wpd.Content PartDetailData
 

po.ProductionOrderNumber ,po.PartID ParentPartID
,wp.PartNumber + ' [' + wp.Revision + ']' ParentPartNumber
--,ps.*
,p.PartNumber + ' [' + p.Revision + ']' AS FirstLevelPN
,fp.PartNumber + ' [' + fp.Revision + ']' AS SecondLevelPN
--,tp.PartNumber + ' [' + tp.Revision + ']' AS ThirdLevelPN
FROM ffProductionOrder po WITH(nolock)
--INNER JOIN luProductionOrderStatus pos WITH(nolock) ON po.StatusID = pos.ID
LEFT OUTER JOIN ffPart wp WITH(nolock) ON po.PartID = wp.ID
LEFT OUTER JOIN ffProductStructure ps WITH(nolock) ON wp.ID = ps.ParentPartID
--LEFT OUTER JOIN ffChildProductStructure cps WITH(nolock) ON wp.ID = ps.ChildPartID
--LEFT OUTER JOIN ffSecondChildProductStructure scps WITH(nolock) ON wp.ID = ps.SecondChildPartID
LEFT OUTER JOIN ffPart p WITH(nolock) ON ps.PartID = p.ID
LEFT OUTER JOIN ffPart fp WITH(nolock) ON ps.PartID = fp.ID --AND ffPartID LIKE 'THRL-PRT23207-753A [A]'
--LEFT OUTER JOIN ffPart tp WITH(nolock) ON ps.PartID = tp.ID
--LEFT OUTER JOIN ffPartDetail wpd WITH(nolock) ON  wp.ID = wpd.PartID
--LEFT OUTER JOIN luPartFamilyDetailDef wpdd WITH(nolock) ON wpd.PartDetailDefID = wpdd.ID
where po.ProductionOrderNumber = 'A40000234'


SELECT DISTINCT
po.ProductionOrderNumber ,po.PartID ParentPartID
,wp.PartNumber + ' [' + wp.Revision + ']' ParentPartNumber
--,ps.*
,p.PartNumber + ' [' + p.Revision + ']' AS FirstLevelPN
,ISNULL(pa.PartNumber + ' [' + pa.Revision + ']', 'N/A') AS SecondLevelPN
--,pat.PartNumber + ' [' + pat.Revision + ']' AS ThirdLevelPN
FROM ffProductionOrder po WITH(nolock)
--INNER JOIN luProductionOrderStatus pos WITH(nolock) ON po.StatusID = pos.ID
LEFT OUTER JOIN ffPart wp WITH(nolock) ON po.PartID = wp.ID
LEFT OUTER JOIN ffProductStructure ps WITH(nolock) ON wp.ID = ps.ParentPartID
LEFT OUTER JOIN ffPart p WITH(nolock) ON ps.PartID = p.ID
LEFT OUTER JOIN ffProductStructure pss WITH(nolock) ON p.ID = pss.ParentPartID
LEFT OUTER JOIN ffPart pa WITH(nolock) ON pss.PartID = pa.ID
--LEFT OUTER JOIN ffProductStructure pssa WITH(nolock) ON p.ID = pssa.ParentPartID
--LEFT OUTER JOIN ffPart pat WITH(nolock) ON pssa.PartID = pat.IDZ
--where po.ProductionOrderNumber = 'A40000234'
where po.ProductionOrderNumber = 'A40000234'--and (pss.ParentPartID = 2014 or pss.ParentPartID = 2065)