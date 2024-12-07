--Need details of all the sensor container work order manufactured from 08/17/2020. Need the following info:
--1. Sensor container WO. 
--2. Line number. 
--3. Production start date.
--4. Quantity.
--Ticket # 3297340

select p.partnumber, ffproductionorder.ProductionOrderNumber,ffline.Description AS Line,ffProductionOrder.ActualStartTime,ffLineOrder.ReadyQuantity from ffProductionOrder with(nolock)
inner join ffLineOrder with(nolock) on ffLineOrder.Description = ffProductionOrder.ProductionOrderNumber
inner join ffLine with(nolock) on ffLine.ID = ffLineOrder.LineID
inner join ffpart p with(nolock) on p.ID = ffproductionorder.PartID
WHERE p.PartNumber  like '%THRL-PRT23200-750%' AND ProductionOrderNumber like 'C%'
--CHANGE DATE HERE as needed to request details from that time period
--where ffProductionOrder.ActualStartTime between '2020-08-17 00:00:00.000' and '2020-09-10 11:38:11.737' and 