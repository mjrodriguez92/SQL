select top 1* from DS_FT_Unit u with(nolock)
inner join DS_FT_TraySorter ts with(nolocK) on u.Unit_Id = ts.Unit_Id
inner join DS_Dim_Machine m with(nolock) on ts.Machine_Id = m.Machine_Id
inner join DS_Dim_Line l with(nolock) on m.Line_Id = l.Line_Id
inner join DS_Dim_FileType ft with(nolock) on l.CreateDttm = ft.CreateDttm
inner join Log_InFileProcess ipf with(nolock) on ft.FileType_Id = ipf.FileType_Id
inner join Log_OutFileProcess ofp with(nolock) on ipf.FileName = ofp.FileName
where l.Line = 'SMT Line 2'


Select top 10 InFileProcess_Id, FileName, CreateDttm from Log_InFileProcess with(nolock)
where FILENAME like '%S0020080-F20%' --and CreateDttm between '2022-01-14 02:10:00.000' and '2022-01-14 07:20:00.000'
order by CreateDttm desc

select * from DS_FT_TraySorter where InFileProcess_Id = 31486224

select * from DS_Dim_Tray where TraySN = 'L0243364-A22'

Select top 20* from DS_FT_LAL lal with(nolock) 
left join DS_Dim_Machine dm with(nolock) on lal.Machine_Id = dm.Machine_Id
--where lal.LAL_ID = 1623
order by lal.TestDate desc

Select *  from Log_InFileProcess fp with(nolock) where fp.InFileProcess_Id = 30051056


Select * from DS_FT_Unit where Unit_Id = 369414119



select top 20 * from udtLALTestResults th with(nolock) 
left outer join ffProductionOrder po with(nolock) on th.SampleLOT = po.ProductionOrderNumber
left outer join udtLALTrayHistory lal with(nolock) on po.ID = lal.ProductionOrderID
left outer join ffSerialNumber sn with(nolock) on lal.TraySN = sn.Value
left outer join udtTray t with(nolock) on sn.Value = t.UnitID
order by th.LALDatetime desc
-- where th.LALDatetime between '2022-01-24 00:00:00' and '2022-01-26 00:00:00'