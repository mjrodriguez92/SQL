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
SET @WO = 'KTP000774'

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
  