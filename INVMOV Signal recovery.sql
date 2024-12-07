--use p_REP_LIBRE_FF
--GO

DROP TABLE #T;
DROP TABLE #TD;
DROP TABLE #TT;
DROP TABLE #TTD;
DROP TABLE #DataSXML;
DROP TABLE #R;
DROP TABLE #TTT;
DROP TABLE #LR;

CREATE TABLE #T
(
	SignalXMLID  	bigint
	,Src_Warehouse  	varchar(200)
	,Dest_Warehouse  	varchar(200)
	,ffHistoryID	bigint
	,UnitID	int
	,PartID int
	,PartNumber varchar(200)
);

CREATE TABLE #TD
(
	SignalXMLID  	bigint
	,Src_Warehouse  	varchar(200)
	,Dest_Warehouse  	varchar(200)
	,ffHistoryID	bigint
	,UnitID	int
	,PartID int
	,PartNumber varchar(200)
);

CREATE TABLE #TT
(
	ffHistoryID 	bigint
	,UnitID 	int
	,SignalRefNumber 	varchar(200)
	,CreateDt 	datetime
	,UpdateDt 	datetime
	,[XMLContent] 	xml
	,[FileName] 	varchar(100)
	,ID 	bigint
	,SignalTypeID 	int
	,SignalID 	bigint
	,PartID int
	,PartNumber varchar(200)
);

CREATE TABLE #DataSXML
(
	SignalID bigint
	,UnitID int
	,ffHistoryID int
	,sigref VARCHAR(100)
	,Position VARCHAR(100)
	,ext_otyp VARCHAR(100)
	,ref2skid VARCHAR(100)
	,item VARCHAR(100)
	,qty VARCHAR(100)
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
INSERT INTO #T
SELECT DISTINCT bl.SignalXMLID ,bl.Src_Warehouse ,bl.Dest_Warehouse ,bl.ffHistoryID ,bl.UnitID ,bl.PartID ,bl.PartNumber
FROM udtfbitLibreINVMOV bl WITH(nolock)
INNER JOIN ffPart p WITH(nolock) ON bl.PartID = p.ID
INNER JOIN fbitSignalXML sxml WITH(nolock) ON bl.SignalXMLID = sxml.ID
WHERE --bl.UnitID = -2125838371   --<-------------------------------------------CHANGE THE UNITID HERE
	--AND 
	p.PartNumber = 'THRL-71988-01F' --AND bl.Src_Warehouse = '768086' AND bl.Dest_Warehouse = '768B06' --OR bl.Dest_Warehouse = '768B07')
--INSERT INTO #T
--SELECT DISTINCT bl.SignalXMLID ,bl.Src_Warehouse ,bl.Dest_Warehouse ,bl.ffHistoryID ,bl.UnitID
--FROM udtfbitLibreINVMOV bl WITH(nolock)
--INNER JOIN ffUnit u WITH(nolock) ON bl.UnitID = u.ID 
--INNER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
--WHERE po.ProductionOrderNumber = 'C5B000162'


--SELECT * FROM #T
--SELECT * FROM #TD

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
	,s.UpdateDt
	,sx.Content [XMLContent]
	,sx.[FileName] 
	,s.ID
	,s.SignalTypeID
	,sx.SignalID
	,tt.PartID
	,tt.PartNumber
FROM #TD tt
INNER JOIN [fbitSignalXML] sx WITH(nolock) ON tt.SignalXMLID = sx.ID 
LEFT OUTER JOIN [fbitSignal] s WITH(nolock) ON sx.SignalID = s.ID

--INSERT INTO #DataSXML
--SELECT DISTINCT 
--	d.ffHistoryID ,d.UnitID ,d.SignalRefNumber ,d.CreateDt ,d.UpdateDt ,d.FileName ,d.ID ,d.SignalTypeID ,d.SignalID ,d.PartID ,d.PartNumber 
--	--d.SignalID ,d.UnitID ,d.ffHistoryID
--	,t.s.value('../../../../sigref[1]','VARCHAR(100)') as sigref
--	,t.s.value('../../rpos[1]','VARCHAR(100)') as Position
--	,t.s.value('../../ext_otyp[1]','VARCHAR(100)') as ext_otyp
--	,t.s.value('ref2skid[1]','VARCHAR(100)') as ref2skid
--	,t.s.value('item[1]','VARCHAR(100)') as item
--	,t.s.value('qty[1]','VARCHAR(100)') as qty
--FROM #TT d cross apply XMLContent.nodes ('/flxint/app/data/rec/stockpoints/stockpoint') t(s) 
--WHERE d.PartNumber = t.s.value('item[1]','VARCHAR(100)')

--SELECT * FROM #TT
--WHERE UnitID = -2125838371

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
		--SELECT r.*
		from fbitRESP r 
		INNER JOIN #TT t ON r.ToSignalRefNumber = t.SignalRefNumber AND r.ToSignalTypeID = t.SignalTypeID
	)

------------ LAST RESPONSE

SELECT r.fbitRESPID ,r.ToSignalTypeID ,r.ToSignalRefNumber ,r.CreateDt ,r.Position ,r.Status ,r.ErrorText
INTO #LR
FROM #R r
INNER JOIN 
(
	SELECT ToSignalRefNumber ,ToSignalTypeID ,MAX(fbitRESPID) fbitRESPID
	FROM #R 
	WHERE Status = 'NACK'
	GROUP BY ToSignalRefNumber ,ToSignalTypeID
) rr ON r.fbitRESPID = rr.fbitRESPID AND r.ToSignalRefNumber = rr.ToSignalRefNumber AND r.ToSignalTypeID = rr.ToSignalTypeID 
WHERE Status = 'NACK'



