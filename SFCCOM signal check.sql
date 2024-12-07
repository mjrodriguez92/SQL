/***********************************************************************************************************************************************************          
Author: Santos Morales (bfgsmora)
Creation Date: 2020-11-25  
Explanation: Get SFCCOM Information their signal and response
Parameter: None  
Output: Return skids information  
Is used: Libre all Factories  
  
Version		Date		FlexPM Task		Author				Description                        
-------		----------  ------------	--------------		------------------------------------                        
1.0			2020-11-25	None			Santos Morales		INITIAL VERSION  
***************************************************************************************************************************************************************/      


------- DELETE TEMPORAL TABLES IF EXISTS
DROP TABLE IF EXISTS #SFCCOM;
DROP TABLE IF EXISTS #Resp;

DECLARE @WO varchar(50)
SET @WO = 'KTP000917'

SELECT
	sxml.id SXMLID,
	t.s.value('../../sigref[1]','VARCHAR(MAX)') as sigref,
	t.s.value('rpos[1]','VARCHAR(MAX)') as rpos,
	t.s.value('orno[1]','VARCHAR(MAX)') as orno,
	t.s.value('item[1]','VARCHAR(MAX)') as item,
	t.s.value('qty_deliver[1]','int') as qty_deliver,
	t.s.value('qty_reject[1]','int') as qty_reject,
	sxml.SignalID,
	sxml.CreateDt,
	sxml.SignalTypeID
INTO #SFCCOM
FROM
(
	SELECT distinct com.ProductionOrderID ,com.PartID ,com.SignalXMLID
	FROM udtfbitSFCCOM com WITH(nolock)
	INNER JOIN ffProductionOrder po WITH(nolock) ON com.ProductionOrderID = po.ID
	WHERE po.ProductionOrderNumber = @WO  
) c
INNER JOIN fbitSignalXML sxml WITH(NOLOCK) CROSS APPLY sxml.Content.nodes('/flxint/app/data/rec') t(s) ON c.SignalXMLID = sxml.id
WHERE sxml.SignalTypeID = 12 


SELECT 
	r.ID fbitRESPID,
	r.ToSignalTypeID,
	r.ToSignalRefNumber,
	t.s.value('../../sigref[1]','VARCHAR(MAX)') as Resp_sigref,
	t.s.value('rpos[1]','VARCHAR(MAX)') as Resp_rpos,
	t.s.value('status[1]','VARCHAR(MAX)') as Resp_status,
	t.s.value('msg[1]','VARCHAR(MAX)') as Resp_msg,
	r.CreateDt RespCreateDt
INTO #Resp
FROM fbitRESP r WITH(NOLOCK) CROSS APPLY r.Content.nodes('/flxint/app/data/rec') t(s)
WHERE r.ID IN 
(
	SELECT DISTINCT r.ID
	FROM fbitRESP r WITH(nolock)
	INNER JOIN #SFCCOM sxml WITH(nolock) ON r.ToSignalRefNumber = sxml.sigref AND r.ToSignalTypeID = sxml.SignalTypeID
)


SELECT 
	sxml.SXMLID, 
	sxml.sigref,
	sxml.rpos,
	sxml.orno WO,
	sxml.item Item,
	sxml.qty_deliver,
	sxml.qty_reject,
	sxml.CreateDt,
	r.Resp_status,
	r.Resp_msg,
	r.RespCreateDt
FROM #SFCCOM sxml
LEFT OUTER JOIN #Resp r ON sxml.sigref = r.ToSignalRefNumber AND sxml.SignalTypeID = r.ToSignalTypeID AND sxml.rpos = r.Resp_rpos
WHERE sxml.orno = @WO


SELECT 
	SUM(sxml.qty_deliver) qty_Deliver
FROM #SFCCOM sxml
LEFT OUTER JOIN #Resp r ON sxml.sigref = r.ToSignalRefNumber AND sxml.SignalTypeID = r.ToSignalTypeID AND sxml.rpos = r.Resp_rpos
WHERE sxml.orno = @WO

