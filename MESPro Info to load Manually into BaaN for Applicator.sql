

/*
Information to be loaded manually in BaaN from MESPro for Libre factories use

•	Tote ID
•	PN
•	Quantity
•	Work Order
•	Mold ID
•	Press ID
•	Quadrant/Cavity
•	Resin Lot #
•	Resin PN

*/

select l.LotNbr ToteID, l.PartNbr PN, l.Quantity, l.OrderNbr 'Work Order', od.MoldNbr MoldID, r.Name PressID, la.Remark, pa.AttrValue ResinPN
  from ProdOrders o
  left join lots l on o.OrderNbr = l.OrderNbr
  left join ProdOdometers od on l.Odometer = od.OdmID  
  left join Resources r on od.ResID = r.ResID 
  left join ProdAttributes pa on o.OrderNbr = pa.OrderNbr and pa.AttrNbr = 'Resin'
  left join lotActions la on l.LotID = la.LotID and la.Operator = 'MaterialLot'
 where l.OrderNbr in ('EOQ000051','EOQ000053','EOQ000056','EOQ000057','EPQ000024','EPQ000025','EPQ000026','EPQ000027','EPQ000029','EIQ000002','EPQ000044',
					  'EPQ000040','EPQ000041','EPQ000042','EPQ000056','EPQ000057','EPQ000058','EOQ000091','EOQ000092','EIQ000005','EIQ000006','EOQ000100',
					  'EPQ000073','EPQ000074','EOQ000110')
   and l.[Status] = 4
 order by o.OrderNbr

