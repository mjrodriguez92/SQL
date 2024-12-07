--select * from ffproductionorder po 
--join ffpackage p on p.currproductionorderid=po.id
--where p.serialnumber='PLTK1000000030'

declare @PalletTable Table (
id int primary key identity(1,1),
PalletID int,
PalletSN varchar(50),
Content  xml,
signaldate datetime
)
BEGIN TRAN;

insert into @PalletTable(PalletID,PalletSN)
select p.ID,p.SerialNumber from ffPackage p
join ffproductionorder po on po.ID=p.CurrProductionOrderID 
where Stage=2 and po.ProductionOrderNumber='K60000384' and p.serialnumber in ('PLTK2000000128')

--select * from ffStation where Description like '%o2p%' order by ID desc
--515	KP_Move_Release_to_O2P 1

DECLARE @p2 NVARCHAR(MAX);
SET @p2 = NULL;
DECLARE @p3 NVARCHAR(MAX);
SET @p3 = NULL;

DECLARE @p4 INT;
SET @p4 = 0;
DECLARE @p5 NVARCHAR(MAX);
SET @p5 = NULL;
DECLARE @p6 INT;
SET @p6 = NULL;


DECLARE @minPallet AS INT= 1, @maxPallet AS INT;
DECLARE @ProductionOrderID INT= 511;
DECLARE @stationid INT= 515;
 
SELECT @maxPallet = MAX(id)
FROM @PalletTable;

WHILE(@minPallet <= @maxPallet)
    BEGIN
        DECLARE @palletid INT;
        SELECT @palletid = PalletID
        FROM @PalletTable
        WHERE id = @minPallet;
        PRINT @palletid;
      

        INSERT INTO ffPackageHistory
        VALUES
        (@palletid, 
         1, 
         @stationid, 
         1000, 
         GETDATE()
        );
   
  DROP TABLE IF EXISTS  #XMLTEMP

  

  --INSERT INTO #XMLTEMP
EXEC @p6 = fbipExportProxy_LibreINVMOV
     @request_xml = N'', 
     @signal_xml = @p2 OUTPUT, 
     @signal_xml_def = @p3 OUTPUT, 
     @error_code = @p4 OUTPUT, 
     @error_message_xml = @p5 OUTPUT, 
     @filename = @p6 OUTPUT;

	

select top 1 p.ID as packageid,x.Content, x.CreateDt into #XMLTEMP from fbitSignalXML x
join udtfbitLibreINVMOVPackage i on i.SignalXMLID =x.id
join ffpackage p on p.ID=i.PackageID
where p.ID=@palletid
order by x.CreateDt desc

 update  p set p.Content =x.Content, P.signaldate=x.CreateDt from @PalletTable p
	 join #XMLTEMP x on x.packageid=p.PalletID
	  
        set @minPallet=@minPallet+1
    
    END;
	   
ROLLBACK;
--select * from @PalletTable

  DROP TABLE IF EXISTS  #@PalletTable

select * into #@PalletTable from @PalletTable


--select * from #@PalletTable
select pal.PalletSN,
--t.p.value('(./ref2skid)[1]', 'VARCHAR(8000)') AS ref2skid
x.p.value('(./attrno)[1]', 'VARCHAR(8000)') AS attrno
,x.p.value('(./attseq)[1]', 'VARCHAR(8000)') AS attseq
,x.p.value('(./attval)[1]', 'VARCHAR(8000)') AS attval
from #@PalletTable pal
--CROSS APPLY content.nodes('/flxint/app/data/rec/stockpoints/stockpoint[@ref2skid="PLTK0100000050"]') t(p)
 --CROSS APPLY content.nodes('/flxint/app/data/rec/stockpoints/stockpoint[@ref2skid="PLTK0100000050"]') t(p)
 --[contains(@ref2skid,"PLTK0100000050")]') t(p)
 CROSS APPLY content.nodes('/flxint/app/data/rec/stockpoints/stockpoint') t(p)
 CROSS APPLY t.p.nodes('./attributes/attribute') x(p)
 where pal.PalletSN=t.p.value('(./ref2skid)[1]', 'VARCHAR(8000)')
 --@x.nodes('/table/rows/row[./columns/column[contains(@value,"EUR")]]') AS A(Rw)



