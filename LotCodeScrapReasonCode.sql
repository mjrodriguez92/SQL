use p_rpt_LIBRE_FF
GO

DROP TABLE #TEM
GO

CREATE TABLE #TEM
(
	ID int NOT NULL IDENTITY(1,1),
	Lot varchar(50)
)
   
INSERT INTO #TEM SELECT 'LOT271119000000651'
INSERT INTO #TEM SELECT 'LOT271119000000652'
INSERT INTO #TEM SELECT 'LOT271119000000653'
INSERT INTO #TEM SELECT 'LOT271119000000654'
INSERT INTO #TEM SELECT 'LOT271119000000655'
INSERT INTO #TEM SELECT 'LOT271119000000656'
INSERT INTO #TEM SELECT 'LOT271119000000657'
INSERT INTO #TEM SELECT 'LOT271119000000658'
INSERT INTO #TEM SELECT 'LOT271119000000659'
INSERT INTO #TEM SELECT 'LOT271119000000660'




DECLARE @cwos int
DECLARE @cwoe int

SET @cwos = 1
SELECT @cwoe = MAX(ID) FROM #TEM

SELECT @cwos cwos, @cwoe cwoe

--SET @cwoe = 1
WHILE @cwos <= @cwoe
BEGIN

--to find the down reasons from FF
INSERT INTO dbo.udtMissingReasonCodes
SELECT DISTINCT
	bl.SignalXMLID, bl.Src_Warehouse, bl.Dest_Warehouse, bl.PartID, bl.PartNumber, 
	sxml.Filename, de.DefectCode DefectCodeDes, de.Description DefectCode
	,tt.Lot LotCode
	,t.s.value('../../../../rpos[1]','VARCHAR(MAX)') as Position
	,t.s.value('../../ref2skid[1]','VARCHAR(MAX)') as ref2skid
	,t.s.value('../../item[1]','VARCHAR(MAX)') as item
	,t.s.value('attrno[1]','VARCHAR(MAX)') attrno
	,t.s.value('attseq[1]','VARCHAR(MAX)') attseq
	,t.s.value('attval[1]','VARCHAR(MAX)') attval
FROM p_REP_LIBRE_FF.dbo.udtfbitLibreINVMOV bl WITH(nolock)
INNER JOIN p_REP_LIBRE_FF.dbo.fbitSignalXML sxml WITH(nolock) cross apply Content.nodes('/flxint/app/data/rec/stockpoints/stockpoint/attributes/attribute') t(s) ON bl.SignalXMLID = sxml.ID
INNER JOIN (SELECT Lot FROM #TEM WHERE ID = @cwos) tt ON cast(sxml.Content as varchar(Max) ) LIKE '%' + tt.Lot + '%' 
INNER JOIN p_REP_LIBRE_FF.dbo.ffPart p WITH(nolock) ON bl.PartID = p.ID
left join p_REP_LIBRE_FF.dbo.ffDebug as d(nolock) on d.unitid=bl.UnitID
left join p_REP_LIBRE_FF.dbo.luDefect as de(nolock) on de.ID =d.DefectID


print @cwos

SET @cwos = 1 + @cwos
END

---- SEND TO JOSE and Diana
SELECT *
FROM udtMissingReasonCodes




--SELECT --DISTINCT
--	bl.SignalXMLID, bl.Src_Warehouse, bl.Dest_Warehouse, bl.PartID, bl.PartNumber, sxml.Content, --sxml.SignalTypeID, sxml.SignalID, 
--	sxml.Filename, de.DefectCode DefectCodeDes, de.Description DefectCode
--	,'LOT310520000000188' LotCode --,t.Lot
--	,t.s.value('../../../../rpos[1]','VARCHAR(MAX)') as Position
--	,t.s.value('../../ref2skid[1]','VARCHAR(MAX)') as ref2skid
--	,t.s.value('../../item[1]','VARCHAR(MAX)') as item
--	,t.s.value('attrno[1]','VARCHAR(MAX)') attrno
--	,t.s.value('attseq[1]','VARCHAR(MAX)') attseq
--	,t.s.value('attval[1]','VARCHAR(MAX)') attval
----INTO dbo.udtMissingReasonCodes
--FROM p_REP_LIBRE_FF.dbo.udtfbitLibreINVMOV bl WITH(nolock)
--INNER JOIN p_REP_LIBRE_FF.dbo.fbitSignalXML sxml WITH(nolock) cross apply Content.nodes('/flxint/app/data/rec/stockpoints/stockpoint/attributes/attribute') t(s) ON bl.SignalXMLID = sxml.ID
----INNER JOIN (SELECT Lot FROM #TEM /*WHERE ID = @cwos*/) tt ON cast(sxml.Content as varchar(Max) ) LIKE '%' + tt.Lot + '%' -- like '%LOT310520000000188%'
--INNER JOIN p_REP_LIBRE_FF.dbo.ffPart p WITH(nolock) ON bl.PartID = p.ID
--left join p_REP_LIBRE_FF.dbo.ffDebug as d(nolock) on d.unitid=bl.UnitID
--left join p_REP_LIBRE_FF.dbo.luDefect as de(nolock) on de.ID =d.DefectID
--where cast (sxml.Content as varchar(Max) ) like '%LOT310520000000188%'
	--AND Dest_Warehouse = '768B07'


--select * FROM udtMissingReasonCodes