---- MERGE SIGNAL AND RESPONSES
insert INTO #TTT
SELECT DISTINCT  
	t.ffHistoryID
	,t.UnitID
	,t.SignalRefNumber
	,t.PartNumber
	,t.CreateDt SignalCreateDt
	,t.FileName
	,'N/A' 
	,'N/A'
	,r.Status
	,r.ErrorText
FROM #TT t
INNER JOIN #LR r ON t.SignalRefNumber = r.ToSignalRefNumber AND t.SignalTypeID = r.ToSignalTypeID


--SELECT * FROM #TT t WHERE SignalRefNumber = '000214392' 
--SELECT * FROM #LR WHERE ToSignalRefNumber = '000214392'

DROP TABLE #UnitINVMOV;
DROP TABLE #UnitINVMOVtoSend;

CREATE TABLE #UnitINVMOV
(
	ID int IDENTITY(1,1)
	,ffHistoryID int
	,UnitID int 
	,SignalRefNumber varchar(200)
	,PartID int 
	,PartNumber varchar(200)
	,Src_Warehouse varchar(10)
	,Dest_Warehouse varchar(10) 
	,FileName varchar(200)
	,ref2skid varchar(100)
	,Position varchar(100)
	,Status varchar(5) 
	,ErrorText varchar(MAX)
	,SignalXMLID int
)

CREATE TABLE #UnitINVMOVtoSend
(
	ID int IDENTITY(1,1)
	,ffHistoryID int
	,UnitID int 
)

INSERT INTO #UnitINVMOV
SELECT DISTINCT ttt.ffHistoryID ,ttt.UnitID ,ttt.SignalRefNumber ,t.PartID ,t.PartNumber ,t.Src_Warehouse ,t.Dest_Warehouse ,ttt.FileName ,ttt.ref2skid ,ttt.Position ,ttt.Status ,ttt.ErrorText ,t.SignalXMLID
FROM #TTT ttt
INNER JOIN #TD t ON ttt.ffHistoryID = t.ffHistoryID AND ttt.UnitID = t.UnitID

SELECT 
	Src_Warehouse
	,Dest_Warehouse 
	--,Status 
	--,ErrorText 
	,COUNT(UnitID) UnitQty
FROM #UnitINVMOV
GROUP BY Src_Warehouse
	,Dest_Warehouse 
	--,Status 
	--,ErrorText 
 
 

 INSERT INTO #UnitINVMOVtoSend
 SELECT ffHistoryID ,UnitID
 FROM #UnitINVMOV
-- WHERE Src_Warehouse = '768073' and Dest_Warehouse = '768072'


 SELECT * FROM #UnitINVMOVtoSend


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
 

-- 89452 total

SELECT t.PartNumber, t.SignalRefNumber ,td.Src_Warehouse ,td.Dest_Warehouse ,t.FileName ,COUNT(u.UnitID) Qty
FROM 
(
	SELECT 
		h.ID ffHistoryID
		,h.UnitID 
		,h.UnitStateID
		,h.EmployeeID
		,h.StationID
		,h.EnterTime
		,h.ExitTime
		,h.ProductionOrderID
		,h.PartID
		,h.LooperCount
		,h.TaskComplete
		,h.Quantity
		,h.RMAID
	FROM 
	(
	SELECT DISTINCT ffHistoryID ,UnitID 
	FROM #UnitINVMOVtoSend
	WHERE ID >= 1 AND ID < 10000
	--WHERE ID >= 10000 AND ID < 20000
	--WHERE ID >= 20000 AND ID < 40000
	--WHERE ID >= 40000 ---AND ID < 21000
	--WHERE ID >= 21000 AND ID < 28000
	--WHERE ID >= 28000 --AND ID < 28000
	) a  
	INNER JOIN ffHistory h WITH(nolock) ON a.ffHistoryID = h.ID AND a.UnitID = h.UnitID
) u
--INNER JOIN #UnitINVMOVtoSend us ON u.ffHistoryID = us.ffHistoryID and u.UnitID = us.UnitID
INNER JOIN #TT t ON u.ffHistoryID = t.ffHistoryID AND u.UnitID = t.UnitID 
INNER JOIN #TD td ON u.ffHistoryID = td.ffHistoryID AND u.UnitID = td.UnitID 
group by t.PartNumber, t.SignalRefNumber ,td.Src_Warehouse ,td.Dest_Warehouse ,t.FileName


begin tran

INSERT INTO ffHistory
SELECT 
	h.UnitID 
	,h.UnitStateID
	,h.EmployeeID
	,h.StationID
	,h.EnterTime
	,h.ExitTime
	,h.ProductionOrderID
	,h.PartID
	,h.LooperCount
	,h.TaskComplete
	,h.Quantity
	,h.RMAID
FROM 
(
SELECT DISTINCT ffHistoryID ,UnitID 
FROM #UnitINVMOVtoSend
WHERE ID >= 1 AND ID < 10000
--WHERE ID >= 10000 AND ID < 20000
--WHERE ID >= 20000 AND ID < 40000
--WHERE ID >= 40000 --AND ID < 21000
--WHERE ID >= 21000 AND ID < 28000
--WHERE ID >= 28000 --AND ID < 28000
) a  
INNER JOIN ffHistory h WITH(nolock) ON a.ffHistoryID = h.ID AND a.UnitID = h.UnitID


rollback tran

