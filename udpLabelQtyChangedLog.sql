/***********************************************************************************************************************************************************        
         Author : Juan Laguna
  Creation Date : Feb 21st, 2019
    Explanation : Sends an e-mail to make aware the supervisors that a change in the quatoty of a label has occured and store the change in a log
      Parameter : OrderNumber: The order form which the Label needs to be updated (Mandatory Field)
				  LabelNumber: Number of the label that needs to be updated (Mandatory Field)
				  NewQty: This is the New quantity for the label (Mandatory Field)
				  RequestedBy: This is the User that needs the label status changed (Mandatory field) (it could be the AD Account user or the MESPro User)
				  ServiceNowTicket: This is the service now Ticket Open for this matter (Optional field)
         Output : E-mail send and log record stored
       Is used  : MESPro any project

Version    Date               FlexPM Task	Author           Description                      
---------  -----------------  -------------	---------------  ------------------------------------                      
1.0        Feb 21st, 2019	  None			Juan Laguna      INITIAL VERSION
1.1        Apr 05th, 2019	  None			Juan Laguna      Change the parameter to adjust the SP to the new User Interface (remoce the Old Label Qty parameter)
***************************************************************************************************************************************************************/   
alter proc dbo.udpLabelQtyChangedLog
@OrderNumber varchar(100),
@LabelNumber varchar(100),
@NewQty int,
@Requestedby varchar(100),
@ServiceNowTicket varchar(100)
as
begin

	declare @Changetype varchar(100) 
	set @ChangeType = 'Quantity Update'

	set @OrderNumber = rtrim(ltrim(isnull(@OrderNumber,'')))
	set @LabelNumber = rtrim(ltrim(isnull(@LabelNumber,'')))
	set @Requestedby = rtrim(ltrim(isnull(@Requestedby,'')))
	set @ServiceNowTicket = rtrim(ltrim(isnull(@ServiceNowTicket,'')))

	if isnull(@NewQty,0) = 0
		begin
			print 'The New Quantity for the label must be great that Zero.'
			return 4
		end

	if len(@Requestedby) <= 0
		begin
			print 'The Requestor of the change must be captured.'
			return 1
		end

	if len(@OrderNumber) <= 0
		begin
			print 'The Order Number is required.'
			return 2
		end

	if len(@LabelNumber) <= 0
		begin
			print 'The Label Number is required.'
			return 3
		end

	declare @LotNumber varchar(100)
	declare @LotID int
	declare @OldQty int

	select @LotNumber = LotNbr, @LotID = LotID, @OldQty = l.Quantity 
	  from ProdOrders o with (nolock)
	  join Lots l with (nolock) on o.OrderNbr = l.OrderNbr
	 where o.OrderNbr = @OrderNumber
	   and l.ControlNbr = @LabelNumber

	if @LotNumber is null or @LotID is null
		begin
			print 'The Lot Number cannot be found.'
			return 5
		end

	update Lots set Quantity = @NewQty where LotID = @LotID

	insert into udtChangeLabelLog (ChangeType, ProductionOrder, LotID, LotNumber, CreationDate, PreviousValue, FutureValue, ChangeUser, RequestedBy)
						   values (@ChangeType, @OrderNumber, @LotID, @LotNumber, getdate(), @OldQty, @NewQty, current_user,  @Requestedby + ' - Ticket ' + @ServiceNowTicket)

	declare @EmailSubject nvarchar(255)
	declare @EmailBody nvarchar(max)
	set @EmailSubject = 'Label Status Change Ticket - ' + @ServiceNowTicket
	set @EmailBody = 'Hello Naveenan and Manpreet,

						This email is just to let you know that there is a new Quantity label request from ' + @Requestedby +
						' the request is as follows 
											
						change the quantity of the label [' + @LabelNumber + '] from lot number [' + @LotNumber + '] from the order ' + @OrderNumber + '

						the original Quantity was [' + ltrim(str(@OldQty)) + '] and it has been changed to [' + ltrim(str(@NewQty)) + ']' + '
											
						Best Regards'

	exec msdb.dbo.sp_send_dbmail @profile_name='SQLMailp',
									@recipients='manpreet.singh@flex.com; naveenan.balakrishnan@flex.com',
									@subject=@EmailSubject,
									@body=@EmailBody
end




