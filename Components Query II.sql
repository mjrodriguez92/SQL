SELECT
(select po.ProductionOrderNumber  from t_BFG_Libre_POC.dbo.ffserialnumber sn
inner join t_BFG_Libre_POC.dbo.ffunitdetail ud on ud.UnitID = sn.UnitID 
 left join t_BFG_Libre_POC.dbo.ffProductionOrder po on po.ID = ud.ProductionOrderID
where sn.Value IN (SUBSTRING(b.flexFlowSN, 3, 26))) AS 'WO',
b.FlexFlowSN AS 'PanelSerialNumber',  
CASE p.Name
WHEN 'Top/PCB#1_1_1' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '0')
WHEN 'Top/PCB#2_1_2' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '1')
WHEN 'Top/PCB#3_1_3' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '2')
WHEN 'Top/PCB#4_1_4' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '3')
WHEN 'Top/PCB#5_2_1' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '4')
WHEN 'Top/PCB#6_2_2' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '5')
WHEN 'Top/PCB#7_2_3' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '6')
WHEN 'Top/PCB#8_2_4' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '7')
WHEN 'Top/PCB#9_3_1' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '8')
WHEN 'Top/PCB#10_3_2' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + '9')
WHEN 'Top/PCB#11_3_3' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + 'A')
WHEN 'Top/PCB#12_3_4' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + 'B')
WHEN 'Top/PCB#13_4_1' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + 'C')
WHEN 'Top/PCB#14_4_2' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + 'D')
WHEN 'Top/PCB#15_4_3' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + 'E')
WHEN 'Top/PCB#16_4_4' THEN (SUBSTRING(b.flexFlowSN, 3, 25) + 'F')
ELSE p.Name
END as 'BoardSerialNumber',
pt.ReferenceDesignator, 
pt.SKID, 
p.Name AS 'Position', 
ss.item AS 'PartNumber', 
ss.revision AS 'Revision', 
b.DateBegin, 
b.DateComplete,
m.Name as 'MachineName',
b.FileName
FROM TMI2.dbo.Board b
LEFT JOIN TMI2.dbo.Panel p  ON p.BoardId = b.Id
INNER JOIN TMI2.dbo.Position pt ON pt.PanelID = p.Id
LEFT JOIN TMI2.dbo.Machine m ON b.MachineId = m.Id 
LEFT JOIN TMI2.DBO.job j ON b.JobId = j.Id
LEFT JOIN TMI2.dbo.Project pr ON b.ProjectId = pr.Id
LEFT JOIN SpoolDB.dbo.spotSKID ss ON pt.SKID = ss.SKID
WHERE b.FlexFlowSN = 'P-L1B11905089000004600000050'
UNION 
 select NULL, fsn.value, NULL, 
 CASE CAST(fuc.ChildPartFamilyID AS varchar(3))
       WHEN '24' THEN 'FAB'
       WHEN '4' THEN 'SolderPaste'
       WHEN '5' THEN 'Glue'
       WHEN '23' THEN 'Stencil'
       ELSE CAST(fuc.ChildPartFamilyID AS varchar(3)) 
 END,
fuc.ChildLotNumber, NULL, fp.PartNumber, fp.Revision, fuc.InsertedTime, NULL, NULL, NULL
from t_BFG_Libre_POC.dbo.ffUnitComponent fuc
left join t_BFG_Libre_POC.dbo.ffSerialNumber fsn ON fuc.UnitID = fsn.UnitID
left join t_BFG_Libre_POC.dbo.ffpart fp ON fp.ID = fuc.ChildPartID 
 where 
 fsn.Value = 'P-L1B11905089000004600000050'
and (fuc.ChildPartFamilyID = 24 or fuc.ChildPartFamilyID = 4 or fuc.ChildPartFamilyID = 5 or fuc.ChildPartFamilyID = 23)

