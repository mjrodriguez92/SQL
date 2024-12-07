drop table #Api;

DECLARE @WOID int
DECLARE @WO varchar(200)
DECLARE @ActualStarttime varchar(10)
DECLARE @ActualFinishTime varchar(10)

SET @WO = 'KTP000676'

---- GET PRODUCTION ORDER DATA
SELECT 
	@WOID = ID 
	,@ActualStarttime = CONVERT(varchar(10),ActualStartTime,121) 
	,@ActualFinishTime = CONVERT(varchar(10),ISNULL(ActualFinishTime,GETDATE())+1,121) 
FROM ffProductionOrder WITH(nolock)
WHERE ProductionOrderNumber = @WO

---- GET API EOB DATA
select *
	INTO #Api
from udtKitPackEOB_APILog WITH(nolock)
WHERE ProductionOrderID = @WOID 
AND CreationTime >= @ActualStarttime + ' 00:00:00'
AND CreationTime < @ActualFinishtime + ' 00:00:00'

select *
from udtKitPackEOB_APILog WITH(nolock)
WHERE CreationTime >= '2021-01-01 00:00:00'
and Response LIKE '%3224201028007315%'


--SELECT * 
--FROM ffSerialNumber sn WITH(nolock)
--INNER JOIN ffHistory h WITH(nolock) ON sn.UnitID = h.UnitID
--WHERE sn.value = '3224201028007315'  


DROP TABLE #JS
GO

DROP TABLE #JSRequestResult
GO

DROP TABLE #JSResponseResult
GO

CREATE TABLE #JS
(
 ID INT IDENTITY(1,1)
 ,JSONRequest varchar(MAX)
 ,JSONResponse varchar(MAX)
)

CREATE TABLE #JSRequestResult
(
	RequestID VARCHAR(100),
	Station VARCHAR(20),
	Lot VARCHAR(20),
	PartNumber varchar(100),
	Line int,
	lotStarted datetime,
	lotCompleted datetime,
	Hash VARCHAR(200),
	PageNumber int,
	TotalPages int,
	UnitStatus varchar(10),
	caseSN varchar(200),
	kitSN varchar(100),
	gu_appSN varchar(100),
	gu_sctSN varchar(100),
	gu_calCode int,
	gu_kitExpiry datetime,
	gu_reprocessed varchar(10),
	gu_originalStatus varchar(10),
	ru_scrapReason varchar(300)
)

CREATE TABLE #JSResponseResult
(
	RequestID VARCHAR(100),
	productionOrder VARCHAR(100),
	status VARCHAR(10),
	code varchar(200),
	description varchar(100),
	level varchar(100),
	UnitStatus varchar(10),	
	UnitkitSN varchar(100),
	UnitappSN varchar(100),
	UnitsctSN varchar(100),
	UnitKnowledge varchar(10),
	UnitErrorcode varchar(200),
	UnitErrordescription varchar(100),
	UnitErrorlevel varchar(100) 
)


DECLARE @cs int
DECLARE @ce int
DECLARE @JSONRequest VARCHAR(MAX)
DECLARE @JSONResponse VARCHAR(MAX)

INSERT INTO #JS
SELECT Request, Response FROM #Api

--SELECT * FROM #JS

SET @cs = 1
SELECT @ce = MAX(ID) FROM #JS

select @ce

