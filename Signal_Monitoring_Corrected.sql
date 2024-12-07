use P_LIBRE_FF
GO
------ First Step 		  INC10025630x`	
--------- Review if we have blocks on the database
dbcc opentran;

--SELECT * FROM ffHistory h WITH(nolock)
--LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON h.ProductionOrderID = po.ID
-- WHERE h.ID = (SELECT MAX(ID) FROM ffHistory )
--- -1079485607

--SELECT s.text
--FROM sys.dm_exec_connections c
--CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) s
--WHERE session_id = 208
--  SP_WHO2 137
--13427

select * from sys.sysprocesses where blocked > 0;

DECLARE @SourceLastID as int
DECLARE @SourcePackageLastID as int		
DECLARE @SourceCartLastID as int

SELECT @SourceLastID=Value from fbitconfig(nolock) where typeid=14 and name ='SourceLastID'
SELECT @SourcePackageLastID=Value from fbitconfig(nolock) where typeid=14 and name ='SourcePackageLastID'
SELECT @SourceCartLastID=Value from fbitconfig(nolock) where typeid=14 and name ='SourceCartLastID'

SELECT 'INVMOV_ffHistory' Signal, GETDATE(), @SourceLastID SourceLastID, max(id) ffHistoryID ,@SourceLastID-max(id) Delta from ffhistory--UNIT
SELECT 'INVMOV_ffPackageHistory' Signal, @SourcePackageLastID SourceLastID,max(id) ffHistoryID ,@SourcePackageLastID-max(id) Delta from ffPackageHistory--PACKAGE
SELECT 'INVMOV_udtCartHistory' Signal, @SourceCartLastID SourceLastID,max(id) ffHistoryID ,@SourceCartLastID-max(id) Delta from udtcarthistory--CARTLEVEL

SELECT @SourceLastID=Value from fbitconfig(nolock) where typeid=13 and name ='SourceLastID'
SELECT @SourcePackageLastID=Value from fbitconfig(nolock) where typeid=13 and name ='SourcePackageLastID'
SELECT @SourceCartLastID=Value from fbitconfig(nolock) where typeid=13 and name ='SourceCartLastID'

SELECT 'SFCCOM_ffHistory' Signal,GETDATE(), @SourceLastID SourceLastID, max(id) ffHistoryID ,@SourceLastID-max(id) Delta from ffhistory--UNIT
SELECT 'SFCCOM_ffPackageHistory' Signal,	@SourcePackageLastID SourceLastID,max(id) ffHistoryID ,@SourcePackageLastID-max(id) Delta from ffPackageHistory--PACKAGE
SELECT 'SFCCOM_udtCartHistory' Signal, @SourceCartLastID SourceLastID,max(id) ffHistoryID ,@SourceCartLastID-max(id) Delta from udtcarthistory--CARTLEVEL

SELECT @SourceLastID=Value from fbitconfig(nolock) where typeid=15 and name ='SourceLastID'

SELECT 'PACKSN_ffPackageHistory' Signal,GETDATE(),	@SourceLastID SourceLastID,max(id) ffHistoryID ,@SourceLastID-max(id) Delta from ffPackageHistory--PACKAGE


/*
SELECT 
    'Deadlocks Occurrences Report', 
    CONVERT(BIGINT,((1.0 * p.cntr_value / 
NULLIF(datediff(DD,d.create_date,CURRENT_TIMESTAMP),0)))) as 
AveragePerDay,
    CAST(p.cntr_value AS NVARCHAR(100)) + ' deadlocks have been recorded 
since startup.' AS Details, 
    d.create_date as StartupDateTime
FROM sys.dm_os_performance_counters p
INNER JOIN sys.databases d ON d.name = 'tempdb'
WHERE RTRIM(p.counter_name) = 'Number of Deadlocks/sec'
AND RTRIM(p.instance_name) = '_Total'
;
*/


select top 1000 * 
from fbitSignalXML x(nolock)
join fbitSignal s(nolock) on s.id =x.SignalID 
left join fbitRESP r(nolock) on r.ToSignalRefNumber=s.SignalRefNumber and  r.ToSignalTypeID =s.SignalTypeID
where s.SignalTypeID =14
order by x.id desc

--select top 1000 * from udtfbitPACKSN_Libre(nolock)  order by ID desc


--select  * from  fbitSignal s(nolock) 
--left join fbitRESP r(nolock) on r.ToSignalRefNumber=s.SignalRefNumber and  r.ToSignalTypeID =s.SignalTypeID
--where s.SignalTypeID =14
--order by s.id desc
declare @maxid int
select @maxid=MAX(id) from ffPackageHistory
select @maxid-Value as Delta from fbitConfig where TypeID =15 and Name ='SourceLastID'

/*GET Pallets pending to be sent*/
select * from ffPackageHistory ph(nolock)
join ffPackage p (nolock) on p.id=ph.packageid
join ffStation s(nolock)  on s.ID =ph.StationID
join ffStationtype st(nolock)  on st.ID =s.StationTypeID
where ph.id>(select [Value] from fbitConfig (nolock) where typeid=15 and name ='SourceLastID' )
and p.Stage =2 and st.description in ('KP_PreRelease','SamplingPalletPreRelease','SamplingPalletPreRelease FG')
order by ph.id asc



--begin tran
--update c set c.value ='4114967' from fbitConfig c  where TypeID =15  and ID=177
--rollback

--update c set c.value ='204804' from fbitConfig c  where TypeID =15  and ID=179


