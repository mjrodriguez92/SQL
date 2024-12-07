

SELECT [object_name],
[counter_name],
[cntr_value]
FROM sys.dm_os_performance_counters
WHERE [object_name] LIKE '%Manager%'
AND [counter_name] = 'Page life expectancy'

select * from  sys.dm_exec_query_memory_grants

SELECT distinct sqltext.TEXT,
[Database] = DB_NAME(sp.dbid),
[Individual Query] = SUBSTRING (sqltext.text, req.statement_start_offset/2, 
                      (CASE WHEN req.statement_end_offset = -1 
                           THEN LEN(CONVERT(NVARCHAR(MAX), sqltext.text)) * 2 
                       ELSE req.statement_end_offset END - req.statement_start_offset)/2),
req.session_id,
sp.loginame,
sp.hostname,
req.blocking_session_id,
req.command,
req.status,
req.total_elapsed_time,wait_resource,
cpu_time  ,wait_type ,wait_time ,transaction_id,getdate() 'DateTime'
FROM sys.dm_exec_requests req
inner join sys.sysprocesses sp on req.session_id = sp.spid 
CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS sqltext 
--where blocking_session_id!=0

SELECT sqltext.TEXT,[Individual Query] = SUBSTRING (sqltext.text, req.statement_start_offset/2, 
                      (CASE WHEN req.statement_end_offset = -1 
                           THEN LEN(CONVERT(NVARCHAR(MAX), sqltext.text)) * 2 
                       ELSE req.statement_end_offset END - req.statement_start_offset)/2),
req.session_id as ssid,req.status,req.command,req.cpu_time,
blocking_session_id as blk_ssid   ,wait_type as w8tpe ,wait_time as w8tme   
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(req.sql_handle) AS sqltext 
where blocking_session_id > 0
or req.session_id in ( select blocking_session_id from  sys.dm_exec_requests where blocking_session_id > 0)


