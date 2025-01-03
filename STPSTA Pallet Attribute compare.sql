/*select p.id, p.SerialNumber,pa.PartNumber  from ffPackage p
--join ffProductionOrder po on po.ID=p.CurrProductionOrderID
join ffpart pa on pa.id=p.currPartID 
join luPartFamily pf on pf.id=pa.PartFamilyID
where stage =2 and pf.Name ='CON'
and p.id in (select udtfbitLibreSTPSTAPackage.PackageID from udtfbitLibreSTPSTAPackage)
order by p.id desc
*/
USE P_LIBRE_FF
GO


drop table if exists #PalletInfo

SELECT DISTINCT p.id, 
p.SerialNumber,
po.ProductionOrderNumber,
pa.PartNumber,
po.ActualFinishTime 
into #PalletInfo 

from ffPackage p
join ffProductionOrder po 
	on po.ID=p.CurrProductionOrderID
join ffpart pa 
	on pa.id=po.PartID 
join luPartFamily pf 
	on pf.id=pa.PartFamilyID
where stage =2 
AND P.SerialNumber LIKE 'P%'
--and pf.Name ='KTP'
--and p.id in (select udtfbitLibreSTPSTAPackage.PackageID from udtfbitLibreSTPSTAPackage WHERE CreateDt BETWEEN '2022-01-14 00:00:00.000' AND GETDATE())
and po.ProductionOrderNumber IN (
'KTP003807','KTP003763','KTP003777','KTP003783','KTP003785'

)
--'KTP003047',
--'KTP003052',
--'KTP003049',
--'KTP002967',
--'KTP003054',
--'KTP003056',
--'KTP002971',
--'KTP002975',
--'KTP003050',
--'KTP003063',
--'KTP003064',
--'KTP003065',
--'KTP003068',
--'KTP003069',
--'KTP003062')--,
--'KTP002679',
--'KTP002698',
--'KTP002693',
--'KTP002701',
--'KTP002706')--2674, 2678 and 2662,
--'KTP002615',
--'KTP002614',
--'KTP002621',
--'KTP002630')--,
--'KTP002610',
--'KTP002584',
--'KTP002600',
--'KTP002591',
--'KTP002587')
--AND P.SerialNumber IN ('PLTK2150000214')--,
--'PLTK2149000020',
--'PLTK2149000086',
--'PLTK2149000087',
--'PLTK2149000091')

order by p.id desc

