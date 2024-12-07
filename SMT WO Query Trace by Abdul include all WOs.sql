/*
Need puck  work orders ran on all lines from 28th January 2022 till today and how many of these work orders
consumed in applicator and applicator to kitpack. So basically need puck order numbers, applicators work order 
numbers which consumed the said puck work orders 
and also kit pack work orders if they have consumed the said puck work orders. Please send all the information in excel.
*/


/*
Options:
     Is this a request to fix something that is broken or not working as expected? = No
     Open on behalf of = Ranjith Pallath
     Describe the request = Request to identify the Applicator and the KP WOs (Puck WO, APP WO, KP WO. ) that have consumed the following:

P30001143, P30001136, P30001142, P30001137
A40001470, A40001471.
*/

--USE P_REP_LIBRE_FF
--GO


DROP TABLE #History
GO

DROP TABLE #A
GO

SELECT hh.UnitID ,hh.ProductionOrderID ,MAX(hh.ID) HistoryID
INTO #History
FROM ffHistory hh WITH(nolock)
WHERE UnitID IN 
(
	SELECT h.UnitID FROM ffHistory h WITH(nolock)
	WHERE h.ProductionOrderID IN 
	(
		SELECT po.ID WOID -- ,po.ProductionOrderNumber 
		FROM ffProductionOrder po WITH(nolock) 
		INNER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
		INNER JOIN luPartFamily pf WITH(nolock) ON p.PartFamilyID = pf.ID
		WHERE pf.Name = 'PCA' and po.ProductionOrderNumber = 'S20001464'
	) --and h.EnterTime > '2022-01-28 00:00:00.000' and h.UnitStateID = '7000'
)
GROUP BY hh.UnitID ,hh.ProductionOrderID


--SELECT * 
--FROM #History h
--INNER JOIN ffSerialNumber sn WITH(nolock) ON h.UnitID = sn.UnitID AND sn.SerialNumberTypeID = 3
--WHERE h.UnitID = -2090967637


SELECT h.unitID, 
		MAX(CASE WHEN PartFamily = 'APP' THEN h.ProductionOrderNumber END) ApplicatorWO,
		MAX(CASE WHEN PartFamily = 'APP' THEN h.WOID END) ApplicatorWOID,
		MAX(CASE WHEN PartFamily = 'PUC' THEN h.ProductionOrderNumber END) PuckWO,
		MAX(CASE WHEN PartFamily = 'PUC' THEN h.WOID END) PuckWOID,
		MAX(CASE WHEN PartFamily = 'PCA' THEN h.ProductionOrderNumber END) SMTWO,
		MAX(CASE WHEN PartFamily = 'PCA' THEN h.WOID END) SMTWOID
INTO #A
FROM (
SELECT h.UnitID ,H.HistoryID ,po.ID WOID ,po.ProductionOrderNumber, pf.Name PartFamily, ROW_NUMBER() OVER(PARTITION BY h.UnitID ORDER BY h.HistoryID DESC) AS HOrder
FROM #History h
INNER JOIN ffSerialNumber sn WITH(nolock) ON h.UnitID = sn.UnitID AND sn.SerialNumberTypeID = 3
INNER JOIN ffProductionOrder po WITH(nolock) ON h.ProductionOrderID = po.ID
INNER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
INNER JOIN luPartFamily pf WITH(nolock) ON p.PartFamilyID = pf.ID
) h
GROUP BY h.UnitID 

--SELECT * FROM #A WHERE UnitID = -2090967637



SELECT DISTINCT asn.Value as SN,ap.CreationTime,s.Description as Station,
	tsn.Value as TraySN,c.SerialNumber as CartSN,KSN.Value AS KPSN,sp.SerialNumber as Shipper,p.SerialNumber as Pallet,
	a.SMTWO,
	a.PuckWO 
	,pl.Description as P_Line
	,ppo.ActualStartTime PuckWOActualStartTime
	,ppo.ActualFinishTime PuckWOActualFinishTime
	,a.ApplicatorWO
	,al.Description as A_Line
	,apo.ActualStartTime ApplicatorWOActualStartTime
	,apo.ActualFinishTime ApplicatorWOActualFinishTime
	,kpo.ProductionOrderNumber KitpackWO
	,kl.Description as K_Line
	,kpo.ActualStartTime KitpackWOActualStartTime
	,kpo.ActualFinishTime KitpackWOActualFinishTime
FROM #A a
left outer JOIN ffUnit u WITH(nolock) ON a.UnitID = u.ID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.ChildUnitID
left outer join ffSerialNumber ksn with(nolock) on ksn.UnitID = uc.UnitID
left outer join ffUnit ap with(nolock) on ap.ID = uc.ChildUnitID and uc.ChildSerialNumber like 'E%'
left outer join ffStation s with(nolock) on s.ID = U.StationID
left outer join ffUnitState us with(nolock) on us.ID = U.UnitStateID
left outer join ffSerialNumber asn with(nolock) on asn.UnitID = uc.ChildUnitID and asn.SerialNumberTypeID = 3
left outer join udtTray t with(nolock) on t.UnitID = ap.PanelID
left outer join udtCart c with(nolock) on c.ID = t.CartID
left outer join ffSerialNumber tsn with(nolock) on tsn.UnitID = t.UnitID
LEFT OUTER JOIN ffUnit ku WITH(nolock) ON uc.UnitID = ku.ID
left outer join ffUnitDetail ud with(nolock) on ud.UnitID = ku.ID
left outer join ffPackage p with(nolock) on p.ID = ud.OutmostPackageID
left outer join ffPackage sp with(nolock) on sp.ID = ud.InmostPackageID
left outer join ffProductionOrder ppo WITH(nolock) ON a.PuckWOID = ppo.ID
left outer join ffLineOrder plo with(nolock) on plo.ProductionOrderID = ppo.ID
left outer join ffLine pl with(nolock) on pl.ID = plo.LineID
LEFT OUTER JOIN ffProductionOrder apo WITH(nolock) ON a.ApplicatorWOID = apo.ID
LEFT OUTER JOIN ffLineOrder alo with(nolock) on alo.ProductionOrderID = apo.ID
LEFT OUTER JOIN ffLine al with(nolock) on al.ID = alo.LineID
LEFT OUTER JOIN ffProductionOrder kpo WITH(nolock) ON ku.ProductionOrderID = kpo.ID
LEFT OUTER JOIN ffLineOrder klo with(nolock) on klo.ProductionOrderID = kpo.ID
LEFT OUTER JOIN ffLine kl with(nolock) on kl.ID = klo.LineID


