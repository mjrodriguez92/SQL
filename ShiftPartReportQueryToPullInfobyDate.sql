   
declare @CtgID INT = NULL,  
 @WctID INT = NULL,   
 @PartNbr NVARCHAR(64) = NULL  


 IF LTRIM(RTRIM(@PartNbr)) = ''  
  SET @PartNbr = NULL;  
   
 DECLARE @CTime DATETIME = GETDATE();  

  set @CTime = '2019-04-13 6:00:00';
   
 WITH m AS  
 (  
  SELECT [ShiftDate],[BeginTime],[TypeID],[ResID]  
  FROM ShiftLogs s WITH(NOLOCK)  
  JOIN Resources r WITH(NOLOCK) ON s.[TypeID] = r.[ShiftTypeID]  
  WHERE [BeginTime] <= @CTime AND @CTime < [EndTime]  
   AND (@CtgID IS NULL OR r.[CtgID] = @CtgID)  
      AND(@WctID IS NULL OR r.[WctID] = @WctID)  
 ),r AS  
 (  
    
  
  SELECT DISTINCT l.[ShiftID],l.[ShiftDate], l.[BeginTime],l.[EndTime],m.[TypeID],l.[ResID],r.[Name] as ResName,w.[Name] as WctName,s.[Descr] as StatusDescription,s.[Style]  
  FROM vResShiftTime l WITH(NOLOCK)  
  JOIN Resources r WITH(NOLOCK) ON l.[ResID] = r.[ResID]  
  JOIN WorkCenters w WITH(NOLOCK) ON r.[WctID] = w.[WctID]  
  JOIN __ResStatus s WITH(NOLOCK) ON r.[Status] = s.[Status]  
  JOIN m ON  l.[EndTime] = m.[BeginTime] AND l.[ResID] = m.[ResID]  
 ),d as  
 (  
  SELECT d.[ResID],[PartNbr],SUM([Quantity]) as [PlanQty]  
  FROM DailyPlans d WITH(NOLOCK)  
  JOIN   
  (  
   SELECT DISTINCT r.[ShiftDate],r.[ResID] FROM r  
  )t ON  d.[PlanDt] = t.[ShiftDate] AND d.[ResID] = t.[ResID]  
  GROUP BY d.[ResID],[PartNbr]  
 ),  
 tc as(  
   
  
 select [TaskNbr], case when [PartCount] = 0 then 1 else [PartCount] end as [PartCount] from (         
  SELECT [TaskNbr]    
              ,COUNT(1) AS [PartCount]    
        FROM vProdTasks WITH(NOLOCK)    
        GROUP BY [TaskNbr]  ) as x  
  ),  
