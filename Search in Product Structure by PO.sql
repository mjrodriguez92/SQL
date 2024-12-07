

----------------- SEARCH ON PRODUCT STRUCTURE
SELECT DISTINCT 
wp.PartNumber + ' [' +  wp.Revision + ']' AS WOPN
,p.PartNumber + ' [' + p.Revision + ']' AS ComponentPN--, ps.PartPosition
--,wpdd.Description PartDetail 
--,wpd.Content PartDetailData
,ps.*
FROM ffProductionOrder po WITH(nolock)
INNER JOIN luProductionOrderStatus pos WITH(nolock) ON po.StatusID = pos.ID
LEFT OUTER JOIN ffPart wp WITH(nolock) ON po.PartID = wp.ID
LEFT OUTER JOIN ffProductStructure ps WITH(nolock) ON wp.ID = ps.ParentPartID
LEFT OUTER JOIN ffPart p WITH(nolock) ON ps.PartID = p.ID
LEFT OUTER JOIN ffPartDetail wpd WITH(nolock) ON  wp.ID = wpd.PartID
LEFT OUTER JOIN luPartFamilyDetailDef wpdd WITH(nolock) ON wpd.PartDetailDefID = wpdd.ID
where wp.PartNumber = 'THRL-ENGP-PRT28449-50' AND wp.Revision IN ('D')
	and p.PartNumber = 'THRL-PRT28449-750'


select * from ffProductStructure
WHERE ID = 4405

begin tran

	update ffProductStructure
	set PartPosition = 0
	WHERE ID = 4405	

	select * from ffProductStructure WHERE ID = 3912

rollback tran

SELECT * FROM ffPart WHERE ID = 5630

------------------- EBOM
SELECT DISTINCT
	po.ProductionOrderNumber WO, 
	po.OrderQuantity,
	pos.Description WOStatus, 
	wp.PartNumber + ' [' +  wp.Revision + ']' AS WOPN
	,wpf.Name WPartFamily
	--,wpd.Content
	--,wpdd.Description
	,p.PartNumber + ' [' + p.Revision + ']' AS ComponentPN, eb.PartPosition
	,pf.Name PartFamily
	--,pd.Content
	--,pdd.Description
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
WHERE po.ProductionOrderNumber IN ('S20000635','EOQ000438') AND
wp.PartNumber = 'THRL-PRT28449-750'
and p.PartNumber = 'THRL-PRT28449-50'




--SELECT * FROM fbitlusignaltype  

---- PRDBOM
SELECT 'PRDBOM' Signal, sxml.Content ,sxml.SignalTypeID ,st.Name ,sxml.StatusID ,stu.StatusName ,sxml.CreateDt ,fs.SignalRefNumber
	,fs.SignalTypeID
	,fr.ID ResponseID
	,fr.Content ResponseContent
	,fr.ToSignalRefNumber
	,fr.SignalRefNumber
FROM fbitSignalXML sxml WITH(nolock)
LEFT OUTER JOIN [fbitSignal] fs WITH(nolock) ON sxml.SignalID = fs.ID
LEFT OUTER JOIN fbitRESP fr WITH(nolock) ON fr.ToSignalRefNumber = fs.SignalRefNumber AND fr.ToSignalTypeID = fs.SignalTypeID
inner join fbitlusignaltype  st WITH(nolock) ON sxml.SignalTypeID = st.ID AND st.ID = 7 --PRDBOM
INNER JOIN fbitLuStatus stu WITH(nolock) ON sxml.StatusID = stu.ID
WHERE sxml.CreateDt >= '2020-09-05 00:00:00' AND  CAST(sxml.Content AS VARCHAR(MAX)) LIKE --'%EOQ000438%' --
	'%THRL-PRT28449-750%' --'%PLTK4400000297%'

--SELECT * FROM fbitlusignaltype  

--- ITMAML
SELECT 'ITMAML' Signal, sxml.Content ,sxml.SignalTypeID ,st.Name ,sxml.StatusID ,stu.StatusName ,sxml.CreateDt ,fs.SignalRefNumber
	,fs.SignalTypeID
	,fr.ID ResponseID
	,fr.Content ResponseContent
	,fr.ToSignalRefNumber
	,fr.SignalRefNumber
FROM fbitSignalXML sxml WITH(nolock)
LEFT OUTER JOIN [fbitSignal] fs WITH(nolock) ON sxml.SignalID = fs.ID
LEFT OUTER JOIN fbitRESP fr WITH(nolock) ON fr.ToSignalRefNumber = fs.SignalRefNumber AND fr.ToSignalTypeID = fs.SignalTypeID
INNER JOIN fbitlusignaltype  st WITH(nolock) ON sxml.SignalTypeID = st.ID AND st.ID =3 --ITMAML
INNER JOIN fbitLuStatus stu WITH(nolock) ON sxml.StatusID = stu.ID
WHERE sxml.CreateDt >= '2020-12-01 00:00:00' AND  
CAST(sxml.Content AS VARCHAR(MAX)) LIKE --'%EOQ000438%' --
	'%THRL-PRT28449%' --'%PLTK4400000297%'



------ ORDERBOOK
SELECT 'ORDERBOOK' Signal, sxml.Content ,sxml.SignalTypeID ,st.Name ,sxml.StatusID ,stu.StatusName ,sxml.CreateDt ,fs.SignalRefNumber
	,fs.SignalTypeID
	,fr.ID ResponseID
	,fr.Content ResponseContent
	,fr.ToSignalRefNumber
	,fr.SignalRefNumber
FROM fbitSignalXML sxml WITH(nolock)
LEFT OUTER JOIN [fbitSignal] fs WITH(nolock) ON sxml.SignalID = fs.ID
LEFT OUTER JOIN fbitRESP fr WITH(nolock) ON fr.ToSignalRefNumber = fs.SignalRefNumber AND fr.ToSignalTypeID = fs.SignalTypeID
inner join fbitlusignaltype  st WITH(nolock) ON sxml.SignalTypeID = st.ID AND st.ID =4 --ORDERBOOK
INNER JOIN fbitLuStatus stu WITH(nolock) ON sxml.StatusID = stu.ID
WHERE sxml.CreateDt >= '2020-11-01 00:00:00' AND  CAST(sxml.Content AS VARCHAR(MAX)) LIKE '%S20000635%' --
--	'%THRL-ENG-PRT28449-750%' --'%PLTK4400000297%'
