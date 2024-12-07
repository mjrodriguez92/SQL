use p_LIBRE_FF
GO

--- REVIEW INVMOV Pallet Signal and response
SELECT  fr.ID ResponseID,
	fr.Content ResponseContent,
	fr.ToSignalRefNumber,
	fr.SignalRefNumber,
	ip.PackageHistoryID,
	ip.PackageID,
	ip.SignalXMLID ,ip.Src_Warehouse ,ip.Dest_Warehouse
	,ip.CreateDt
	,fs.SignalRefNumber
	,fs.SignalTypeID
FROM udtfbitLibreINVMOVPackage ip WITH(nolock)
INNER JOIN ffPackage p WITH(nolock) ON ip.PackageID = p.ID
INNER JOIN fbitSignalXML sxml WITH(nolock) ON ip.SignalXMLID = sxml.ID
LEFT OUTER JOIN [fbitSignal] fs WITH(nolock) ON sxml.SignalID = fs.ID
LEFT OUTER JOIN fbitRESP fr WITH(nolock) ON fr.ToSignalRefNumber = fs.SignalRefNumber AND fr.ToSignalTypeID = fs.SignalTypeID
WHERE  p.SerialNumber = 'PLTK4000000067' 
ORDER BY ip.SignalXMLID DESC
