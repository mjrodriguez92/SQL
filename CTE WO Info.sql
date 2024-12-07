WITH cte_TrayInfo AS (
	 SELECT
	  t.ProductionOrderID TrayProductionOrderID
	 ,ut.ID TrayUID
	 ,tsn.Value TraySN
	 ,tus.ID TrayStatusID
	 ,tus.Description TrayStatus
	 ,tust.ID TrayUnitState
	 ,tust.Description TrayLocation
	FROM udtTray t
	JOIN ffProductionOrder tpo
	ON t.ProductionOrderID = tpo.ID
	LEFT OUTER JOIN ffSerialNumber tsn
	ON t.UnitID = tsn.UnitID --and sn.SerialNumberTypeID = 0
	LEFT OUTER JOIN ffUnit ut 
	ON tsn.UnitID = ut.ID
	LEFT OUTER JOIN luUnitStatus tus
	ON ut.StatusID = tus.ID
	LEFT OUTER JOIN ffUnitState tust
	ON ut.UnitStateID = tust.ID
	WHERE tsn.Value = 'A0108339-L19'),

cte_WorkOrder AS (
	 SELECT
	  po.ID ProductionOrderID
	 ,po.ProductionOrderNumber ProductionOrder
	 ,pf.Name PartFamily
	 FROM luPartFamily pf 
	 JOIN ffPart p 
	 ON p.PartFamilyID = pf.ID
	 LEFT OUTER JOIN ffProductionOrder po
	 ON p.ID = po.PartID
	 WHERE po.ProductionOrderNumber = 'A40002041'),

cte_UnitInfo AS (
	 SELECT
	  u.ProductionOrderID UnitProductionOrderID
	 ,sn.UnitID UnitID
	 ,sn.Value UnitSN
	 ,us.ID UnitStatusID
	 ,us.Description UnitStatus
	 ,ust.ID UnitState
	 ,ust.Description UnitLocation
	FROM ffUnit u 
	JOIN ffProductionOrder upo
	ON u.ProductionOrderID = upo.ID
	LEFT OUTER JOIN ffSerialNumber sn
	ON u.ID = sn.UnitID and sn.SerialNumberTypeID = 3
	LEFT OUTER JOIN luUnitStatus us
	ON u.StatusID = us.ID
	LEFT OUTER JOIN ffUnitState ust
	ON u.UnitStateID = ust.ID
	WHERE sn.Value = 'E007A00004BD1492')

	SELECT *
	--wo.ProductionOrder
	--,ti.TrayUID
	--,ti.TraySN
	--,ti.TrayStatusID
	--,ti.TrayStatus
	--,ti.TrayUnitState
	--,ti.TrayLocation
	--,ui.UnitID
	--,ui.UnitSN
	--,ui.UnitStatusID
	--,ui.UnitStatus
	--,ui.UnitState
	--,ui.UnitLocation
	FROM cte_WorkOrder wo
	LEFT OUTER JOIN cte_UnitInfo ui
	ON wo.ProductionOrderID = ui.UnitProductionOrderID
	LEFT OUTER JOIN cte_TrayInfo ti
	ON ui.UnitProductionOrderID = ti.TrayProductionOrderID









	--select top 10* from ffSerialNumber where SerialNumberTypeID = 3
	--Select TOP 10*
	--from luPartFamilyDetailDef pf with(nolock)

	
	
	
	
	
	
	
	
	
	
--	LEFT OUTER JOIN luPartFamily pf 
--	ON lfp.PartFamilyID = pf.ID
--	LEFT OUTER JOIN ffmaterialunitdetail mud 
--	ON MUD.MaterialUnitID = MU.ID
--	JOIN luMaterialUnitStatus ms 
--	ON ms.ID = mu.StatusID
--	WHERE mu.SerialNumber IN 
--	('35125513'
--	,'35125512'
--	,'35125493'
--	,'35125492'
--	,'35125441'
--	,'35125428'
--	,'35125430')),

--/*Grab WO & Top Level Part Data*/ 
--cte_ParentPartWO AS (
--	 SELECT DISTINCT
--	 po.ProductionOrderNumber WorkOrder
--	,ps.ParentPartID ParentPartID
--	,pp.PartNumber ParentPartNumber
--	,pp.Revision ParentRevision
--	,p.ID LidFoilPartID
--	,p.PartNumber LidFoilPartNumber
--	,p.Description LidFoilPartDesc
--	,p.Revision LidFoilRevision
--	FROM ffProductionOrder po
--	LEFT OUTER JOIN ffProductStructure ps 
--	ON po.PartID = ps.ParentPartID
--	LEFT OUTER JOIN ffMaterialUnit mu  
--	ON ps.PartID = mu.PartID
--	LEFT OUTER JOIN ffPart p 
--	ON mu.PartID = p.ID
--	LEFT OUTER JOIN ffPart pp 
--	ON po.PartID = pp.id
--	WHERE po.ProductionOrderNumber = 'C5B001421' AND p.ID = 7120)
--/* CTE Execution */
--	SELECT
--	 pwo.WorkOrder
--	,lf.MaterialUnitID
--	,lf.Skid 
--	,lf.LotCode
--	,pwo.ParentPartID
--	,pwo.ParentPartNumber
--	,pwo.ParentRevision
--	,pwo.LidFoilPartID 
--	,pwo.LidFoilPartNumber
--	,pwo.LidFoilPartDesc
--	,pwo.LidFoilRevision
--	,lf.LidFoilCreatDt
--	,lf.LidFoilLastUpdateDt
--	,lf.UseByDate
--	,lf.MuStatusID
--	,lf.LidFoilStatus
--	FROM cte_LidFoil lf
--	LEFT OUTER JOIN cte_ParentPartWO pwo 
--	ON lf.ChildPartID = pwo.LidFoilPartID 
--	ORDER BY 13 DESC