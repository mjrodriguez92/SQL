
select Pas.PartNbr TablePart, mx.PartNbr TableMoldMatrixes, mq.PartNbr,* 
  from ProdOrders p
  join SingleTasks s on s.OrderNbr = p.OrderNbr
  join Parts pas on pas.PartNbr = s.PartNbr 
  join Molds m on m.MoldNbr = s.MoldNbr
  join MoldMatrixes mx on mx.MoldID = m.MoldID and p.PartNbr = mx.PartNbr
  join MoldQualifications mq on mq.MoldID = m.MoldID and mq.PartNbr = mx.PartNbr
 where p.OrderNbr = '768008245'


/*
	begin tran
	update MoldMatrixes set PartNbr = 'AMG-102-1004678' where MoldID = 153 and PartNbr = 'AMG-102-1004678'
	update MoldQualifications set PartNbr = 'AMG-102-1004678' where MoldID = 153 and PartNbr = 'AMG-102-1004678'
	rollback tran
	commit

*/


select * from Parts where PartNbr = 'ABV-CMS.S.90A506-8'
select * from ProdOrders where OrderNbr = '768008245'
select * from MoldMatrixes where PartNbr = 'ABV-CMS.S.90A506-8'
select * from Molds where MoldID in (109, 209)
select * from Tasks where TaskNbr = 'T19021300024'
select * from SingleTasks where TaskNbr = 'T19021300024'
select * from MoldQualifications where PartNbr = 'ABV-CMS.S.90A506-8'

/*
begin tran
update MoldQualifications set Qualified = 1 where PartNbr = 'ABV-CMS.S.90A506-8' and QualifiedDt = '2019-02-14 09:22:59.980' 
commit
*/


