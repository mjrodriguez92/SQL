--------------------------------------------------------------------------------------------------------
-- SMT Unit
--------------------------------------------------------------------------------------------------------

select count (s.value) 'Qty_Units' , po.productionordernumber, l.description 'line' --, u.creationtime
From ffserialnumber s (nolock)
	join ffunit u (nolock) on u.id = s.unitid
	join ffproductionorder po (nolock) on po.id = u.productionorderid
	join ffline l (nolock) on l.id = u.lineid
	LEFT OUTER JOIN ffPart p WITH(nolock) ON po.PartID = p.ID
LEFT OUTER JOIN luPartFamily pf WITH(nolock) ON p.PartFamilyID = pf.ID
	where u.creationtime >'2021-03-17 15:10:00' and pf.Name = 'PCA'
	group by po.productionordernumber, l.description

---------------------------------------------------------------------------------------------------------
----- MDS REVISION
---------------------------------------------------------------------------------------------------------
drop table if exists #res;

select 
	w.Workorder 
	,u.SerialNumber,u.CreateDttm 
into #res 
from P_Libre_MDS.dbo.DS_FT_Unit u WITH(nolock)
join P_Libre_MDS.dbo.DS_FT_Workorder w WITH(nolock) on w.Workorder_Id = u.Workorder_Id
left join p_LIBRE_FF.dbo.ffSerialNumber sn (nolock) on sn.Value=u.SerialNumber
where sn.UnitID is null 
and u.PartNumber_Id is null 
and u.CreateDttm > '2021-03-17 15:10:00' 
order by u.CreateDttm asc


select * 
from #res r 
join P_Libre_MDS.dbo.DS_FT_Unit u WITH(nolock) on u.SerialNumber =r.SerialNumber
join P_Libre_MDS.dbo.DS_FT_Workorder w(nolock) on w.Workorder_Id = u.Workorder_Id
join P_Libre_MDS.dbo.DS_FT_TraySorter t on t.Unit_Id = u.Unit_Id
join P_Libre_MDS.dbo.Log_InFileProcess f on f.InFileProcess_Id=t.InFileProcess_Id
join P_Libre_MDS.dbo.DS_Dim_Tray tt on tt.Tray_Id=t.Tray_Id
order by u.CreateDttm DESC