WHILE @cs <= @ce
BEGIN


	SELECT 
		@JSONRequest = JSONRequest, 
		@JSONResponse = JSONResponse 
	FROM #JS 
	WHERE ID = @cs

	--SELECT @JSONRequest Request, @JSONResponse Response 

	---- GET REQUEST DATA AREA 

		INSERT INTO #JSRequestResult
		SELECT  
			Req.RequestID,
			Req.Station,
			Req.Lot,
			Req.PartNumber,
			Req.Line,
			Req.lotStarted,
			Req.lotCompleted,
			Req.Hash,
			Req.PageNumber,
			Req.TotalPages,
			'Good' UnitStatus,
			gu.gu_caseSN,
			gu.gu_kitSN,
			gu.gu_appSN,
			gu.gu_sctSN,
			gu.gu_calCode,
			gu.gu_kitExpiry,
			gu.gu_reprocessed,
			gu.gu_originalStatus,
			'N/A' ru_scrapReason
		FROM OPENJSON(@JSONRequest)
		WITH(
			RequestID VARCHAR(100) '$.requestId',
			Station VARCHAR(20) '$.station',
			Lot VARCHAR(20) '$.lot',
			PartNumber varchar(100) '$.partNumber',
			Line int '$.line',
			lotStarted datetime '$.lotStarted',
			lotCompleted datetime '$.lotCompleted',
			Hash VARCHAR(200) '$.Hash',
			PageNumber int '$.PageNumber',
			TotalPages int '$.TotalPages',
			GoodUnits nvarchar(MAX) '$.units' AS JSON
			) Req
		CROSS APPLY OPENJSON(GoodUnits)
		WITH(
			gu_caseSN varchar(200) '$.caseSN',
			gu_kitSN varchar(100) '$.kitSN',
			gu_appSN varchar(100) '$.appSN',
			gu_sctSN varchar(100) '$.sctSN',
			gu_calCode int '$.calCode',
			gu_kitExpiry datetime '$.kitExpiry',
			gu_reprocessed varchar(10) '$.reprocessed',
			gu_originalStatus varchar(10) '$.originalStatus'
			) gu


		INSERT INTO #JSRequestResult
		SELECT  
			Req.RequestID,
			Req.Station,
			Req.Lot,
			Req.PartNumber,
			Req.Line,
			Req.lotStarted,
			Req.lotCompleted,
			Req.Hash,
			Req.PageNumber,
			Req.TotalPages,
			'Rejected' UnitStatus,
			ru.ru_caseSN,
			ru.ru_kitSN,
			ru.ru_appSN,
			ru.ru_sctSN,
			NULL gu_calCode,
			NULL gu_kitExpiry,
			NULL gu_reprocessed,
			ru.ru_originalStatus,
			ru.ru_scrapReason
		FROM OPENJSON(@JSONRequest)
		WITH(
			RequestID VARCHAR(100) '$.requestId',
			Station VARCHAR(20) '$.station',
			Lot VARCHAR(20) '$.lot',
			PartNumber varchar(100) '$.partNumber',
			Line int '$.line',
			lotStarted datetime '$.lotStarted',
			lotCompleted datetime '$.lotCompleted',
			Hash VARCHAR(200) '$.Hash',
			PageNumber int '$.PageNumber',
			TotalPages int '$.TotalPages',
			RejectedUnits nvarchar(MAX) '$.rejectedunits' AS JSON
			) Req
		CROSS APPLY OPENJSON(RejectedUnits)
		WITH(
			ru_caseSN varchar(200) '$.caseSN',
			ru_kitSN varchar(100) '$.kitSN',
			ru_appSN varchar(100) '$.appSN',
			ru_sctSN varchar(100) '$.sctSN',
			ru_scrapReason varchar(300) '$.scrapReason',
			ru_originalStatus varchar(10) '$.originalStatus'
			) ru


	---- GET RESPONSE DATA AREA 

		INSERT INTO #JSResponseResult
		SELECT  
			Res.RequestID,
			Res.productionOrder,
			Res.status,
			err.code,
			err.description,
			err.level,
			'Good' UnitStatus,
			uni.sn KitSN,
			'N/A' appSN,
			'N/A' sctSN,
			uni.status,
			uer.code,
			uer.description,
			uer.level
		FROM OPENJSON(@JSONResponse)
		WITH(
			RequestID VARCHAR(100) '$.requestId',
			productionOrder VARCHAR(100) '$.productionOrder',
			status VARCHAR(10) '$.status',
			error nvarchar(MAX) '$.error' AS JSON,
			units nvarchar(MAX) '$.units' AS JSON
			) Res
		CROSS APPLY OPENJSON(error)
		WITH(
			code varchar(200) '$.code',
			description varchar(100) '$.description',
			level varchar(100) '$.level'
			) err
		CROSS APPLY OPENJSON(units)
		WITH(
			sn varchar(200) '$.sn',
			status varchar(100) '$.status',
			uniterror nvarchar(MAX) '$.error' AS JSON
			) uni
		CROSS APPLY OPENJSON(uniterror)
		WITH(
			code varchar(200) '$.code',
			description varchar(100) '$.description',
			level varchar(100) '$.level'
			) uer


		INSERT INTO #JSResponseResult
		SELECT  
			Res.RequestID,
			Res.productionOrder,
			Res.status,
			err.code,
			err.description,
			err.level,
			'Rejected' UnitStatus,
			run.kitSN KitSN,
			run.appSN appSN,
			run.sctSN sctSN,
			run.status,
			rue.code,
			rue.description,
			rue .level
		FROM OPENJSON(@JSONResponse)
		WITH(
			RequestID VARCHAR(100) '$.requestId',
			productionOrder VARCHAR(100) '$.productionOrder',
			status VARCHAR(10) '$.status',
			error nvarchar(MAX) '$.error' AS JSON,
			rejectedunits nvarchar(MAX) '$.rejectedunits' AS JSON
			) Res
		CROSS APPLY OPENJSON(error)
		WITH(
			code varchar(200) '$.code',
			description varchar(100) '$.description',
			level varchar(100) '$.level'
			) err
		CROSS APPLY OPENJSON(rejectedunits)
		WITH(
			kitSN varchar(100) '$.kitSN',
			appSN varchar(100) '$.appSN',
			sctSN varchar(100) '$.sctSN',
			status varchar(100) '$.status',
			reuniterror nvarchar(MAX) '$.error' AS JSON
			) run
		CROSS APPLY OPENJSON(reuniterror)
		WITH(
			code varchar(200) '$.code',
			description varchar(100) '$.description',
			level varchar(100) '$.level'
			) rue




	print @cs	
	SET @cs = @cs + 1
END 



--select * from #JSRequestResult
--select * from #JSResponseResult

select * 
from #JSRequestResult req
LEFT OUTER JOIN #JSResponseResult res ON req.RequestID = res.RequestID AND req.lot = res.productionOrder AND req.kitSN = res.UnitkitSN
ORDER BY req.PageNumber
--where req.kitSN = '3MH003DL4VR'


----SELECT * FROM OPENJSON(@JSONResponse)


--SELECT * 
--FROM ffSerialNumber sn WITH(nolock)
--WHERE sn.Value = '3MH0044D8Y0'


--SELECT *
--FROM ffPackage p WITH(nolock)
--WHERE p.SerialNumber = '01350217910008772120283624'

--select pp.SerialNumber Pallet, pb.SerialNumber pbox ,pb.CurrentCount ,ud.UnitID ,u.StatusID ,u.UnitStateID ,sn.Value UnitSN ,ud.InmostPackageID ,ud.OutmostPackageID
--from ffPackage pp WITH(nolock)
--INNER JOIN ffPackage pb WITH(nolock) ON pp.ID = pb.ParentID
--INNER JOIN ffUnitDetail ud WITH(nolock) ON pb.Id = ud.inmostPackageID
--INNER JOIN ffUnit u WITH(nolock) ON ud.UnitID = u.ID
--INNER JOIN ffSerialNumber sn WITH(nolock) ON u.ID = sn.UnitID
--WHERE pp.SerialNumber = 'PLTK4300000167' AND pb.SerialNumber = '01350217910008772120283624'