SELECT *
FROM ffProductionOrder po WITH(nolock)
INNER JOIN ffLineOrder lo WITH(nolock) ON po.ID = lo.ProductionOrderID
WHERE ProductionOrderNumber = @WO

--sp_helptext ruspCheckSFCCOM
--sp_helptext ruspSummarySFCCOM

--  /*    
--  declare @Order varchar(100)  
--  set @Order = 'C50000065'  
--  */  
  
--  declare @TotalCompleted int  
--  declare @TotalSent int  
--  declare @TotalSentRejected int  
--  declare @ClosedFlagSent varchar(100)  
--  declare @SignalsNACK int  
--  declare @Unresponded int  
  
--  select @TotalCompleted = count(distinct u.ID)  
--    from ffProductionOrder o   
--    join ffhistory h on o.ID = h.ProductionOrderID  
--    join ffUnit u on h.UnitID = u.ID  
--   where o.ProductionOrderNumber = @Order  
--     and u.StatusID = 1  
--   group by o.ProductionOrderNumber  
--   order by o.ProductionOrderNumber  
  
--  if object_id('tempdb..#Signals') is not null  
--   drop table #Signals  
  
--  create table #Signals (ID int not null identity(1,1), SignalID bigint, SigRef varchar(100), Qty int, ClosedFlag int, [Status] varchar(100))  
  
--  insert into #Signals (SigRef, SignalID, Qty, ClosedFlag, [Status])  
--  select x.Content.value('(flxint/app/sigref)[1]','varchar(100)') SigRef,  
--      x.id,  
--      t.s.value('(qty_deliver)[1]','int') Qty,   
--      t.s.value('(close)[1]','int') ClosedFlag,  
--      case when r.Content.value('(flxint/app/status)[1]','varchar(100)') is null then r.Content.value('(flxint/app/data/rec/status)[1]','varchar(100)') else r.Content.value('(flxint/app/status)[1]','varchar(100)') end [Status]  
--    from fbitSignalXML x with (nolock) cross apply x.Content.nodes('/flxint/app/data/rec') t(s)  
--    left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 12  
--   where x.SignalTypeID = 12  
--     and t.s.value('(orno)[1]','varchar(100)') = @Order  
   