drop table if exists #SensorData
 --INSERT INTO #SensorData (TempSignalTblID, SensorPart, SensorLot, AttributeSeq, SensorQty, SensorExpiryDate, WO, ref2Skid, LibrePlantCode, FGPartNumber) --sampling by Francisco De La Vega  
 SELECT   
   ID  
  ,partnumber  
  ,lotcode  
  ,ROW_NUMBER() OVER (PARTITION BY ID ORDER BY GroupedSensorData.LotCode) as seq--sampling by Francisco De La Vega  
  --,ROW_NUMBER() OVER (PARTITION BY LotCode ORDER BY ID)  seq--sampling by Francisco De La Vega  
  ,qty  
  ,Reserved_05  
  ,GroupedSensorData.ProductionOrderNumber  

  ,Reserved_28		--- gdlhugar 2021APR19
  ,Reserved_29		--- gdlhugar 2021APR19
  into #SensorData
 FROM   
 (  
  SELECT   
    l.ID  
   ,SD.partnumber  
   ,SD.lotcode  
   ,COUNT(SS.ID) Qty  
   ,(SELECT TOP 1 md.Reserved_05 FROM ffMaterialUnitDetail md with(nolock) WHERE sd.lotcode = md.Reserved_02 Order By md.ID Desc) as Reserved_05  
   ,PO.ProductionOrderNumber--sampling by Francisco De La Vega  
   --,ref2Skid
	,(SELECT TOP 1 md.Reserved_28 FROM ffMaterialUnitDetail md With (Nolock) WHERE sd.lotcode = md.Reserved_02 Order By md.ID Desc) as Reserved_28  --- gdlhugar 2021APR19
	, dbo.udfPartsRemoved(p.CurrPartID)  as Reserved_29  --- gdlhugar 2021APR19 
  FROM   
   #PalletInfo l
   INNER JOIN ffPackage P(NOLOCK)   
    ON p.ID = l.id  
   INNER JOIN ffProductionOrder PO(NOLOCK)   
    ON P.CurrProductionOrderID = PO.ID --sampling by Francisco De La Vega  
   INNER JOIN ffUnitDetail UD(NOLOCK)      
    ON P.ID = UD.OutmostPackageID  
   INNER JOIN ffUnitComponent UC (NOLOCK)   
    ON UD.UnitID = UC.UnitID  
   INNER JOIN ffSerialNumber SN(NOLOCK)    
    ON UC.ChildUnitID = SN.UnitID   
   INNER JOIN udtSensorSerials SS(NOLOCK)   
    ON SN.Value = SS.Serial   
   INNER JOIN udtSensorData SD (NOLOCK)  
    ON SS.SensorDataID = SD.ID  
   INNER JOIN lupartfamily pf (nolock)   
    ON pf.ID=UC.ChildPartFamilyID  
  WHERE   
   SN.SerialNumberTypeID = 0 and pf.Name='CON'  
  --AND l.extotyp = 'WR_NEW_SKID' AND l.GroupBy = 'PartNumber + Pallet'  
  AND P.CurrProductionOrderID IS NOT NULL --sampling by Francisco De La Vega  
  GROUP BY   
    l.id  
   ,SD.partnumber  
   ,SD.lotcode  
   ,PO.ProductionOrderNumber  
   --,l.ref2skid  
   ,p.CurrPartID				--- gdlhugar 2021APR19
 ) GroupedSensorData  


