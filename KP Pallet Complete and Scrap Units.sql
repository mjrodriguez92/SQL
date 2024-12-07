--SELECT * FROM dbo.ffPackage WHERE SerialNumber = 'PLTK0700000059'
--SELECT * FROM dbo.ffUnitDetail

SELECT PKG1.SerialNumber AS Pallet, PKG.SerialNumber AS Box, SN.Value AS SerialNumber, US.Description AS StatusSN
FROM dbo.ffUnit U 
JOIN dbo.ffSerialNumber SN ON SN.UnitID = U.ID
JOIN dbo.luUnitStatus US ON US.ID = U.StatusID
JOIN dbo.ffUnitDetail UD ON UD.UnitID = U.ID
JOIN dbo.ffPackage PKG ON PKG.ID = UD.InmostPackageID
JOIN dbo.ffPackage PKG1 ON PKG1.ID = UD.OutmostPackageID
WHERE PKG1.SerialNumber IN (
'PLTK0700000059',
'PLTK0700000060',
'PLTK0700000061',
'PLTK0700000064'
) 
--AND US.Description = 'Scrap'
