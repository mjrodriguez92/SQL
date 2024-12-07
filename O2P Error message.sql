
--Query to Find Shipper send to O2P but not prerelease. 

select TOP 10000 * from ffPackage p with(nolock)
inner join ffProductionOrder po with(nolock) on po.ID = p.CurrProductionOrderID
where po.ProductionOrderNumber like 'K%' AND PO.StatusID = 5
order by po.ID desc

--Add into
--udtfbitLibreINVMOVPackage
--fbitSignalXML
--fbitSignal
--fbitRESP



--Manually Create Ack Signal 

 select p.SerialNumber,ph.* from ffPackageHistory  ph
    join ffPackage p on ph.PackageID = p.ID
 where p.SerialNumber = 'PLTK2208000079'


--Add into udtfbitLibreINVMOVPackage
insert into udtfbitLibreINVMOVPackage (
SignalXMLID,
SourceStationTypeID,
DestinationStationTypeID,
Src_Warehouse,
Dest_Warehouse,
Warehouse_Location,
ExtOtyp,
GroupBy,
StationID,
PackageHistoryID,
PackageID,
ProductionOrderID,
PartID,
PartNumber,
Qty,
StatusID,
CreateBy,
CreateDt,
UpdateBy,
UpdateDT
)
values (2957097,307,307,768174,768073,NULL,'Transfer_SKID','PartNumber + Pallet','558','9685760','3189225','11292','8334','THRL-71988-01F-0002','1488',2,1000,GETDATE(),1000,GETDATE())

 select p.SerialNumber,ph.* from ffPackageHistory  ph
    join ffPackage p on ph.PackageID = p.ID
 where p.ID = '3188880'


select * from udtfbitLibreINVMOVPackage with(nolock)
where PackageID = 3188880

--Add into fbitSignalXML

Update udtfbitLibreINVMOVPackage
set SignalXMLID = 2957097
where ID = -2147414541


--insert into fbitSignalXML (
--Content,SignalTypeID,SignalID,StatusID,FileName,CreateBy,CreateDt,UpdateBy,UpdateDt,PIndicator
--)
--values (NULL,13,'',3,NULL,1000,GETDATE(),1000,GETDATE())

