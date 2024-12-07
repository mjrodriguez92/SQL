Select * 
from DS_Dim_Tray t with(nolock)
--left  join DS_FT_Sterlization s with(nolock) on t.Tray_Id = s.Tray_Id
where t.TraySN in ('E0244676-B22',
'E0244677-B22',
'E0244674-B22',
'E0244900-B22',
'E0244675-B22',
'E0244668-B22',
'E0244671-B22',
'E0244620-B22',
'E0244901-B22',
'E0244902-B22',
'E0244667-B22',
'E0244833-B22',
'E0190509-E21',
'E0190510-E21',
'E0244920-B22',
'E0244622-B22'
)


Select Distinct ct.InFileProcess_Id, ct.Tray_Id
from DS_FT_ContainerTest ct with(nolock) 
where ct.Tray_Id in (236672,
236673,
236685,
236686,
236736,
236732,
236684,
236706,
236703,
236704,
236705,
236715,
236716,
236717,
236718,
236688
)

Select * 
from Log_InFileProcess fp with(nolock)
where fp.InFileProcess_Id in (33420310,
33420253,
33420540,
33421043,
33420230,
33421577,
33420585,
33419796,
33420560,
33419825,
33421466,
33420205,
33421023,
33420609,
33421066,
33420967
)