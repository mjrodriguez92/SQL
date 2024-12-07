set transaction isolation level read uncommitted
drop table if exists #orders
select row_number() over(order by  [order]) as ID, [order] into #orders from (
select 'P30001328' [order] union 
select 'P30001343'  

) as T


declare @currentid int =1
declare @maxid int 
select @maxid=MAX(id) from #orders

declare @workorder varchar(50)

drop table if exists #WorkOrderNotDummyQTYinReject
create table #WorkOrderNotDummyQTYinReject (workorder varchar(50),qty int )

while(@currentid<=@maxid)
begin 

select @workorder= [order] from #orders where id=@currentid

		drop table if exists #Reject
	
		select * into #Reject from udtAPILog(nolock) 
	where Application = 'RejectUnit' 
	and request like '%lot":"'+@workorder+'%' order by id desc


insert #WorkOrderNotDummyQTYinReject
	SELECT --distinct JSON_VALUE(Request, '$.fileType'),p.*,pr.CreationTime,pr.Request

	 @workorder, count(distinct sn) 

	--,Request 
	from #Reject pr
		CROSS APPLY
		OPENJSON (Request, '$.units') WITH(sn varchar(50) '$.sn') p
		where p.sn   like 'R%' 

		set @currentid=@currentid+1
end


select * from #WorkOrderNotDummyQTYinReject