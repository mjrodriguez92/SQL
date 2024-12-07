---------------------------------------
--- Get files sent after WO closure ---
---------------------------------------

IF OBJECT_ID('tempdb..#FilesResults') IS NOT NULL DROP TABLE #FilesResults
GO

declare @WO varchar(20) = 'EOQ000114'
declare @ClosureID bigint

--Get all files for WO
select  top 1000 a.ID,JSON_VALUE(a.request,'$.lot') as WO,JSON_VALUE(a.request,'$.fileType') as FileName,JSON_VALUE(a.response,'$.status') as status, a.CreationTime,a.Request
into #FilesResults
from udtAPILog a with (nolock)
where JSON_VALUE(a.request,'$.lot') = @WO

--Get ID first Closure
select  top 1 @ClosureID = a.ID
from #FilesResults a 
where JSON_VALUE(a.request,'$.completePO') = 'True' and JSON_VALUE(a.request,'$.lot') = @WO

--Get files after Closure
Select * from #FilesResults r where r.ID > @ClosureID


---------------------------------------------------
----- Get all WOs with multiple Closure Flag in True ---
---------------------------------------------------

IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
GO

select  top 200 a.ID,JSON_VALUE(a.request,'$.lot') as WO,JSON_VALUE(a.request,'$.fileType') as FileName,JSON_VALUE(a.response,'$.status') as status, a.CreationTime,a.Request
into #Results
from udtAPILog a with (nolock)
where JSON_VALUE(a.request,'$.completePO') = 'True' 

select * from #Results r
where r.WO in (select wo from(
select count(r2.wo) as ClosureCont, wo from #Results r2 group by wo) as resultsCount where resultsCount.ClosureCont > 1)
order by r.wo,r.id


----------------------------
--- Get Files with Closure ----
----------------------------

select  top 1000 a.ID,JSON_VALUE(a.request,'$.lot') as WO,JSON_VALUE(a.request,'$.fileType') as FileName,JSON_VALUE(a.response,'$.status') as status, a.CreationTime,a.Request, a.Response
from udtAPILog a with (nolock)
where JSON_VALUE(a.request,'$.completePO') = 'True'




