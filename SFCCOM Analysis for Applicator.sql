/***********************************************************************************************************************************************************        
         Author : Juan Laguna
  Creation Date : 10th Oct 2019
    Explanation : Get the Invenroty Movements and total Backflush units for a factory
      Parameter : None
         Output : All Backflush and Inventory movements
       Is used  : Libre Container and Applicator Factories

exec ruspInventoryMovementAnalysis '768088', 'Applicator'

Version    Date                   FlexPM Task		Author						Description                      
---------  ---------------------  -------------		--------------------		------------------------------------                      
1.0        09/16/2019			  None				Juan Laguna					INITIAL VERSION
***************************************************************************************************************************************************************/    
create proc [dbo].[ruspInventoryMovementAnalysis]
@SourceWarehouse varchar(100),
@Location varchar(100)
as      
begin      

/******************************* 
All SFCCOM for Applicator orders
*********************************/
/*
declare @SourceWarehouse varchar(100)
declare @Location varchar(100)
set @SourceWarehouse = '768088'
set @Location = 'Applicator'
*/

if object_id('tempdb..#SFCCOMSignals') is not null
	drop table #SFCCOMSignals

create table #SFCCOMSignals (Sigref varchar(100), OrderNumber varchar(100), PartNumber varchar(100), Qty int, ClosedFlag int, StatusID int, Content xml, Createdate datetime)

insert into #SFCCOMSignals (Sigref, OrderNumber, PartNumber, Qty, ClosedFlag, StatusID, Content, Createdate)
select x.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref,
	   t.s.value('(orno)[1]','varchar(100)') OrderNumber,
	   t.s.value('(item)[1]','varchar(100)') PartNumber,
	   t.s.value('(qty_deliver)[1]','varchar(100)') Qty,
	   t.s.value('(close)[1]','varchar(100)') ClosedFlag,
	   x.StatusID,
	   x.Content, 
	   x.CreateDt 
  from fbitSignalXML x with (nolock) cross apply x.Content.nodes('/flxint/app/data/rec') t(s)
  join ffProductionOrder o with (nolock) on t.s.value('(orno)[1]','varchar(100)') = o.ProductionOrderNumber 
  join ffLineOrder lo with (nolock) on o.ID = lo.ProductionOrderID
  join ffline l with (nolock) on lo.LineID = l.ID
 where l.Location = @Location
   and x.SignalTypeID = 12
 order by o.ProductionOrderNumber, x.CreateDt  

if object_id('tempdb..#SFCCOMSummary') is not null
	drop table #SFCCOMSummary

create table #SFCCOMSummary (OrderNumber varchar(100), PartNumber varchar(100), Total int)

insert into #SFCCOMSummary (OrderNumber, PartNumber, Total)
select s.OrderNumber, s.PartNumber, sum(Qty) Total
  from #SFCCOMSignals s
 group by OrderNumber, PartNumber
 order by OrderNumber

/*********************************************** 
All INVMOV from 768088 Applicator WIP warehouse
************************************************/

if object_id('tempdb..#SignalIDs') is not null
	drop table #SignalIDs

create table #SignalIDs (ID int, ProductionOrderID int, ProductionOrderNumber varchar(100), Total int)

insert into #SignalIDs (ID, ProductionOrderID, ProductionOrderNumber, Total)
select w.SignalXMLID, o.ID, o.ProductionOrderNumber, count(u.ID) TotalSN
  from udtfbitLibreINVMOV w with (nolock) 
  join ffunit u with (nolock) on w.UnitID = u.ID
  join ffProductionOrder o with (nolock) on u.ProductionOrderID = o.ID
 where w.Src_Warehouse = @SourceWarehouse
 group by w.SignalXMLID, o.ID, o.ProductionOrderNumber 

insert into #SignalIDs (ID, ProductionOrderID, ProductionOrderNumber, Total)
select w.SignalXMLID, o.ID, o.ProductionOrderNumber, w.Qty
  from udtfbitLibreINVMOVPackage w with (nolock) 
  join ffProductionOrder o with (nolock) on w.ProductionOrderID = o.ID
 where w.Src_Warehouse = @SourceWarehouse
 group by w.SignalXMLID, o.ID, o.ProductionOrderNumber, w.Qty 

if object_id('tempdb..#UniqueSignals') is not null
	drop table #UniqueSignals

create table #UniqueSignals (ID int)

