/***********************************************************************************************************************************************************        
         Author : Juan Laguna
  Creation Date : Jan 29th, 2019
    Explanation : Change the status of a Label from Complete to PendingQA 
      Parameter : OrderNumber: The order form which the Label needs to be updated (Mandatory Field)
				  LabelNumber: Number of the label that needs to be updated (Mandatory Field)
				  NewStatus: This is the target status for the label (Mandatory Field)
				  RequestedBy: This is the User that needs the label status changed (Mandatory field) (it could be the AD Account user or the MESPro User)
				  ServiceNowTicket: This is the service now Ticket Open for this matter (Optional field)
         Output : Label status changed to PendingQA
       Is used  : MESPro any project

Status Values (hardcoded on the app)

0 = New
1 = Production
2 = PendingQA
3 = QAFinished
4 = Completed
5 = PendingRework
6 = Cancelled

Version    Date               FlexPM Task	Author           Description                      
---------  -----------------  -------------	---------------  ------------------------------------                      
1.0        Jan 29th, 2019	  None			Juan Laguna      INITIAL VERSION
1.1        Feb 1st, 2019	  None			Juan Laguna      Change the description on the status allowed to be changed 
1.2        Feb 5th, 2019	  None			Juan Laguna      bugfix for the  @LabelNumber parameter taken as the @OrderNumber
1.3        Feb 6th, 2019	  None			Juan Laguna      Add @ServiceNowTicket as a parameter to the store Procedure for log purposes
1.4        Feb 8th, 2019	  None			Juan Laguna      Add cancelled Status as a posible future status
1.5        Feb 21st, 2019	  None			Juan Laguna      Change the log table to add the change type
***************************************************************************************************************************************************************/   
alter proc dbo.udpChangeLabelStatus
@OrderNumber varchar(100),
@LabelNumber varchar(100),
@NewStatus varchar(100),
@Requestedby varchar(100),
@ServiceNowTicket varchar(100)
as

	declare @SetupNewStatus int
	declare @Changetype varchar(100) 
	set @ChangeType = 'Status Update'

	/******************************************
		Check that the status is a valid one
	*******************************************/
	select @SetupNewStatus = case @NewStatus when 'New' then 0
											 when 'Production' then 1
											 when 'PendingQA' then 2
											 when 'Cancelled' then 6
											 else 7
							end

	if @SetupNewStatus = 7
		begin
			print 'The new status is not valid it should be PendingQA, Production, New or Cancelled please review and try it again'
			return 4
		end

	set @OrderNumber = rtrim(ltrim(isnull(@OrderNumber,'')))
	set @LabelNumber = rtrim(ltrim(isnull(@LabelNumber,'')))
	set @Requestedby = rtrim(ltrim(isnull(@Requestedby,'')))
	set @ServiceNowTicket = rtrim(ltrim(isnull(@ServiceNowTicket,'')))

	begin

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

		declare @LotID int
		declare @CurrentStatus int
		declare @LotNumber varchar(100)

		if not exists(select 1 from ProdOrders where OrderNbr = @OrderNumber)
			begin
				print 'The order ' + @OrderNumber + ' Could not be found, please review it and try it again.'
				return 5
			end
		else
			begin
				select @LotID = isnull(l.LotID,0), @CurrentStatus = isnull(l.[Status],7), @LotNumber = l.LotNbr
				  from ProdOrders o with (nolock)
				  join Lots l with (nolock) on o.OrderNbr = l.OrderNbr
				 where o.OrderNbr = @OrderNumber
				   and l.ControlNbr = @LabelNumber

				set @LotID = isnull(@LotID,0)
				set @CurrentStatus = isnull(@CurrentStatus,7)
				set @LotNumber = isnull(@LotNumber,'')
				
				if isnull(@LotID,0) = 0 
					begin
						print 'The Label Number ' + @LabelNumber + ' for order ' + @OrderNumber + ' Could not be found, please review it and try it again.'
						return 6
					end
				else
					begin
						
						if @CurrentStatus = @SetupNewStatus
							begin
								print 'The current status of the lot is the same as the desired status, no change has been done.'
								return 7
							end

						declare @CurrentStatusName varchar(100)

						set @CurrentStatusName = case @CurrentStatus when 0 then 'New'
																	 when 1 then 'Production'
																	 when 2 then 'PendingQA'
																	 when 3 then 'QAFinished'
																	 when 4 then 'Completed'
																	 when 5 then 'PendingRework'
																	 when 6 then 'Cancelled'
																	 else 'Not defined'
												end

						declare @EmailSubject nvarchar(255)
						declare @EmailBody nvarchar(max)
						set @EmailSubject = 'Label Status Change Ticket - ' + @ServiceNowTicket
						set @EmailBody = 'Hello Naveenan and Manpreet,

											Please adjust the status or create a purge form for the request from ' + @Requestedby +
											' the request is as follows 
											
											change the status of the label [' + @LabelNumber + '] from lot number [' + @LotNumber + '] from the order ' + @OrderNumber + '

											the original status was [' + @CurrentStatusName + '] and it has been changed to [' + @NewStatus + ']' + '
											
											Thanks for your help on this.'

						insert into udtChangeLabelLog (Changetype, ProductionOrder, LotID, LotNumber, CreationDate, PreviousValue, FutureValue, ChangeUser, RequestedBy)
											   values (@ChangeType, @OrderNumber, @LotID, @LotNumber, getdate(), @CurrentStatusName, @NewStatus, current_user,  @Requestedby + ' - Ticket ' + @ServiceNowTicket)

						update lots set Status = @SetupNewStatus where LotID = @LotID

						exec msdb.dbo.sp_send_dbmail @profile_name='SQLMailp',
													 @recipients='manpreet.singh@flex.com; naveenan.balakrishnan@flex.com',
													 @subject=@EmailSubject,
													 @body=@EmailBody


						print 'Status changed successfully and e-mail sent'
					end
			end
	end

 return 0