alldown as(  
 select rd.resid,rd.Comment from ResDownLogs  rd  
 join r on r.ResID= rd.ResID  
 where (rd.StartDt between  r.BeginTime and r.EndTime) or (rd.EndDt  between  r.BeginTime and r.EndTime)  
    
  
  ),  
  down as(  
    Select distinct ST2.resid,   
            (  
                Select ST1.Comment + ',' AS [text()]  
                From alldown ST1  
                Where ST1.resid = ST2.resid  
                ORDER BY ST1.resid  
                For XML PATH ('')  
            ) reasons  
        From alldown ST2  
  
  ),  
   
  t as  
 (SELECT r.[ResID]  
     ,r.[ResName]  
     ,r.[WctName]   
     ,p.[Project]   
     ,o.[PartNbr]  
     ,p.[PartDescr]  
     ,r.[StatusDescription]  
     ,r.[Style]  
     ,MAX(ISNULL(o.[CycleTime], 0)) AS [CycleTime]  
     ,MAX(ISNULL(o.[ActualCavity], 0)) AS [Cavity]  
     ,SUM(ISNULL(o.[Cycles], 0)) AS [Cycles]  
     ,SUM(ISNULL(o.[ActualProdTime], 0)) AS [RunTime]  
     ,SUM(ISNULL(o.[OutputQty], 0)) AS [OutputQty]  
     ,SUM(ISNULL(o.[ScrapQty], 0)) AS [ScrapQty]  
     ,SUM(ISNULL(o.[LostQty],0)) as [LostQty]  
     ,SUM(ISNULL(o.[PlannedOutput],0)) AS [PlanOutput]  
     ,(CASE SUM(o.[PlannedProdTime]) WHEN 0 THEN 0 ELSE SUM(t.RequiredLabor* o.PlannedProdTime)/SUM(o.PlannedProdTime) END) as [PlanManpower]  
     ,(CASE SUM(o.[PlannedProdTime]) WHEN 0 THEN 0 ELSE SUM(ISNULL(l.[ActualLabor],0)* o.PlannedProdTime)/SUM(o.PlannedProdTime) END) as [ActualManpower]  
     ,r.[BeginTime], r.[EndTime],--,t.StartDt TaskStartDt ,t.CompleteDt TaskCompleteDt,  
  
     ----------------  
       --SUM(case when [ActualProdTime]>0 then [TotalAvailableTime] else 0 end) AS [TotalAvailableTime]    
       --, SUM(s.[TotalAvailableTime]) AS [RealTotalAvailableTime]    
      SUM(case when o.[ActualProdTime]>0 then o.[PlannedProdTime] else 0 end)  AS [PlannedProductionTime]    
	    ,SUM(  o.[PlannedProdTime] )  AS [PlannedProductionTime2]
      ,SUM( o.[ActualProdTime] )   AS [ActualProductionTime]    
      --,SUM(case when o.[ActualProdTime]>0 then o.[DownTime] else 0 end) AS [DownTime]    
    ,SUM( o.PlanDown) AS PlanDown    
    ,SUM( o.OtherDown) AS OtherDown   
	,SUM( o.OverTime) AS OverTime   
      ,SUM(    (o.[Cycles] * o.[CycleTime]) / tc.[PartCount]     ) AS [EarnedTime]    
      --,SUM(ro.[OutputQty]) AS [OutputQty2]    
      --,SUM(ro.[LostQty]) AS [LostQty2]    
      --,SUM(ro.[ScrapQty]) AS [ScrapQty2]    
      ,SUM(o.[TheoreticalOutput]) AS [TheoreticalOutput]    
      ,SUM(o.[PlannedOutput]) AS [PlannedOutput]   ,   o.OdmID  ,o.OrderNbr
     ------------  
       
  
    FROM r WITH(NOLOCK)  
    JOIN vShiftOutput o ON r.[ShiftID] = o.[ShiftID] AND r.[ResID] = o.[ResID]  
    join tc on tc.TaskNbr= o.TaskNbr  
    
    
    JOIN Tasks t WITH(NOLOCK) ON o.[TaskNbr] = t.[TaskNbr]  
    LEFT JOIN Parts p WITH(NOLOCK) ON p.[PartNbr] = o.[PartNbr]  
    LEFT JOIN TaskLabors l WITH(NOLOCK) ON t.[TaskNbr] = l.[TaskNbr] AND o.[ShiftID] = l.[ShiftID]  
     
   WHERE (@PartNbr IS NULL OR p.[PartNbr] = @PartNbr)  
     
      GROUP BY r.[ResID]  
     ,r.[ResName]   
     ,r.[WctName]   
     ,p.[Project]   
     ,o.[PartNbr]  
     ,p.[PartDescr]   
     ,r.[StatusDescription]   
     ,r.[Style]  
     ,r.[BeginTime], r.[EndTime]--,t.StartDt  ,t.CompleteDt   
     , tc.[PartCount],  
     o.OdmID   ,o.OrderNbr
     ),  
  
     scrap as(  
     select ROW_NUMBER() OVER (PARTITION BY ResID,[OdmID] ORDER BY [Quantity] desc) as Number,ResID ,sr.Name,[Quantity], PartNbr,[OdmID]  from (  
  
           SELECT t.ResID,            o.[ScrapID]           ,sum(o.[Quantity]) as [Quantity],           t.PartNbr          ,o.[OdmID]           
		   FROM ProdScraps  o WITH(NOLOCK)        JOIN t ON o.[OdmID] = t.[OdmID]         AND o.[ScrapDt] >= t.[BeginTime] AND o.[ScrapDt] < t.[EndTime]         WHERE o.[IsAvailable] = 1        group by  t.ResID,            o.[ScrapID], t.PartNbr , o.[OdmID] 
      )as x  
      join ScrapReasons sr on sr.ScrapID= x.ScrapID  
     ),  
      topdownlogs AS  
 (  
  
   
      
     select ROW_NUMBER() OVER (PARTITION BY ResID ORDER BY [Duration] desc) as Number,ResID ,r.Name,[Duration]  from (  
  
  SELECT d.[DownID] ,d.ResID   
     ,SUM(DATEDIFF(SECOND, CASE WHEN d.[StartDt] < t.[BeginTime] THEN t.[BeginTime] ELSE d.[StartDt] END,   
         CASE WHEN d.[EndDt] > t.[EndTime] THEN t.[EndTime] ELSE d.[EndDt] END)  
      ) AS [Duration]  
        
    FROM vResDownLogs d  
   JOIN t  WITH(NOLOCK) ON  ((d.[StartDt] >= t.[BeginTime] AND d.[StartDt] < t.[EndTime]) OR (d.[EndDt] >=t.[BeginTime] AND d.[EndDt] <t.[EndTime]) OR (d.[StartDt] < t.[BeginTime] AND d.[EndDt] >= t.[EndTime])) and d.ResID= t.ResID     
  
    
    
   GROUP BY d.[DownID] ,d.ResID   
    )as x  
     JOIN DownReasons r WITH(NOLOCK) ON r.[DownID] = x.[DownID]  
  
 )  
 --select * from topdownlogs  
 ,  
  
      
     data as(  
  
      
 SELECT t.[ResName] ,  
 cast(dbo.[fnrReplacetor]( t.[ResName])as int) as resourceorder  
    ,t.[WctName] AS [WorkCenter]  
     ,SUBSTRING(t.[WctName],len(t.[WctName]),1) as [WorkCenterOrder]  
    ,t.[PartNbr]  
    ,REPLACE([PartDescr], ',', ', ') AS [PartDescr]  
    ,t.[StatusDescription]  
    ,t.[Style]  AS [Color]  
    ,t.[Cavity]  
    ,t.[CycleTime]  
    ,(CASE t.[Cycles] WHEN 0 THEN 0 ELSE t.[RunTime] / t.[Cycles] END) AS [ActualCycleTime]  
    ,t.[PlanManpower]  
    ,t.[ActualManpower]  
    ,t.[PlanOutput]  
    ,ISNULL(d.[PlanQty],0) as [PlanOutputByDaily]  
    ,t.[OutputQty] AS [ActualQty],  
    t.RunTime /3600 as RunTime,  
    (3600/[CycleTime])*(t.RunTime/3600) as StandarRate  
    ,(CASE [PlanOutput] WHEN 0 THEN 0 ELSE ([OutputQty] - [LostQty]) / [PlanOutput] END) AS [AchievingRate]  
    ,(CASE [OutputQty] - [LostQty] WHEN 0 THEN 0 ELSE ([OutputQty] - [LostQty] - [ScrapQty]) / [OutputQty] - [LostQty] END) AS [Yield]  
    ,(CASE [OutputQty] WHEN 0 THEN 0 ELSE  [ScrapQty]/[OutputQty] END) AS Reject  
    ,[BeginTime], [EndTime],  
        CASE [PlannedProductionTime] WHEN 0 THEN 0 ELSE [ActualProductionTime] / [PlannedProductionTime] END AS [Availability]    
     --,CASE [TheoreticalOutput] WHEN 0 THEN 0 ELSE ([OutputQty] - [LostQty]) / [TheoreticalOutput] END      AS [Performance]    
     ,CASE [ActualProductionTime] WHEN 0 THEN 0 ELSE ([EarnedTime]) / [ActualProductionTime] END      AS [Performance]    
  ,ScrapQty,t.PlanDown/3600 as PlanDown,t.OtherDown/3600 as OtherDown,down.reasons,  
  s1.Name as Scrap1,  
  s1.Quantity as ScrapQuantity1,  
    s2.Name as Scrap2,  
  s2.Quantity as ScrapQuantity2,  
    s3.Name as Scrap3,  
  s3.Quantity as ScrapQuantity3,  
    -- , [EarnedTime] / 28800                  AS [MU]    
 d1.Name as Down1,  
 d1.Duration /3600.00 as Duration1,  
  d2.Name as Down2,  
 d2.Duration/3600.00 as Duration2,  
  d3.Name as Down3,  
 d3.Duration/3600.00 as Duration3,  
 [EarnedTime], [ActualProductionTime]  ,
 [PlannedProductionTime2]/3600 as [PlannedProductionTime], OrderNbr,OverTime/3600 as OverTime, t.ResID
   FROM  
  t  
 LEFT JOIN d ON t.[ResID] = d.[ResID] AND t.[PartNbr] = d.[PartNbr]  
 left join down on down.ResID= t.[ResID]  
 left join scrap s1 on s1.resid=t.[ResID] and s1.number=1 and t.PartNbr=s1.PartNbr   and s1.OdmID=t.OdmID
 left join scrap s2 on s2.resid=t.[ResID] and s2.number=2 and t.PartNbr=s2.PartNbr   and s1.OdmID=t.OdmID
 left join scrap s3 on s3.resid=t.[ResID] and s3.number=3 and t.PartNbr=s3.PartNbr   and s1.OdmID=t.OdmID
 left join topdownlogs d1 on d1.resid=t.[ResID] and d1.number=1   
 left join topdownlogs d2 on d2.resid=t.[ResID] and d2.number=2   
 left join topdownlogs d3 on d3.resid=t.[ResID] and d3.number=3   
  
       )  
  
         select d.*,[Yield]*[Availability]*[Performance] as OEE 
	, pos.OrderQty as OrderQtyPO, pod.OutputQty as OutputQtyPO
	 from [data]  d
   join (select  OrderNbr,ResID,PartNbr,sum(OutputQty) as OutputQty from   ProdOdometers group by OrderNbr,ResID,PartNbr ) pod on pod.OrderNbr=  d.OrderNbr and d.ResID=pod.ResID and d.PartNbr=pod.PartNbr
	  
 join ProdOrders pos on pos.OrderNbr=  d.OrderNbr
  
  
  
  
  
  


