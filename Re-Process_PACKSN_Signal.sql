
/* Check PackSN signal status */

declare @Pallet varchar(100)
set @Pallet = 'PLTK2141000342'

select top 100 t.s.value('(pack_id)[1]','varchar(100)') Pallet, 
	   x.UpdateDt [Signal Update Time], x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SignalRef,
	   x.StatusID, x.Content [XML],
	   case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status],
	   isnull(r.Content.value('(flxint/app/data/rec/msg)[1]','varchar(800)'),'') [Error],
	   r.Content RespXML, r.CreateDt RespTime
  from fbitSignalXML x cross apply x.Content.nodes('/flxint/app/data/rec/pack') t(s)
  left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 14
 where x.SignalTypeID = 14
   and t.s.value('(pack_id)[1]','varchar(100)') = @Pallet
 order by x.ID 




--BEGIN TRAN;

--delete   PH from ffPackageHistory PH
--JOIN ffPackage P ON P.ID=PH.PackageID 
--where P.CurrProductionOrderID =511


DECLARE @minPallet AS INT= 1, @maxPallet AS INT;
DECLARE @ProductionOrderID INT= (Select ID from ffProductionOrder where ProductionOrderNumber = 'KTP002182') ;  --511
DECLARE @stationid INT= (Select ID from FFstation where Description = 'KP_PreRelease 3') ;-- 411  'KP_PreRelease 2' Must Include Station
--82063
--82127
--82255
Select * from ffPackage where SerialNumber = 'PLTK2141000391'
Select * from ffstation where Description like '%PreRelease%'
DROP TABLE IF EXISTS #PalletsToPACKSN;
SELECT PalletID, 
       Num
INTO #PalletsToPACKSN
FROM
(
    SELECT 2502674 AS PalletID, 
           1 AS NUM
    --UNION
    --SELECT 82127 AS PalletID, 
    --       2 AS NUM
                --     UNION
    --SELECT 82255 AS PalletID, 
    --       2 AS NUM
) AS T;

SELECT @maxPallet = MAX(Num)
FROM #PalletsToPACKSN;

SELECT @minPallet'@minPallet', @maxPallet'@maxPallet'

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

       select pizd.* from ffPackage p
       join ffPackageHistory ph on ph.PackageID=p.ID
       join ffpackinginfolog piz on piz.PackageHistoryid=ph.id
       left join ffPackingInfoLogDetail pizd on pizd.PackingInfoLogID=piz.ID 
       where CurrProductionOrderID =@ProductionOrderID and ph.StationID=516
       order by ph.ID desc

--PRINT '+++++++++++++++++++++++++';
--DECLARE @p2 NVARCHAR(MAX);
--SET @p2 = NULL;
--DECLARE @p3 NVARCHAR(MAX);
--SET @p3 = NULL;
--DECLARE @p4 INT;
--SET @p4 = 0;
--DECLARE @p5 NVARCHAR(MAX);
--SET @p5 = NULL;
--DECLARE @p6 INT;
--SET @p6 = NULL;
--EXEC @p6 = fbipExportProxy_LibrePACKSNv4
--     @request_xml = N'', 
--     @signal_xml = @p2 OUTPUT, 
--     @signal_xml_def = @p3 OUTPUT, 
--     @error_code = @p4 OUTPUT, 
--     @error_message_xml = @p5 OUTPUT, 
--     @filename = @p6 OUTPUT;
--SELECT @p2, 
--       @p3, 
--       @p4, 
--       @p5, 
--       @p6;

          
--ROLLBACK;



--select * from 
--select top 10 * from fbitsignalxml where CAST(Content as varchar(max) ) like '%packsn%' order by id desc
