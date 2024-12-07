--use p_REP_LIBRE_FF
--GO

DROP TABLE #T
GO

DROP TABLE #TD
GO

DROP TABLE #TT
GO

DROP TABLE #TTD
GO

DROP TABLE #R
GO

DROP TABLE #TTT
go

CREATE TABLE #T
(
	SignalXMLID  	bigint
	,Src_Warehouse  	varchar(200)
	,Dest_Warehouse  	varchar(200)
	,ffHistoryID	bigint
	,UnitID	int
);

CREATE TABLE #TD
(
	SignalXMLID  	bigint
	,Src_Warehouse  	varchar(200)
	,Dest_Warehouse  	varchar(200)
	,ffHistoryID	bigint
	,UnitID	int
);

CREATE TABLE #TT
(
	ffHistoryID 	bigint
	,UnitID 	int
	,SignalRefNumber 	varchar(200)
	,CreateDt 	datetime
	,[XMLContent] 	xml
	,[FileName] 	varchar(100)
	,ID 	bigint
	,SignalTypeID 	int
	,SignalID 	bigint

);

CREATE TABLE #TTD
(
	ffHistoryID 	bigint
	,UnitID 	int
	,SignalRefNumber 	varchar(200)
	,CreateDt 	datetime
	,[XMLContent] 	xml
	,[FileName] 	varchar(200)
	,ID 	bigint
	,SignalTypeID 	int
	,SignalID 	bigint
	,Position VARCHAR(100)
	,ref2skid VARCHAR(100)
	,item VARCHAR(100)
	--,attrno VARCHAR(100)
	--,attseq VARCHAR(100)
	--,attval VARCHAR(100)
	--,StockPoint XML
);

CREATE TABLE #R
(
fbitRESPID	bigint
,ToSignalTypeID	int
,ToSignalRefNumber	varchar(200)
,CreateDt	datetime
,Position	VARCHAR(100)
,[Status]	VARCHAR(100)
,[ErrorText]	VARCHAR(200)
);

CREATE TABLE #TTT
(
	ffHistoryID bigint
	,UnitID int
	,SignalRefNumber varchar(200)
	,item varchar(100)
	,SignalCreateDt datetime
	,FileName varchar(200)
	,ref2skid varchar(100)
	,Position varchar(100)
	,Status varchar(100)
	,ErrorText varchar(400)
);


--- GET UNITS WITH INVMOV signal
--INSERT INTO #T
--SELECT DISTINCT bl.SignalXMLID ,bl.Src_Warehouse ,bl.Dest_Warehouse ,bl.ffHistoryID ,bl.UnitID
--FROM udtfbitLibreINVMOV bl WITH(nolock)
--INNER JOIN ffPart p WITH(nolock) ON bl.PartID = p.ID
--INNER JOIN fbitSignalXML sxml WITH(nolock) ON bl.SignalXMLID = sxml.ID
--WHERE --bl.UnitID = -2058161573   --<-------------------------------------------CHANGE THE UNITID HERE
	--p.PartNumber = 'THRL-PRT23200-750' AND
	--bl.Src_Warehouse = '768086' AND bl.Dest_Warehouse = '768076'
INSERT INTO #T
SELECT DISTINCT bl.SignalXMLID ,bl.Src_Warehouse ,bl.Dest_Warehouse ,bl.ffHistoryID ,bl.UnitID
FROM udtfbitLibreINVMOV bl WITH(nolock)
INNER JOIN ffUnit u WITH(nolock) ON bl.UnitID = u.ID 
INNER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
WHERE po.ProductionOrderNumber = 'C5B000263'





--- TO AVOID DUPLICATES
INSERT INTO #TD
SELECT t.*
FROM #T t
INNER JOIN (
SELECT UnitID ,MAX(ffHistoryID) ffHistoryID 
FROM #T
GROUP BY UnitID 
) tt ON t.ffHistoryID = tt.ffHistoryID AND t.UnitID = tt.UnitID


-- GETTING THE XML FILE CONTENT
INSERT INTO #TT
SELECT
	tt.ffHistoryID
	,tt.UnitID
	,s.SignalRefNumber
	,s.CreateDt
	,sx.Content [XMLContent]
	,sx.[FileName] 
	,s.ID
	,s.SignalTypeID
	,sx.SignalID
