--Need details of all the sensor container work order manufactured from 08/17/2020. Need the following info:
--1. Sensor container WO. 
--2. Line number. 
--3. Production start date.
--4. Quantity.
--Ticket # 3297340


--GETTING TRAYS AND LOOPER COUNTS BY DATE--

SELECT distinct sn.Value as TrayNumber, MAX(mud.LooperCount) as LooperCount, ffline.Description AS Line, po.ActualStartTime,ffLineOrder.ReadyQuantity 
from ffProductionOrder po with(nolock)
inner join ffLineOrder with(nolock) on ffLineOrder.Description = po.ProductionOrderNumber
inner join ffLine with(nolock) on ffLine.ID = ffLineOrder.LineID
inner join ffMaterialUnitDetail mud with(nolock) on mud.Reserved_04 = po.ProductionOrderNumber
inner join ffUnit u with(nolock) on u.LineID = ffLine.ID
inner join udtTrayHistory th WITH(NOLOCK) ON u.PanelID = th.UnitID
inner join ffSerialNumber sn WITH(NOLOCK) ON u.PanelID = sn.UnitID

--CHANGE DATE HERE as needed to request details from that time period
where po.ActualStartTime between '2020-05-31 00:00:00.000' and '2020-09-01 00:00:00.000' and ProductionOrderNumber like 'C%'
GROUP BY sn.Value, po.ProductionOrderNumber, ffline.Description, po.ActualStartTime, ffLineOrder.ReadyQuantity 


--GETTING SENSOR CONTAINER WO INFO--

SELECT MAX(po.ProductionOrderNumber) as ContainerWO, po.ActualStartTime as StartDate
from ffProductionOrder po with(nolock)

inner join ffMaterialUnitDetail mud with(nolock) on mud.Reserved_04 = po.ProductionOrderNumber
where po.ActualStartTime between '2020-05-31 00:00:00.000' and '2020-09-01 00:00:00.000' and ProductionOrderNumber like 'C%'
GROUP BY po.ActualStartTime

sp_helptext rptePurgeDashbard01

/*  
=================================================================  
  
    ACTUAL VERSION: 01.03.00  
  
 VERSION: 01.03.00  
 AUTHOR: Fernando Melchor   
 CREATION DATE:  2020-01-16  
 DESCRIPTION:   
 Reset Purge Transaction Date green—yellow—red color code system:  
  Green: Less than 12 hours  
  Yellow: Between 12 and 24 hours  
  Red: Greater than 24 hours  
  
 VERSION: 01.02.00  
 AUTHOR: Fernando Melchor   
 CREATION DATE:  2020-01-07  
 DESCRIPTION:   
  1. Correct the misspelling in the column G (ACTION CLASSIFICATION)  
  2. Add a sort order first by Warehouse second by purge ID  
  3. Add the time stamp for the record showed  
  
 VERSION: 01.00.00  
 AUTHOR: Fernando Melchor   
 CREATION DATE:  2019-11-13  
 DESCRIPTION: Initial Version  
  
 PARAMETERS:  
  
   @LoadNumber :  
      BAAN Load Number  
  
 EXAMPLE:  
  
   EXEC rptePurgeDashbard01  
=================================================================  
*/  
  
CREATE PROC [dbo].rptePurgeDashbard01  
AS  
SET NOCOUNT ON  
  
DECLARE  
  @sQuery     NVARCHAR(max),  
  @sOPENQuery    NVARCHAR(max),  
  @sLinkedServer   NVARCHAR(50),  
  @BannCompay    NVARCHAR(4),  
  @warehouseexcludelist NVARCHAR(MAX) = ''  
  
IF OBJECT_ID('TEMPDB..#tmp_PurgeDashbard') IS NOT NULL  
 DROP TABLE #tmp_PurgeDashbard  
  
 CREATE TABLE #tmp_PurgeDashbard  
  (  
   EPURGEID    NVARCHAR(100),  
   TRANDATE    DATETIME,  
   HOURDIF     INT,  
   PART     NVARCHAR(100),  
   SKIDID     NVARCHAR(100),  
   MNUM     INT,  
   SKIDQTY     INT,  
   BAANWHASE    NVARCHAR(100),  
   sLOCATION    NVARCHAR(100),  
   BLOC     NVARCHAR(100),  
   CLSD     NVARCHAR(100),  
   BLOCDESCRIPTION   NVARCHAR(100),  
   ITEM_DESC    NVARCHAR(200),  
   sITEM_TYPE    NVARCHAR(100),  
   BAANPURGEID    INT,  
   BAANWH_DESC    NVARCHAR(200)  
  )  
    
