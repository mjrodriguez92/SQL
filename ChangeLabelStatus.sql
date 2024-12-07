
/********************************************************
Change the status of a Label from Complete to PendingQA 

Status Values (hardcoded on the app)

0 = New
1 = Production
2 = PendingQA
3 = QAFinished
4 = Completed
5 = PendingRework
6 = Cancelled

*********************************************************/
declare @OrderNumber varchar(100)
declare @LabelNumber varchar(100)
declare @LotID int
declare @PendingQAStatus int

set @OrderNumber = 'PQ0040259'
set @LabelNumber = '2'

set @PendingQAStatus = 2

if not exists(select 1 from ProdOrders where OrderNbr = @OrderNumber)
	begin
		print 'The order ' + @OrderNumber + ' Could not be found, please review it and try it again'
	end
else
	begin
		select @LotID = isnull(l.LotID,0)
		  from ProdOrders o with (nolock)
		  join Lots l with (nolock) on o.OrderNbr = l.OrderNbr
		 where o.OrderNbr = @OrderNumber
		   and l.ControlNbr = @LabelNumber

		set @LotID = isnull(@LotID,0)

		if isnull(@LotID,0) = 0 
			begin
				print 'The Label Number ' + @LabelNumber + ' for order ' + @OrderNumber + ' Could not be found, please review it and try it again'
			end
		else
			begin
				update lots set Status = @PendingQAStatus where LotID = @LotID				
			end
	end




