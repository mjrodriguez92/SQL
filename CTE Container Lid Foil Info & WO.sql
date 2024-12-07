/*Request: Container supervisor needed the date/time of the skid last scanned on the machine for AAL08 in Container

****Note****   This is a Common Table Expression (CTE)
A Common Table Expression (CTE) is the result set of a query which exists 
temporarily and for use only within the context of a larger query. Much like 
a derived table, the result of a CTE is not stored and exists only for the duration of the query.

*/

/*Grab Lid Foil Data*/ 
WITH cte_LidFoil AS (
	 SELECT
     mu.ID MaterialUnitID
	,mu.SerialNumber Skid 
	,mud.Reserved_02 LotCode
    ,mu.PartID ChildPartID
	,lfp.PartNumber ChildPartNumber
	,lfp.Revision ChildRevision
	,lfp.Description ChildPartDescription
	,mu.CreationTime LidFoilCreatDt
	,mu.LastUpdate LidFoilLastUpdateDt
	,mud.Reserved_11 UseByDate
	,ms.ID MuStatusID
	,ms.Description LidFoilStatus
	FROM ffmaterialunit mu
	LEFT OUTER JOIN ffPart lfp 
	ON lfp.ID = MU.PartID
	LEFT OUTER JOIN luPartFamily pf 
	ON lfp.PartFamilyID = pf.ID
	LEFT OUTER JOIN ffmaterialunitdetail mud 
	ON MUD.MaterialUnitID = MU.ID
	JOIN luMaterialUnitStatus ms 
	ON ms.ID = mu.StatusID
	WHERE mu.SerialNumber IN 
	('35125513'
	,'35125512'
	,'35125493'
	,'35125492'
	,'35125441'
	,'35125428'
	,'35125430')),

/*Grab WO & Top Level Part Data*/ 
cte_ParentPartWO AS (
	 SELECT DISTINCT
	 po.ProductionOrderNumber WorkOrder
	,ps.ParentPartID ParentPartID
	,pp.PartNumber ParentPartNumber
	,pp.Revision ParentRevision
	,p.ID LidFoilPartID
	,p.PartNumber LidFoilPartNumber
	,p.Description LidFoilPartDesc
	,p.Revision LidFoilRevision
	FROM ffProductionOrder po
	LEFT OUTER JOIN ffProductStructure ps 
	ON po.PartID = ps.ParentPartID
	LEFT OUTER JOIN ffMaterialUnit mu  
	ON ps.PartID = mu.PartID
	LEFT OUTER JOIN ffPart p 
	ON mu.PartID = p.ID
	LEFT OUTER JOIN ffPart pp 
	ON po.PartID = pp.id
	WHERE po.ProductionOrderNumber = 'C5B001421' AND p.ID = 7120)
/* CTE Execution */
	SELECT
	 pwo.WorkOrder
	,lf.MaterialUnitID
	,lf.Skid 
	,lf.LotCode
	,pwo.ParentPartID
	,pwo.ParentPartNumber
	,pwo.ParentRevision
	,pwo.LidFoilPartID 
	,pwo.LidFoilPartNumber
	,pwo.LidFoilPartDesc
	,pwo.LidFoilRevision
	,lf.LidFoilCreatDt
	,lf.LidFoilLastUpdateDt
	,lf.UseByDate
	,lf.MuStatusID
	,lf.LidFoilStatus
	FROM cte_LidFoil lf
	LEFT OUTER JOIN cte_ParentPartWO pwo 
	ON lf.ChildPartID = pwo.LidFoilPartID 
	ORDER BY 13 DESC