SELECT @sLinkedServer = +'['+LinkedServer+']' ,@BannCompay = BaanCompany from baanSyncData  
  
declare @tbl_excludewharehouse table (whType nvarchar(100), warehouse nvarchar(20), whDescription nvarchar(200))  
  
INSERT INTO @tbl_excludewharehouse (whType,warehouse,whDescription)  
select 'MRB','768170','MRB' UNION  
select 'Bonepile','768072','Bonepile to be Scrapped' UNION  
select 'Bonepile','768172','Bonepile to be Scrapped' UNION  
select 'Bonepile','768B02','Bonepile Molding' UNION  
select 'Bonepile','768B03','Bonepile SMT' UNION  
select 'Bonepile','768B04','Bonepile Puck' UNION  
select 'Bonepile','768B05','Bonepile Applicator' UNION  
select 'Bonepile','768B06','Bonepile Container' UNION  
select 'Bonepile','768B07','Bonepile Kit Pack' UNION  
select 'Scrap','768SC1','Scrap Warehouse'   
  
select @warehouseexcludelist = @warehouseexcludelist + '''''' + warehouse + '''''' + ',' from @tbl_excludewharehouse   
  
IF LEN(@warehouseexcludelist) > 0  
 SELECT @warehouseexcludelist = SUBSTRING(@warehouseexcludelist,1,LEN(@warehouseexcludelist)-1)  
  
   