/*
Second Step is to get all the attributes
*/


	DECLARE @VarCategoryID     INT,  
			@WorkOrderLOTAttribute   VARCHAR(50),  
			@ExpirationDateAttribute  VARCHAR(50),  
			@GRNRECExpirationDateAttribute VARCHAR(50),  
			@WorkOrderAttribute    VARCHAR(50),  
			@ReasonCodeAttribute   VARCHAR(50),  
			@SensorPNAttribute    VARCHAR(50),  
			@SensorQtyAttribute    VARCHAR(50),  
			@SensorLOTAttribute    VARCHAR(50),  
			@SensorEDIReasonCodeAttribute VARCHAR(50),  
			@SensorExpiryDateAttribute  VARCHAR(50),  
			@SamplingTypeAttribute   VARCHAR(50),  
			@Query       NVARCHAR(MAX),  
			@ExpirationDateFieldName  NVARCHAR(50),  
			@Parameter      NVARCHAR(1000),
			@LibrePlantCode VARCHAR(50),
			@FGPartNumber   VARCHAR(50)

	SELECT @VarCategoryID     = ID FROM luVarCategory WHERE Description = 'INVMOV ATTRIBUTES'  
	SELECT @WorkOrderLOTAttribute   = ISNULL(Value,'') FROM fsVar WHERE Name = 'Work Order LOT' AND VarCategoryID = @VarCategoryID  
	SELECT @ExpirationDateAttribute   = ISNULL(Value,'') FROM fsVar WHERE Name = 'Expiration Date' AND VarCategoryID = @VarCategoryID  
	SELECT @GRNRECExpirationDateAttribute = ISNULL(Value,'') FROM fsVar WHERE Name = 'GRNREC Expiration Date' AND VarCategoryID = @VarCategoryID  
	SELECT @WorkOrderAttribute    = ISNULL(Value,'') FROM fsVar WHERE Name = 'Work Order' AND VarCategoryID = @VarCategoryID  
	SELECT @ReasonCodeAttribute    = ISNULL(Value,'') FROM fsVar WHERE Name = 'Reason Code' AND VarCategoryID = @VarCategoryID  
	SELECT @SensorPNAttribute    = ISNULL(Value,'') FROM fsVar WHERE Name = 'Sensor PN' AND VarCategoryID = @VarCategoryID    
	SELECT @SensorQtyAttribute    = ISNULL(Value,'') FROM fsVar WHERE Name = 'Sensor Qty' AND VarCategoryID = @VarCategoryID  
	SELECT @SensorLOTAttribute    = ISNULL(Value,'') FROM fsVar WHERE Name = 'Sensor LOT' AND VarCategoryID = @VarCategoryID  
	SELECT @SensorEDIReasonCodeAttribute = ISNULL(Value,'') FROM fsVar WHERE Name = 'Sensor EDI Reason Code' AND VarCategoryID = @VarCategoryID   
	SELECT @SensorExpiryDateAttribute  = ISNULL(Value,'') FROM fsVar WHERE Name = 'Sensor Expiry Date' AND VarCategoryID = @VarCategoryID  
	SELECT @SamplingTypeAttribute   = ISNULL(Value,'') FROM fsVar WHERE Name = 'Sampling Type' AND VarCategoryID = @VarCategoryID   
	SELECT @ExpirationDateFieldName   = FieldName    FROM fsFieldDefinition(NOLOCK) WHERE TableName = 'ffMaterialUnitDetail' AND Definition = 'ExpirationDate'  
	SELECT @LibrePlantCode  = ISNULL(Value,'') FROM fsVar WHERE Name = 'Libre Plant Code' AND VarCategoryID = @VarCategoryID	--- gdlhugar 2021APR19
	SELECT @FGPartNumber   = ISNULL(Value,'') FROM fsVar WHERE Name = 'FG Part Number' AND VarCategoryID = @VarCategoryID		--- gdlhugar 2021APR19
  
 -- SELECT ID , @SensorLOTAttribute, seq AttributeSeq, SensorLot, serialNumber as ref2skid FROM #SensorData   
  --SELECT * FROM #SensorData   
	Declare @Count Int  
	Declare @Reason Varchar(100)  

 	IF OBJECT_ID('tempdb..#tempSignalTblSkidAttributes') IS NOT NULL   
	BEGIN   
		DROP TABLE #tempSignalTblSkidAttributes   
	END 
	CREATE TABLE #tempSignalTblSkidAttributes
	(
		ID INT IDENTITY,
		tempSignalTblID BIGINT, --2019-02-19
		attrno INT,
		attseq INT,
		attval VARCHAR(200),
		ref2skid VARCHAR(200) -- fix qty ref2skid
	)

DECLARE  @FieldName NVARCHAR(200) = ''  
  
 SELECT @FieldName=FieldName FROM fsFieldDefinition WHERE TableName ='ffMaterialUnitDetail' AND Definition ='ExpirationDate'  
  
 SET @Query = convert(nvarchar(max), N'') +convert(nvarchar(max), N'') +   
 N'insert into #tempSignalTblSkidAttributes(tempSignalTblID, attrno, attseq, attval, ref2skid)   
 
