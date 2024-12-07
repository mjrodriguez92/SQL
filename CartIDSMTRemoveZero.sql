--1 Step to Look up Trays

SELECT * FROM dbo.udtCart
WHERE SerialNumber IN ('S0010120-M19','S0007349-L19','S0007617-L19')

--2 Step Add the ID number of the Trays 

BEGIN TRAN

SELECT SN.Value, TR.*
FROM dbo.udtTray TR
JOIN dbo.ffSerialNumber SN ON SN.UnitID = TR.UnitID
WHERE SN.Value IN ('S0010120-M19','S0007349-L19','S0007617-L19') 

UPDATE dbo.udtTray SET CartID = NULL WHERE ID IN (
94852,
95120,
127997
)

SELECT SN.Value, TR.*
FROM dbo.udtTray TR
JOIN dbo.ffSerialNumber SN ON SN.UnitID = TR.UnitID
WHERE SN.Value IN ('S0010120-M19','S0007349-L19','S0007617-L19') 

ROLLBACK TRAN