SELECT @sQuery = '  
SELECT TRIM(fxinh401.t$eprd) AS EPURGEID,  
    TO_CHAR(FROM_TZ (CAST(fxinh400.T$DATE AS TIMESTAMP), ''''UTC'''') AT TIME ZONE ''''America/Chicago'''', ''''MM/DD/YYYY HH24:MI:SS'''')  AS TRANDATE,  
    round(to_number(Current_date - fxinh400.T$DATE)*24) AS HOURDIF,  
       TRIM(fxinh620.t$item) AS PART,  
       TRIM(fxinh051.t$cref) AS SKIDID,  
    fxinh620.t$mnum AS  MNUM,  
       whinr140.t$stks AS SKIDQTY,  
       TRIM(whinr140.t$cwar) AS BAANWHASE,   
       TRIM(whinr140.t$loca) AS LOCATION,  
       TRIM(fxinh620.t$BLOC) AS BLOC,  
       fxinh401.t$clsd AS CLSD,  
       NVL(TRIM(tcmcs005.t$DSCA),TRIM(fxinh401.T$bloc)) AS BLOCDESCRIPTION,  
    TRIM(TCIBD001.T$DSCA) AS ITEMDESCRIPTION,  
    DECODE(TCIBD001.T$KITM,1,''''PURCHASE'''',2,''''MANUFACTURED'''',3,''''GENERIC'''',4,''''COST'''',5,''''SERVICE'''',6,''''SUBCONTRACTING'''',10,''''LIST'''',15,''''EQUIPMENT'''') AS SITEM_TYPE,  
    fxinh400.t$prid AS BAANPURGEID,  
    TRIM(tcmcs003.T$DSCA) AS BAANWHASE_DESC  
FROM BAAN.Tfxinh400'+@BannCompay+' fxinh400 JOIN  
       BAAN.Tfxinh401'+@BannCompay+' fxinh401 ON  
          fxinh401.t$prid = fxinh400.t$prid AND  
          fxinh401.t$clsd = 2  LEFT JOIN       
      BAAN.Tfxinh620'+@BannCompay+' fxinh620 ON  
          fxinh620.t$PRID = fxinh401.t$PRID AND   
          fxinh620.t$PRID = fxinh401.t$PRID AND fxinh620.t$DDAT = TO_DATE(''''01/01/1970'''', ''''MM/DD/YYYY'''') LEFT JOIN                 
      BAAN.Tfxinh051'+@BannCompay+' fxinh051 ON            
        fxinh051.t$mnum = fxinh620.t$mnum LEFT JOIN           
      BAAN.Twhinr140'+@BannCompay+' whinr140 ON            
        whinr140.t$idat = fxinh051.t$idat LEFT JOIN         
      BAAN.Ttcmcs005'+@BannCompay+' tcmcs005 ON                      
        tcmcs005.t$CDIS = fxinh620.t$BLOC LEFT JOIN            
      BAAN.TTCIBD001'+@BannCompay+' TCIBD001 ON                
        fxinh620.t$item = TCIBD001.T$ITEM LEFT JOIN            
      BAAN.Ttcmcs003'+@BannCompay+' tcmcs003 ON                
      tcmcs003.T$CWAR = whinr140.t$cwar   
WHERE (TRIM(whinr140.t$cwar) is null OR TRIM(whinr140.t$cwar) not in ('+@warehouseexcludelist+') )  
GROUP BY fxinh401.t$eprd,fxinh400.t$prid, fxinh620.t$item, trim(fxinh051.t$cref), whinr140.t$cwar,whinr140.t$loca,whinr140.t$stks,fxinh620.t$mnum,tcmcs003.T$DSCA,             
  fxinh620.t$BLOC,fxinh401.t$clsd,fxinh401.t$PRID,fxinh400.T$DATE,TCIBD001.T$DSCA,fxinh620.t$PRID,TCIBD001.T$KITM,NVL(TRIM(tcmcs005.t$DSCA),TRIM(fxinh401.T$bloc))';  
  
SELECT @sOPENQuery = 'select * from openquery('+@sLinkedServer+','''+@sQuery+''')'  
  
IF ISNULL(@sOPENQuery,'') <> '' BEGIN  
  
 INSERT INTO #tmp_PurgeDashbard (EPURGEID,TRANDATE,HOURDIF, PART,SKIDID,MNUM,SKIDQTY,BAANWHASE,sLOCATION,BLOC,CLSD,BLOCDESCRIPTION,ITEM_DESC,sITEM_TYPE,BAANPURGEID,BAANWH_DESC)  
 EXEC (@sOPENQuery)  
   
END  
  
/*  
1. If ePurge type = "Purge & Hold for Review" then Action Classification in dashboard = “Quality Review”  
2. If ePurge type = "Purge & Scrap" then Action Classification in dashboard = “Scrap”  
*/  
  
SELECT r.BAANPURGEID,  
    r.EPURGEID,r.TRANDATE,r.HOURDIF,  
    r.PART,  
    r.sITEM_TYPE,  
    r.ITEM_DESC,  
    SKIDID = isnull(CASE WHEN r.sITEM_TYPE = 'MANUFACTURED' THEN r.SKIDID ELSE convert(nvarchar(100),r.MNUM) END,convert(nvarchar(100),r.MNUM)),  
    internalSKIDID = r.SKIDID,  
    r.MNUM,  
    r.SKIDQTY,  
    r.BAANWHASE,  
    BAANWH_DESC,  
    r.sLOCATION,  
    r.BLOC,  
    r.CLSD,  
    BLOCDESCRIPTION = CASE WHEN r.BLOCDESCRIPTION in ('PHR', 'Purge and Hold for Review') THEN 'Quality Review'  
         WHEN r.BLOCDESCRIPTION in ('PSC', 'Purge and Scrap') THEN 'Scrap'  
       ELSE r.BLOCDESCRIPTION  END,  
    ReturnBAANDest=0,   
    iIndicator = case when r.HOURDIF < = 12 then 1  
       when r.HOURDIF between 12 and 24 then 2  
       else 3  
     end  
FROM #tmp_PurgeDashbard r  
-- where r.EPURGEID = '768CUT0000011583'  
  
IF OBJECT_ID('TEMPDB..#tmp_PurgeDashbard') IS NOT NULL  
 DROP TABLE #tmp_PurgeDashbard  
  