select l.id, @ExpirationDateAttribute, ''1'', case when len(ISNULL(pd.Content,'''')) = 6   
           then replace(convert(varchar(25),dateadd(dd,-1,dateadd(mm,1,CAST(pd.Content +''01'' AS DATE))),112),''-'','''')   
          else pd.Content  
          end,l.SerialNumber as ref2skid  
from #PalletInfo l  
inner join ffPackage p on l.id = p.ID  
inner join ffPackageDetail pd on p.ID = pd.PackageID  
inner join luPackageDetailDef pdd on pd.PackageDetailDefID = pdd.ID  
and pdd.Description = ''ExpDate''  
------------------where extotyp = ''WR_NEW_SKID'' and l.groupby = ''PartNumber + Pallet''  
  
union all  
   
select l.id, @ExpirationDateAttribute, ''1'', case when len(od.Content) = 6   
           then replace(convert(varchar(25),dateadd(dd,-1,dateadd(mm,1,CAST(od.Content +''01'' AS DATE))),112),''-'','''')   
           else replace(convert(varchar(25),CAST(od.Content AS DATE),112),''-'','''')   
           end ,l.SerialNumber as ref2skid  
from #PalletInfo l  
inner join ffproductionorder o on o.Productionordernumber = l.Productionordernumber   
inner join ffProductionOrderDetail od   
on od.ProductionOrderID = o.id and od.ProductionOrderDetailDefID in (select id from luProductionOrderDetailDef where Description = ''ExpirationDate'')  
--where extotyp = ''WR_NEW_SKID'' and l.groupby = ''PartNumber + Pallet''  
  
union all  
  
select l.id, @GRNRECExpirationDateAttribute, ''1'', case when len(od.Content) = 6   
             then replace(convert(varchar(25),dateadd(dd,-1,dateadd(mm,1,CAST(od.Content +''01'' AS DATE))),112),''-'','''')   
             else replace(convert(varchar(25),CAST(od.Content AS DATE),112),''-'','''')   
           end ,l.SerialNumber as ref2skid  
from #PalletInfo l  
inner join ffproductionorder o on o.productionordernumber = l.ProductionOrderNumber  

inner join ffProductionOrderDetail od on od.ProductionOrderID = o.id and od.ProductionOrderDetailDefID in (select id from luProductionOrderDetailDef where Description = ''ExpirationDate'')  
--where extotyp = ''WR_NEW_SKID'' and l.groupby = ''PartNumber + Pallet''  
   
union all  
 
  
select   
 W.ID  
,@WorkOrderLOTAttribute  
,W.seq AttributeSeq  
,W.ProductionOrderNumber as WO  
,t.SerialNumber as Ref2Skid
from   
#SensorData W  
INNER JOIN #PalletInfo   T  
 ON W.ID = T.ID   
INNER JOIN ffPackage P(NOLOCK)  
 ON T.ID = P.ID  
WHERE   
 P.CurrProductionOrderID  IS NULL   
--AND extotyp = ''WR_NEW_SKID'' and groupby = ''PartNumber + Pallet''  
  
union all  
    
select     
 W.ID  
,@WorkOrderLOTAttribute  
,1  
,W.ProductionOrderNumber as WO  
,t.SerialNumber as Ref2Skid
from   
#SensorData W  
INNER JOIN #PalletInfo T
 ON W.ID = T.ID   
INNER JOIN ffPackage P(NOLOCK)  
 ON T.ID = P.ID  
WHERE   
 P.CurrProductionOrderID  IS NOT NULL   
--AND extotyp = ''WR_NEW_SKID'' and groupby = ''PartNumber + Pallet''  
GROUP BY W.ID  
  ,W.ProductionOrderNumber  
  ,t.serialNumber  

union all  
  
select l.id, @WorkOrderAttribute, ''1'', o.ProductionOrderNumber ,l.SerialNumber as ref2skid  
from #PalletInfo   l inner join ffpackage p on p.id = l.ID  
inner join ffproductionorder o on o.id = p.CurrProductionOrderID   
--where l.extotyp = ''WR_NEW_SKID'' AND P.CurrProductionOrderID IS NOT NULL  
   
UNION ALL  
   
SELECT ID , @SensorPNAttribute,  cast(seq as INT) AttributeSeq, partnumber as SensorPart , null as ref2skid FROM #SensorData   

UNION ALL  
   
SELECT ID , @SensorQtyAttribute, cast(seq as INT) AttributeSeq, cast(qty as varchar(100)) as SensorQty, null as ref2skid FROM #SensorData WHERE qty > 0   

UNION ALL  
   
SELECT ID , @SensorLOTAttribute, cast(seq as INT) AttributeSeq, LotCode as SensorLot, null as ref2skid FROM #SensorData' 

--print @Query

--select top 1 *from #SensorData 

	SET @Parameter = N'@WorkOrderLOTAttribute NVARCHAR(50) '   
	SET @Parameter += ', @ExpirationDateAttribute NVARCHAR(50) '  
	SET @Parameter += ', @GRNRECExpirationDateAttribute NVARCHAR(50) '  
	SET @Parameter += ', @WorkOrderAttribute NVARCHAR(50) '  
	SET @Parameter += ', @ReasonCodeAttribute NVARCHAR(50) '  
	SET @Parameter += ', @SensorPNAttribute NVARCHAR(50) '  
	SET @Parameter += ', @SensorQtyAttribute NVARCHAR(50) '  
	SET @Parameter += ', @SensorLOTAttribute NVARCHAR(50) '  
	SET @Parameter += ', @SensorEDIReasonCodeAttribute NVARCHAR(50) '  
	SET @Parameter += ', @SensorExpiryDateAttribute NVARCHAR(50) '  
	SET @Parameter += ', @SamplingTypeAttribute NVARCHAR(50) '  
	SET @Parameter += ', @LibrePlantCode VARCHAR(50) '
	SET @Parameter += ', @FGPartNumber VARCHAR(50) '  ---gdlhugar 2021APR19	
   
 DECLARE @ret INT  

 EXEC @ret = SP_EXECUTESQL   
          @Query       = @Query  
         ,@Param       = @Parameter  
         ,@WorkOrderLOTAttribute   = @WorkOrderLOTAttribute  
         ,@ExpirationDateAttribute  = @ExpirationDateAttribute  
         ,@GRNRECExpirationDateAttribute = @GRNRECExpirationDateAttribute  
         ,@WorkOrderAttribute   = @WorkOrderAttribute  
         ,@ReasonCodeAttribute   = @ReasonCodeAttribute  
         ,@SensorPNAttribute    = @SensorPNAttribute  
         ,@SensorQtyAttribute   = @SensorQtyAttribute  
         ,@SensorLOTAttribute   = @SensorLOTAttribute  
         ,@SensorEDIReasonCodeAttribute = @SensorEDIReasonCodeAttribute  
         ,@SensorExpiryDateAttribute  = @SensorExpiryDateAttribute  
         ,@SamplingTypeAttribute   = @SamplingTypeAttribute
		 ,@LibrePlantCode = @LibrePlantCode		---gdlhugar 2021APR19
		 ,@FGPartNumber   =	@FGPartNumber		---gdlhugar 2021APR19	
		   
---- Section #2 gdlhugar 2021APR19 
 SET @Query = convert(nvarchar(max), N'') +convert(nvarchar(max), N'') +   
 N'insert into #tempSignalTblSkidAttributes(tempSignalTblID, attrno, attseq, attval, ref2skid)
SELECT id , @SensorExpiryDateAttribute, seq, Reserved_05 as SensorExpiryDate, null FROM #SensorData 
UNION ALL  
SELECT id , @LibrePlantCode, seq, Reserved_28 as LibrePlantCode, null FROM #SensorData 
UNION ALL  
SELECT id , @FGPartNumber, seq, Reserved_29 as FGPartNumber, null FROM #SensorData
'

 EXEC @ret = SP_EXECUTESQL   
          @Query       = @Query  
         ,@Param       = @Parameter  
         ,@WorkOrderLOTAttribute   = @WorkOrderLOTAttribute  
         ,@ExpirationDateAttribute  = @ExpirationDateAttribute  
         ,@GRNRECExpirationDateAttribute = @GRNRECExpirationDateAttribute  
         ,@WorkOrderAttribute   = @WorkOrderAttribute  
         ,@ReasonCodeAttribute   = @ReasonCodeAttribute  
         ,@SensorPNAttribute    = @SensorPNAttribute  
         ,@SensorQtyAttribute   = @SensorQtyAttribute  
         ,@SensorLOTAttribute   = @SensorLOTAttribute  
         ,@SensorEDIReasonCodeAttribute = @SensorEDIReasonCodeAttribute  
         ,@SensorExpiryDateAttribute  = @SensorExpiryDateAttribute  
         ,@SamplingTypeAttribute   = @SamplingTypeAttribute
		 ,@LibrePlantCode = @LibrePlantCode		---gdlhugar 2021APR19
		 ,@FGPartNumber   =	@FGPartNumber		---gdlhugar 2021APR19	
  
   
DELETE #tempSignalTblSkidAttributes WHERE ISNULL(attval ,'') = ''  

--SELECT T.*, P.SerialNumber 
--FROM #tempSignalTblSkidAttributes t
--join ffPackage p on p.id= t.tempSignalTblID

--WHERE attrno = 32

DROP TABLE IF EXISTS #T
DROP TABLE IF EXISTS #BaanResults
DECLARE @List VARCHAR(MAX)
DECLARE @TSQL varchar(MAX)
CREATE TABLE #BaanResults (SKID	INT,Item	VARCHAR(200),Warehouse	VARCHAR(200),Ref2SKID VARCHAR(200),	[Inv On Hand] INT,	[Inv on Hold] INT,	[Inv allocated] INT,	[Inv on Order] INT, 	[Attribute Number] INT,	Sequence INT,	Value VARCHAR(200))

SELECT DISTINCT P.SerialNumber
INTO #T
FROM #tempSignalTblSkidAttributes t
join ffPackage p on p.id= t.tempSignalTblID

WHILE (SELECT Count(*) FROM #T) > 0
BEGIN
SET @TSQL = NULL
SET @List = NULL

SELECT TOP 100 @List = COALESCE(@List + ''''',''''' , '''''') + SerialNumber
FROM #T ORDER BY SerialNumber

SELECT @List = @List + ''''''

SELECT @TSQL = 'select * from openquery([AM3P1],''select skids.t$mnum "SKID", TRIM(skids.t$item) "Item", inv.t$cwar "Warehouse", skids.t$cref "Ref2SKID", inv.t$stks "Inv On Hand", inv.t$stkh "Inv on Hold", Inv.T$stka "Inv allocated", Inv.T$stko "Inv on Order",
Attri.T$attr "Attribute Number", Attri.T$seqn "Sequence", attri.t$cval "Value"
from baan.tfxinh051768 skids 
left join baan.tfxinh040768 attri on skids.t$item = attri.t$item and skids.t$idat = attri.t$idat
left join baan.twhinr140768 inv on skids.t$item = inv.t$item and skids.t$idat = inv.t$idat
where skids.t$cref IN (' + @List + ') AND Attri.T$attr NOT IN (''''44'''', ''''102'''')'');'

PRINT @TSQL

INSERT INTO #BaanResults
EXEC (@TSQL)

;WITH CTE AS
(SELECT TOP 100 *
FROM #T Order BY SerialNumber
)
DELETE FROM CTE

END

select 
t.*
,p.SerialNumber
,PO.ProductionOrderNumber
,'-->' AS [Begin Baan Data]
,B.Skid
,B.Ref2SKID
,B.[Attribute Number]
,B.Sequence
,B.Value  
--,CASE WHEN p.SerialNumber = B.Ref2Skid THEN 'Pallet Match'
--	ELSE 'Pallet Missmatch' End As [Pallet Match]
,CASE WHEN t.attval = B.Value THEN 'Match'
	ELSE 'Mismatch/Missing' End As [AttValue Match]
from 
#tempSignalTblSkidAttributes t
INNER join ffPackage p 
	on p.id= t.tempSignalTblID
INNER JOIN ffProductionOrder PO
	ON PO.ID = P.CurrProductionOrderID
LEFT JOIN #BaanResults B
	ON B.Ref2SKID = P.SerialNumber AND B.[Attribute Number] = T.attrno AND B.Sequence = T.attseq

--WHERE P.SerialNumber IN (SELECT SerialNumber FROM #T)

--WHERE t.attval != B.Value

ORDER BY P.SerialNumber, T.attrno, T.attseq