insert into #UniqueSignals(ID)
select distinct s.ID
  from #SignalIDs s

if object_id('tempdb..#XMLSignals') is not null
	drop table #XMLSignals

create table #XMLSignals (ID int, Content xml)

insert into #XMLSignals( ID, Content)
select s.ID, x.Content
  from #UniqueSignals s
  join fbitSignalXML x with (nolock) on s.ID = x.ID

if object_id('tempdb..#INVMOVbyOrder') is not null
	drop table #INVMOVbyOrder

create table #INVMOVbyOrder (Sigref varchar(100), Destination varchar(100), [Type] varchar(100), ProductionOrderNumber varchar(100), Ref2Skid varchar(100), PartNumber varchar(100), Qty int, Content xml)

insert into #INVMOVbyOrder (Sigref, Destination, [Type], ProductionOrderNumber, Ref2Skid, PartNumber, Qty, Content)
select x.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref,
	   t.s.value('(destination)[1]','varchar(100)') Destination,
	   t.s.value('(ext_otyp)[1]','varchar(100)') [Type],
	   s.ProductionOrderNumber,
	   t.s.value('(stockpoints/stockpoint/ref2skid)[1]','varchar(100)') Ref2Skid,
	   t.s.value('(stockpoints/stockpoint/item)[1]','varchar(100)') item,
	   t.s.value('(stockpoints/stockpoint/qty)[1]','varchar(100)') qty,
	   x.Content
  from #XMLSignals x cross apply x.Content.nodes('/flxint/app/data/rec') t(s)
  join #SignalIDs s on x.ID = s.ID
 where t.s.value('(source)[1]','varchar(100)') = @SourceWarehouse
 
if object_id('tempdb..#INVMOVSummary') is not null
	drop table #INVMOVSummary

create table #INVMOVSummary (ProductionOrderNumber varchar(100), Destination varchar(100), PartNumber varchar(100), Total int)

 insert into #INVMOVSummary(ProductionOrderNumber, PartNumber, Destination, Total)
 select ProductionOrderNumber, PartNumber, Destination, sum(qty) Total
   from #INVMOVbyOrder i
  group by ProductionOrderNumber, PartNumber, Destination

if object_id('tempdb..#Summary') is not null
	drop table #Summary

create table #Summary (ProductionOrderNumber varchar(100), Backflush int, [7680CR] int, [768B05] int, [768078] int, [768073] int, [768088] int, [768030] int)

insert into #Summary(ProductionOrderNumber, [7680CR], [768B05], [768078], [768073], [768088], [768030])
select ProductionOrderNumber, isnull([7680CR],0) [7680CR], isnull([768B05],0) [768B05], isnull([768078],0) [768078], isnull([768073],0) [768073], isnull([768088],0) [768088], isnull([768030],0) [768030]
  from (select ProductionOrderNumber, Destination, Total 
	      from #INVMOVSummary) p
 pivot (max(Total) for destination in ([7680CR], [768B05], [768078], [768073], [768088], [768030])) as pvt
 order by ProductionOrderNumber

update s set Backflush = t.Total 
  from #SFCCOMSummary t
  join #Summary s on t.OrderNumber = s.ProductionOrderNumber 

insert into #Summary (ProductionOrderNumber, Backflush, [7680CR], [768B05], [768078], [768073], [768088], [768030])
select t.OrderNumber, t.Total, 0, 0, 0, 0, 0, 0
  from #SFCCOMSummary t
  left join #Summary s on t.OrderNumber = s.ProductionOrderNumber 
 where s.ProductionOrderNumber is null

select ProductionOrderNumber, Backflush, [7680CR], [768B05], [768078], [768073], [768088], [768030], Backflush - ([7680CR] + [768B05] + [768078] + [768073] + [768088] + [768030]) Delta
  from #Summary s
 order by s.ProductionOrderNumber 


if object_id('tempdb..#Summary') is not null
	drop table #Summary

if object_id('tempdb..#XMLSignals') is not null
	drop table #XMLSignals

if object_id('tempdb..#SignalIDs') is not null
	drop table #SignalIDs

if object_id('tempdb..#UniqueSignals') is not null
	drop table #UniqueSignals

if object_id('tempdb..#INVMOVbyOrder') is not null
	drop table #INVMOVbyOrder

if object_id('tempdb..#INVMOVSummary') is not null
	drop table #INVMOVSummary


end