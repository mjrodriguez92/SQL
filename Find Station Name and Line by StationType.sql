SELECT S.Description AS Station,l.Description as Line,st.Description as StationType FROM ffStation S WITH(NOLOCK)
inner join ffLine l with(nolock) on l.ID = s.LineID
INNER JOIN ffStationType ST WITH(NOLOCK) ON ST.ID = S.StationTypeID
WHERE ST.Description IN ('Container Cart CRC Manual Scrap','Container Cart Manual Scrap Data Validation','Container Cart Reconciliation')