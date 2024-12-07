
--1. Run the query on FF db (p_REP_LIBRE_FF)

Drop table #KPScrapReason



select sn.Value as SN,u.CreationTime,us.Description as UnitState,lus.Description as UnitStatus INTO #KPScrapReason from ffUnit u with(nolock)
inner join ffSerialNumber sn with(nolock) on sn.UnitID = u.ID AND SN.SerialNumberTypeID = 3
--inner join ffSerialNumber sn2 with(nolock) on sn.UnitID = u.ID and sn2.SerialNumberTypeID = 3 and sn2.Value like 'E%'
inner join ffProductionOrder po with(nolock) on po.ID = u.ProductionOrderID 
inner join ffUnitState us with(nolock) on us.ID = u.UnitStateID
INNER JOIN luUnitStatus lus with(nolock) on lus.ID = u.StatusID 
inner join ffLineOrder lo with(nolock) on lo.ProductionOrderID = U.ProductionOrderID
inner join ffLine l with(nolock) on l.ID = lo.LineID
where US.ID IN ('8123',
'8123',
'8015',
'8007',
'8006',
'8010',
'8016',
'8017',
'8018',
'8051',
'8114',
'8113',
'8309',
'8310',
'110009',
'5041',
'5000004',
'5000005') and u.CreationTime >= '2021-01-01 00:00:00.000' and u.CreationTime <= '2021-01-31 23:59:44.110' and u.StatusID = 3

select * from #KPScrapReason



/*
--Move to MDS DB on replica server (p_REP_LIBRE_MDS)


SELECT KP.*,KPT.Comment AS Reason FROM #KPScrapReason KP
INNER JOIN DS_FT_KitPackTest KPT WITH(NOLOCK) ON KP.SN = KPT.AppUID
--select top 1000 * from DS_FT_KitPackTest

*/


