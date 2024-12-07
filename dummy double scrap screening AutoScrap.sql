
--Get The Logs where all the units entered to WIP
drop table if exists #UnitsTraysCarts
select l.UnitID,TrayID,CartID,SN.Value into #UnitsTraysCarts from udtAutomaticScrapPuckINUnitsLog l (nolock)
join ffSerialNumber sn(nolock) on sn.UnitID =l.unitid and sn.SerialNumberTypeID =3
where entertime > '2021-09-14'
 order by id desc

 --Get The Logs (JSONLevel) where all the units had where in a traydatafiles
	 drop table if exists #PUCKTrayLog
	select * into #PUCKTrayLog
	from udtAPILog a(nolock) where Application = 'PuckPNUpgrade' 
	and a.CreationTime>'2021-09-14' order by id desc

 --Get The Logs (JSON Level) where all the units had where in a reject data file
drop table if exists #RejectTrayLog
select * into #RejectTrayLog
from udtAPILog a(nolock) where Application = 'RejectUnit' 
and a.CreationTime>'2021-09-14' order by id desc


 --Get The Logs Unit Level where all the units had where in a traydatafiles
 drop table if exists #PUCKTrayLogWithUnits
SELECT JSON_VALUE(Request, '$.fileType') as FileName, JSON_VALUE(Request, '$.lot') as WorkOrder,pr.CreationTime,p.* into #PUCKTrayLogWithUnits from #PUCKTrayLog pr
    CROSS APPLY
    OPENJSON (Request, '$.units') WITH(sn varchar(50) '$.sn') p
	
	 --Get The Logs Unit Level where all the units had where in a reject data file
 drop table if exists #RejectTrayLogWithUnits
SELECT JSON_VALUE(Request, '$.fileType') as FileName, JSON_VALUE(Request, '$.lot') as WorkOrder,pr.CreationTime,p.* into #RejectTrayLogWithUnits from #RejectTrayLog pr
    CROSS APPLY
    OPENJSON (Request, '$.units') WITH(sn varchar(50) '$.sn') p




	-- Union for both data sets
	drop table if exists #TrayAndRejectLogWithUnits
	select * into #TrayAndRejectLogWithUnits from (
	select * from #PUCKTrayLogWithUnits union
	select * from #RejectTrayLogWithUnits where WorkOrder not like 'A4%') as t

	--select * from #TrayAndRejectLogWithUnits

	-- Get all the unit(with trays and carts)s that entered to wip that are present in a TTray or reject data file
	drop table if exists #UnitswithMatch
	select count(distinct c.UnitID) qty,
	WorkOrder,TrayID,CartID,max(sn) example into #UnitswithMatch from #UnitsTraysCarts c
	join #TrayAndRejectLogWithUnits tr on tr.sn=c.Value
	group by WorkOrder,TrayID,CartID
	order by  TrayID,CartID

--	select * from #TrayAndRejectLogWithUnits where WorkOrder ='EOQ000589'
	
	-- Get all the units(with trays and carts that entered to wip that are present in a TTray or reject data file
	drop table if exists #UnitswithoutMatch
	select count(distinct c.UnitID) qty,
	TrayID,CartID,max(c.Value) example into #UnitswithoutMatch from #UnitsTraysCarts c
	left join #TrayAndRejectLogWithUnits tr on tr.sn=c.Value
	where tr.WorkOrder is null
	group by TrayID,CartID
	order by  TrayID,CartID


	/*
	select * from #UnitswithoutMatch m 
	join #UnitswithMatch wm on m.TrayID=wm.trayid and m.CartID = wm.CartID
	where WorkOrder ='P30001293'
	order by m.TrayID
	*/
	
	select sum(m.qty),WorkOrder,po.ActualStartTime,po.ActualFinishTime from #UnitswithoutMatch m 
	join #UnitswithMatch wm on m.TrayID=wm.trayid and m.CartID = wm.CartID
	join ffProductionOrder po on po.ProductionOrderNumber =wm.WorkOrder
	group by WorkOrder,po.ActualStartTime,po.ActualFinishTime
	order by po.ActualFinishTime,WorkOrder


	/*

	drop table if exists #UnitswithoutMatchUnitLevel
	select distinct c.UnitID, c.Value,'             ' as workorder  into #UnitswithoutMatchUnitLevel
	 from #UnitsTraysCarts c
	left join #TrayAndRejectLogWithUnits tr on tr.sn=c.Value
	where tr.WorkOrder is null
 



 select * from ffstation where Description like '%Puck auto%'


 select *,h.id from #UnitswithoutMatchUnitLevel ul
 left join ffhistory h on h.UnitID  =ul.UnitID and h.StationID = 606
 order by ul.UnitID desc
 */


 create nonclustered index idx on #UnitsTraysCarts (Value)
 create nonclustered index idx1111 on #TrayAndRejectLogWithUnits (sn)

 drop table if exists #UnitsNoMatchToCaluclateUsedOrder
 	select c.UnitID,c.Value,'WORKORDER' as WORKORDER,
	TrayID,CartID into #UnitsNoMatchToCaluclateUsedOrder  from #UnitsTraysCarts c
	left join #TrayAndRejectLogWithUnits tr on tr.sn=c.Value
	where tr.sn is null

	update x set x.WORKORDER = po.productionordernumber from  #UnitsNoMatchToCaluclateUsedOrder x
	join #UnitswithMatch wm on x.TrayID=wm.trayid and x.CartID = wm.CartID
	join ffProductionOrder po on po.ProductionOrderNumber =wm.WorkOrder 

	
	select x.Value,x.WORKORDER,xx.FileName,xx.Content,i.PartNumber from #UnitsNoMatchToCaluclateUsedOrder x
	join udtfbitLibreINVMOV i on i.UnitID =x.UnitID and ExtOtyp ='SCRAP' and StationID =606
	join fbitSignalXML xx on xx.id=i.SignalXMLID 
	where WORKORDER <> 'WORKORDER'

	select * from ffstation where id in (606,554)