--  /* Get the duplicated NACKS and deleted fro the result set */  
--  delete   
--    from #Signals  
--   where [Status] = 'NACK'  
--     and SigRef in (select Sigref from #Signals where [Status] = 'ACK')  
    
--  select @ClosedFlagSent = case when max(ClosedFlag) = 1 then 'YES' else 'NO' end  
--    from #Signals s  
  
--  select @TotalSent = sum(Qty)   
--    from #Signals s  
--   where [Status] = 'ACK'  
  
--  select @Unresponded = count(s.ID)   
--    from #Signals s  
--   where isnull([Status],'') = ''  
  
--  select @TotalSentRejected = sum(Qty), @SignalsNACK = count(s.ID)   
--    from #Signals s  
--   where [Status] = 'NACK'  
  
--  set @TotalSent = isnull(@TotalSent,0)  
--  set @TotalSentRejected = isnull(@TotalSentRejected,0)  
  
--  if object_id('tempdb..#Signals') is not null  
--   drop table #Signals  
  
--  select @Order OrderNumber, @TotalCompleted TotalCompleted, @TotalSent TotalSent, @ClosedFlagSent ClosedFlag, @TotalSentRejected TotalRejected, @SignalsNACK SignalNACK, @Unresponded UnResponse  


 -- ===================================  
 DECLARE @Datetime    DATETIME  
  
 DECLARE @PFID_KTP    INT  
 DECLARE @POD_ID_KPPOCompleted INT  
  
 DECLARE @STS_PO_RELEASED  INT  
 DECLARE @STS_PO_ACTIVE   INT  
 DECLARE @STS_PO_COMPLETE  INT  
 DECLARE @STS_PO_FORCECLOSE  INT  
  
 DECLARE @O2PStation    INT  
 DECLARE @STPSTAStation   INT   
 Declare @SFCCOMUnitType   INT  
  
  
 IF OBJECT_ID('tempdb..#PO_Candidates') IS NOT NULL  
  DROP TABLE #PO_Candidates  
  
 CREATE TABLE #PO_Candidates  
 (  
  ID  INT IDENTITY(1,1),  
  POID INT  
 )  
  
 -- ===================================  
 --            INIT  
 -- ===================================  
 SET @Datetime    = GETDATE()  
 SET @PFID_KTP    = 0  
 SET @POD_ID_KPPOCompleted = 0  
  
 SET @PFID_KTP    = (SELECT ID FROM luPartFamily WITH(NOLOCK) WHERE [Name] = 'KTP')  
 SET @POD_ID_KPPOCompleted = (SELECT ID FROM luProductionOrderDetailDef WITH(NOLOCK) WHERE [Description] = 'KP_PO_Completed')  
  
 SET @STS_PO_RELEASED  = (SELECT ID FROM luProductionOrderStatus WITH(NOLOCK) WHERE [Description] = 'Released')  
 SET @STS_PO_ACTIVE   = (SELECT ID FROM luProductionOrderStatus WITH(NOLOCK) WHERE [Description] = 'Active')  
 SET @STS_PO_COMPLETE  = (SELECT ID FROM luProductionOrderStatus WITH(NOLOCK) WHERE [Description] = 'Completed')  
 SET @STS_PO_FORCECLOSE  = (SELECT ID FROM luProductionOrderStatus WITH(NOLOCK) WHERE [Description] = 'Force-Closed')  
  
 -- ** Variables for STPSTA Siganl  
 SET @O2PStation    = (SELECT ID FROM ffStationType WITH(NOLOCK) WHERE [Description] ='KP_Move_Release_to_O2P')  
 SET @STPSTAStation   = (SELECT ID FROM ffStationType WITH(NOLOCK) WHERE [Description] ='KP_Stpsta')  
 SET @SFCCOMUnitType   = (SELECT ID FROM udtfbitLuSFCCOMType WITH(NOLOCK) WHERE [type] ='UnitBackflush')  
  
 -- ===================================  
 --            LOGIC  
 -- ===================================  
-- INSERT INTO #PO_Candidates  
 SELECT  
  LO.ProductionOrderID ,po.ProductionOrderNumber , MAX(lo.ReadyQuantity) ReadyQty, COUNT(s.UnitID) QtySFCCOM  
 FROM   
  udtfbitSFCCOM S (NOLOCK)  
  JOIN fbitSignalXML SX (NOLOCK)  
   ON SX.ID = S.SignalXMLID AND   
      SX.StatusID NOT IN (1,2) -- 1=NEW, 2=In Progress, 3=Completed (fbitLuStatus, TableName = 'fbitSignalXML').  
  JOIN ffLineOrder LO WITH(NOLOCK)  
   ON S.ProductionOrderID = LO.ProductionOrderID   
  JOIN ffProductionOrder PO WITH(NOLOCK)   
   ON PO.ID = LO.ProductionOrderID  
  JOIN ffProductionOrderDetail POD WITH(NOLOCK)   
   ON POD.ProductionOrderID = PO.ID AND   
    pod.ProductionOrderDetailDefID = @POD_ID_KPPOCompleted AND   
    ISNULL(POD.Content,'') = '0'  
  JOIN ffPart P WITH(NOLOCK)  
   ON PO.PartID = P.ID AND   
    P.PartFamilyID = @PFID_KTP  
 WHERE   
  PO.StatusID in (@STS_PO_RELEASED,@STS_PO_ACTIVE) AND  
  S.TypeID = @SFCCOMUnitType AND --Only consider unit Backflush  
  LO.ReadyQuantity > 0  
 GROUP BY   
  LO.ProductionOrderID, po.ProductionOrderNumber  
   