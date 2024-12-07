--SELECT * FROM ffUnitState WHERE Description LIKE '%AUTO%'

SELECT 
po.ProductionOrderNumber 
,S.Value AS SerialNumber
,L1.Description AS LineScrappedOn
,U.ID AS UnitID
,stt.Description AS Station
,UD.reserved_37 As KitpackDateIn
,UD.reserved_39 As ApplicatorDateIn
,UD.Reserved_38 AS PuckDateIn
,H.ExitTime AS ScrapDate
,(SELECT TOP 1 Description FROM (SELECT TOP 2 H1.ID, H1.UnitStateID, St.Description FROM ffHistory H1 INNER JOIN ffUnitState St ON St.ID = H1.UnitStateID WHERE H1.UnitID = U.ID ORDER BY h1.ID DESC) x ORDER BY x.ID ASC ) AS PreviousStation

FROM 
ffHistory H 
INNER JOIN ffStation st1 ON ST1.ID = H.StationID
INNER JOIN ffProductionOrder PO ON PO.ID = H.ProductionOrderID
INNER JOIN ffStationType STT ON STT.ID = ST1.StationTypeID
INNER JOIN ffUnit U ON H.UnitID = U.ID 
INNER JOIN ffUnitDetail UD ON UD.UnitID = U.Id
INNER JOIN ffUnitState U1 ON U1.ID = U.UnitStateID 
INNER JOIN ffSerialNumber S ON S.UnitID = U.ID AND S.SerialNumberTypeID = 3
INNER JOIN luUnitStatus Us ON Us.ID = U.StatusID
INNER JOIN ffUnitState St ON H.UnitStateID = St.ID
Inner JOIN ffLineOrder L ON L.ProductionOrderID = PO.ID
INNER JOIN ffLine L1 ON L1.ID = st1.LineID

WHERE H.UnitStateID IN (5000000,5000001,5000004,5000005)
AND H.ExitTime > '2021-04-01 00:00:00.000'
ORDER BY 9 asc, 6 asc, 7 asc, 6 asc


--SELECT * FROM ffUnitState where Description LIKE '%Automat%' -- ID IN (5000001, 5000004, 5000005)
