--use q_libre_ace
-- select * from ffProductionOrder po where po.ProductionOrderNumber ='K60000199'
-- select * from ffPackage p where p.SerialNumber='PLTK1100000298'
-- select * from ffstation where description like '%PRER%'

--select top 100 * from udtfbitPACKSN_Libre order by id desc
--order by id desc

BEGIN TRAN;



DECLARE @minPallet AS INT= 1, @maxPallet AS INT;
DECLARE @ProductionOrderID INT= (select id from ffProductionOrder where ProductionOrderNumber ='K60000545')
DECLARE @stationid INT=  (select id from ffstation  where Description  ='KP_PreRelease 1')

delete ps  from  ffPackage p
 
	 --join udtfbitLibrePACKSN ps on ps.packageid=p.id
	 join udtfbitpacksn_libre  ps on ps.packageid=p.id
	 where p.currproductionorderid =@ProductionOrderID and stage=2

DROP TABLE IF EXISTS #PalletsToPACKSN;
SELECT PalletID, 
       Num
INTO #PalletsToPACKSN
FROM
(
   select ID as Palletid, ROW_NUMBER() over(order by p.id)as Num from ffPackage p where CurrProductionOrderID =@ProductionOrderID and stage=2 and serialnumber ='PLTK2600000126'
) AS T;

select * from #PalletsToPACKSN
SELECT @maxPallet = MAX(Num)
FROM #PalletsToPACKSN;

WHILE(@minPallet <= @maxPallet)
    BEGIN
        DECLARE @palletid INT;
        SELECT @palletid = PalletID
        FROM #PalletsToPACKSN
        WHERE NUM = @minPallet;
        PRINT @palletid;
        DECLARE @packagehistoryid INT= 9999;--Obtenerlodel history
        DECLARE @parentpackinginfologid INT= 9999;--obtenerlo del primer packinginfolog del pallet

        INSERT INTO ffPackageHistory
        VALUES
        (@palletid, 
         1, 
         @stationid, 
         1000, 
         GETDATE()
        );
        SET @packagehistoryid = SCOPE_IDENTITY();
        INSERT INTO ffpackinginfolog
        VALUES
        (@packagehistoryid, 
         @palletid, 
         NULL, 
         4, 
         0
        );
        SET @parentpackinginfologid = SCOPE_IDENTITY();
        DROP TABLE IF EXISTS #tempffpackinginfolog;
        SELECT @packagehistoryid AS PackageHistoryID, 
               id AS PackageID, 
               @parentpackinginfologid AS ParentPackingInfoLogID, 
               NULL AS PAckingActionID, 
               0 AS IsUnlink, 
               ROW_NUMBER() OVER(
               ORDER BY id) AS enum
        INTO #tempffpackinginfolog
        FROM ffPackage
        WHERE ParentID = @palletid;
        DECLARE @min INT= 1;
        DECLARE @max INT;
        DECLARE @PackageInfoLogID INT;
        SELECT @max = MAX(enum)
        FROM #tempffpackinginfolog;
        WHILE(@min <= @max)
            BEGIN
                INSERT INTO ffpackinginfolog
                       SELECT PackageHistoryID, 
                              PackageID, 
                              ParentPackingInfoLogID, 
                              PAckingActionID, 
                              isUnlink
                       FROM #tempffpackinginfolog t
                       WHERE t.enum = @min;
                SELECT @PackageInfoLogID = SCOPE_IDENTITY();  --get last inserted ffpackinginfolog

				print @PackageInfoLogID

                INSERT INTO ffpackinginfologdetail
                       SELECT @PackageInfoLogID AS PackageInfoLogID, 
                              u.ID AS UnitID, 
                              u.LooperCount, 
                              u.PartID, 
                              @ProductionOrderID ProductionOrderID, 
                              0 AS IsUnlik
                       FROM ffUnit u
                            JOIN ffUnitDetail ud ON ud.UnitID = u.ID
                            JOIN #tempffpackinginfolog t ON t.PackageID = ud.InmostPackageID
                       WHERE t.enum = @min;

				 
			

					   

                SET @min = @min + 1;
            END;
        SET @minPallet = @minPallet + 1;
        PRINT '+++++++++++++++++++++++++';
        PRINT @minPallet;
        PRINT '+++++++++++++++++++++++++';
    END;

	--select * from ffPackage p
	--join ffPackageHistory ph on ph.PackageID=p.ID
	-- join ffpackinginfolog piz on piz.PackageHistoryid=ph.id
	-- left join ffPackingInfoLogDetail pizd on pizd.PackingInfoLogID=piz.ID 
	--where CurrProductionOrderID =@ProductionOrderID   and p.SerialNumber='PLTK1100000298'

	--	select * from ffPackage p
	--join ffPackageHistory ph on ph.PackageID=p.ID
	-- join ffpackinginfolog piz on piz.PackageHistoryid=ph.id
	-- left join ffPackingInfoLogDetail pizd on pizd.PackingInfoLogID=piz.ID 
	--where CurrProductionOrderID =@ProductionOrderID   and p.SerialNumber<>'PLTK1100000298'

	--order by ph.ID desc
	/*
PRINT '+++++++++++++++++++++++++';
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
EXEC @p6 = fbipExportProxy_LibrePACKSNv4
     @request_xml = N'', 
     @signal_xml = @p2 OUTPUT, 
     @signal_xml_def = @p3 OUTPUT, 
     @error_code = @p4 OUTPUT, 
     @error_message_xml = @p5 OUTPUT, 
     @filename = @p6 OUTPUT;
SELECT @p2, 
       @p3, 
       @p4, 
       @p5, 
       @p6;

*/


ROLLBACK;



--select * from 
--select top 10 * from fbitsignalxml where CAST(Content as varchar(max) ) like '%packsn%' order by id desc