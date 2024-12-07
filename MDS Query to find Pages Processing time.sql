
select PO.ID,PO.ProductionOrderNumber,L.Description,LO.ReadyQuantity,PO.ActualStartTime,PO.ActualFinishTime from ffProductionOrder PO WITH(nolock)
INNER JOIN ffLineOrder LO WITH(NOLOCK) ON LO.ProductionOrderID = PO.ID
INNER JOIN ffLine L WITH(NOLOCK) ON L.ID = LO.LineID
where ProductionOrderNumber LIKE 'k%' AND ActualStartTime BETWEEN '2020-07-01 17:44:34.563' AND '2020-07-31 17:44:34.563'

drop table #Api
go

select *
INTO #Api
from udtKitPackEOB_APILog WITH(nolock)
WHERE ProductionOrderID = 2481 AND
CreationTime >= '2020-07-01 17:44:34.563' AND
CreationTime < '2020-10-28 00:00:00'

--- KTP000268
--- 20:28 hrs - Closed on the machine
--- 20:40 hrs - EoB file was created and file contain the 20:28hrs time stamp
--- 20:42 hrs - MDS Send the first data to FF
--- 20:48 hrs - FF and MDS
--- 21:08 hrs - WO was closed in FF, SFCCOM signal send



SELECT DISTINCT SUBSTRING(Request,CHARINDEX('PageNumber',Request),40) Page, ID, RequestID, ProductionOrderID ,HashCode ,SUBSTRING(Response ,1,800) level
,*
-- SELECT MAX(CreationTime)
FROM #Api

SELECT * FROM ffProductionOrder
WHERE ProductionOrderNumber = 'a40000759'

select * from ffPart
where ID = '4813'