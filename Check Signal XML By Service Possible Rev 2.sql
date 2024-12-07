
select top 1 sx.id ID, sx.SignalID, sx.FileName, sx.Content, sx.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref, sx.SignalTypeID, st.Name, sx.StatusID, ls.StatusName, sx.UpdateDt, sx.UpdateBy, ls.TableName
from fbitSignalXML sx with(nolock)
left outer join fbitLuStatus ls with(nolock) on sx.StatusID = ls.StatusID 
join fbitLuSignalType st with(nolock) on sx.SignalTypeID = st.id
--join fbitsignal fbs with(nolock) on st.id = fbs.SignalTypeID
--left outer join fbitSignalHistory sh with(nolock) on st.id = sh.SignalTypeID
where sx.FileName like '%STPSTA%' and ls.TableName = 'fbitSignalXML' and sx.CreateDt between '2022-01-12 18:00:00.000' and '2022-01-13 04:00:00.000'
order by sx.UpdateDt desc



--Selecting distinct signals will not allow for xml content
select distinct sx.id ID, sx.SignalID, sx.FileName, sx.Content.value('(flxint/app/sigref)[1]','varchar(100)') Sigref, sx.SignalTypeID, st.Name, sx.StatusID, ls.StatusName, sx.UpdateDt, sx.UpdateBy, ls.TableName
from fbitSignalXML sx with(nolock)
left outer join fbitLuStatus ls with(nolock) on sx.StatusID = ls.StatusID 
join fbitLuSignalType st with(nolock) on sx.SignalTypeID = st.id
--join fbitsignal fbs with(nolock) on st.id = fbs.SignalTypeID
--left outer join fbitSignalHistory sh with(nolock) on st.id = sh.SignalTypeID
where sx.FileName like '%STPSTA%' and ls.TableName = 'fbitSignalXML' and sx.CreateDt between '2022-01-12 18:00:00.000' and '2022-01-13 04:00:00.000'
