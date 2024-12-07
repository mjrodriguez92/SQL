drop table if exists #applicatorsinkitpackOrder
select u.ID Applicator 
into #applicatorsinkitpackOrder 
from ffProductionOrder apo (nolock) 
INNER JOIN ffunit u(nolock) ON u.ProductionOrderID = apo.ID
where apo.ProductionOrderNumber = 'po'

drop table if exists #PNLessThan2Applicators 
select
u.ID as AplicatorID,
count(distinct ph.ID) ApplicatorPartNumberCount
into #PNLessThan2Applicators
from ffunit u (nolock) 
join #applicatorsinkitpackOrder app on app.Applicator =u.ID
join ffPart p (nolock) on p.ID=u.PartID
join luPartFamily pf (nolock) on pf.id=p.partfamilyid 
join ffhistory h (nolock)on h.unitid=u.id
join ffPart ph (nolock) on ph.ID=h.PartID
where  pf.Name='APP' 
group by u.ID
having  count( distinct ph.ID) <3

SELECT a.AplicatorID UnitID ,po.ProductionOrderNumber WO ,sn.value UnitSN ,us.Description UnitStatus,tsn.value TraySN ,c.SerialNumber CartID ,uc.UnitID
FROM #PNLessThan2Applicators a
INNER JOIN ffSerialNumber sn WITH(nolock) ON a.AplicatorID = sn.UnitID AND sn.SerialNumberTypeID = 3
INNER JOIN ffUnit u WITH(nolock) ON a.AplicatorID = u.ID
INNER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
INNER JOIN luUnitStatus us WITH(nolock) ON u.StatusID = us.ID
INNER JOIN ffSerialNumber tsn WITH(nolock) ON u.PanelID = tsn.UnitID
INNER JOIN udtTray t WITH(nolock) ON t.UnitID = tsn.UnitID
INNER JOIN udtCart c WITH(nolock) ON t.CartID = c.ID
LEFT OUTER JOIN ffUnitComponent uc WITH(nolock) ON u.ID = uc.ChildUnitId