FROM #TD tt
INNER JOIN [fbitSignalXML] sx WITH(nolock) ON tt.SignalXMLID = sx.ID
LEFT OUTER JOIN [fbitSignal] s WITH(nolock) ON sx.SignalID = s.ID


----- SEARCH RESPONSES
INSERT INTO #R
SELECT rr.ID fbitRESPID
	,rr.ToSignalTypeID
	,rr.ToSignalRefNumber
	,rr.CreateDt
	,t.s.value('rpos[1]','VARCHAR(100)') as Position
	,t.s.value('status[1]','VARCHAR(100)') as [Status]
	,t.s.value('err_text[1]','VARCHAR(200)') as [ErrorText]
FROM fbitRESP rr cross apply Content.nodes('/flxint/app/data/rec') t(s) 
WHERE rr.ID IN 
	(
		select DISTINCT 
			r.ID
		from fbitRESP r 
		INNER JOIN #TT t ON r.ToSignalRefNumber = t.SignalRefNumber AND r.ToSignalTypeID = t.SignalTypeID
		
	)

---- MERGE SIGNAL AND RESPONSES
insert INTO #TTT
SELECT DISTINCT  
	t.ffHistoryID
	,t.UnitID
	,t.SignalRefNumber
	,'N/A'
	,t.CreateDt SignalCreateDt
	,t.FileName
	,'N/A' 
	,'N/A'
	,r.Status
	,r.ErrorText
FROM #TT t
LEFT OUTER JOIN #R r ON t.SignalRefNumber = r.ToSignalRefNumber 




--000073539
--SELECT SignalRefNumber ,SignalCreateDt ,FileName ,Status ,ErrorText ,COUNT(UnitID) UnitQty
--FROM #TTT
--GROUP BY SignalRefNumber ,SignalCreateDt ,FileName ,Status ,ErrorText 

--SELECT SignalRefNumber ,SignalCreateDt ,FileName ,Status ,ErrorText ,COUNT(UnitID) UnitQty
--FROM #TTT
--WHERE SignalRefNumber NOT IN(
--SELECT DISTINCT SignalRefNumber FROM #TTT 
--WHERE Status = 'NACK') AND Status = 'ACK'
--GROUP BY SignalRefNumber ,SignalCreateDt ,FileName ,Status ,ErrorText 

--UNION
SELECT *
FROM #TTT
WHERE Status = 'NACK'

select Src_Warehouse ,Dest_Warehouse ,bl.ExtOtyp ,COUNT(bl.UnitID)
from udtfbitLibreINVMOV bl with(nolock)
inner join #TTT on #TTT.ffHistoryID = bl.ffHistoryID and #TTT.UnitID = bl.UnitID
where #TTT.Status = 'NACK'
GROUP BY  Src_Warehouse ,Dest_Warehouse ,bl.ExtOtyp

--DROP TABLE #Final
--go

--CREATE TABLE #Final
--(
--	ID INT IDENTITY(1,1)
--	,ffHistoryID	bigint
--	,UnitID	int
--);

--INSERT INTO #Final
--select Distinct bl.ffHistoryID ,bl.UnitID
--from udtfbitLibreINVMOV bl with(nolock)
--inner join #TTT on #TTT.ffHistoryID = bl.ffHistoryID and #TTT.UnitID = bl.UnitID
--where #TTT.Status = 'NACK' 
----AND bl.Src_Warehouse = '768086' 
----AND bl.Dest_Warehouse = '768B06'

--select * from #Final


--begin tran

--INSERT INTO ffHistory
--SELECT 
--	h.UnitID 
--	,h.UnitStateID
--	,h.EmployeeID
--	,h.StationID
--	,h.EnterTime
--	,h.ExitTime
--	,h.ProductionOrderID
--	,h.PartID
--	,h.LooperCount
--	,h.TaskComplete
--	,h.Quantity
--	,h.RMAID
--FROM 
--(
--SELECT DISTINCT ffHistoryID ,UnitID 
--FROM #Final
----WHERE ID >= 1 AND ID < 2000
--) a  
--INNER JOIN ffHistory h WITH(nolock) ON a.ffHistoryID = h.ID AND a.UnitID = h.UnitID


--rollback tran

