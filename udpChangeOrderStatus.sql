/***********************************************************************************************************************************************************        
         Author : Juan Laguna
  Creation Date : Mar 13th, 2019
    Explanation : Change the status of an order back to Active 
      Parameter : OrderNumber: The order that needs to be updated (Mandatory Field)
				  Press: This is the Machine (Resourse) in which the order was last used, in order to locate the task and activate it as well (Mandatory Field)
				  Mold: This is the Mold the order was last used, in order to locate the task and activate it as well (Mandatory Field)
				  RequestedBy: This is the User that needs the Order status changed (Mandatory field) (it could be the AD Account user or the MESPro User)
				  ServiceNowTicket: This is the service now Ticket Open for this matter (Optional field)
         Output : Order status changed back to Active
       Is used  : MESPro any project

Order Status Values (hardcoded on the app)

0 = Created
1 = Planned
2 = Release
3 = Active
4 = ToBeCompleted
5 = Completed
6 = Hold

Tasks Status Values

0 = Scheduled
1 = Active
2 = Paused
3 = Completed
4 = Cancelled


Version    Date               FlexPM Task	Author           Description                      
---------  -----------------  -------------	---------------  ------------------------------------                      
1.0        Mar 13th, 2019	  None			Juan Laguna      INITIAL VERSION
***************************************************************************************************************************************************************/   
alter proc dbo.udpChangeOrderStatus
@OrderNumber varchar(100),
@Press varchar(100),
@Mold varchar(100),
@Requestedby varchar(100),
@ServiceNowTicket varchar(100)
as

	declare @OrderNewStatus int
	declare @TaskNewStatus int
	declare @TaskNumber varchar(100)
	declare @Changetype varchar(100) 
	set @ChangeType = 'Order Status Update'

	set @OrderNumber = rtrim(ltrim(isnull(@OrderNumber,'')))
	set @Requestedby = rtrim(ltrim(isnull(@Requestedby,'')))
	set @ServiceNowTicket = rtrim(ltrim(isnull(@ServiceNowTicket,'Not Provided')))
	set @Mold = rtrim(ltrim(isnull(@Mold,'')))
	set @Press = rtrim(ltrim(isnull(@Press,'')))

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

		if len(@Mold) <= 0
			begin
				print 'The Mold parameter is required.'
				return 3
			end

		if len(@Press) <= 0
			begin
				print 'The Press Machine is required.'
				return 4
			end

		if not exists(select 1 from ProdOrders where OrderNbr = @OrderNumber)
			begin
				print 'The order ' + @OrderNumber + ' Could not be found, please review it and try it again.'
				return 5
			end

		if not exists(select 1 from resources where [name] = @Press)
			begin
				print 'The Press ' + @Press + ' Could not be found, please review it and try it again.'
				return 6
			end

		if not exists(select * from Molds where MoldNbr = @Mold)
			begin
				print 'The Mold ' + @Mold + ' Could not be found, please review it and try it again.'
				return 7
			end

		declare @OrderCurrentStatus int
		declare @TaskCurrentStatus int
		declare @PressID int

		select @OrderCurrentStatus = [Status] from ProdOrders where OrderNbr = @OrderNumber
		select @PressID = ResID from Resources where [Name] = @Press

		/************************************************************************************************
					Locate the Task that needs to be activated for the order
		************************************************************************************************/
		select @TaskNumber = p.TaskNbr
		  from ProdOdometers p
		 where p.OrderNbr = @OrderNumber 
		   and p.MoldNbr = @Mold
		   and p.ResID = @PressID

		if not exists(select * from Tasks where TaskNbr = @TaskNumber)
			begin
				print 'A Task could not be found using the Mold ' + @Mold + ' and the machine ' + @Press + ', please review it and try it again.'
				return 8
			end

		select @TaskCurrentStatus = [Status] from Tasks t where TaskNbr = @TaskNumber

		declare @OrderCurrentStatusName varchar(100)

		set @OrderCurrentStatusName = case @OrderCurrentStatus when 0 then 'Created'
															   when 1 then 'Planned'
															   when 2 then 'Release'
															   when 3 then 'Active'
															   when 4 then 'ToBeCompleted'
															   when 5 then 'Completed'
															   when 6 then 'Hold'
															   else 'Not defined'
									  end

		declare @TaskCurrentStatusName varchar(100)

		set @TaskCurrentStatusName = case @TaskCurrentStatus when 0 then 'Scheduled'
															 when 1 then 'Active'
															 when 2 then 'Paused'
															 when 3 then 'Completed'
															 when 4 then 'Cancelled'
															 else 'Not defined'
									  end
		if @OrderCurrentStatus = 3 and @TaskCurrentStatus = 1 
			begin
				print 'Both order and task are already in Active status, so no need for an update.'
				return 9				
			end

		declare @EmailSubject nvarchar(255)
		declare @EmailBody nvarchar(max)
		set @EmailSubject = 'Order status change Ticket - ' + @ServiceNowTicket
		set @EmailBody = 'Hello Naveenan and Manpreet,

							There was a request from ' + @Requestedby +
							' to activate back again the order number [' + @OrderNumber + ']
											
							' + case when @OrderCurrentStatus <> 3 then ' the status of the order was [' + @OrderCurrentStatusName + ']' else '' end + '

							The task activated for this order was [' + @TaskNumber + '] the status of the task was [' + @TaskCurrentStatusName + ']
							and it was calculated using the provied mold [' + @Mold + '] and Machine [' + @Press + ']
							
							Please review that the BaaN order is active, otherwise will not be able to process Backflush and we will have a Inventory problem
							
							Thanks for your help on this.'

		insert into udtChangeLabelLog (Changetype, ProductionOrder, LotID, LotNumber, CreationDate, PreviousValue, FutureValue, ChangeUser, RequestedBy)
								values (@ChangeType, @OrderNumber, NULL, 'Mold: [' + @Mold + '] - Press [' + @Press + ']', getdate(), 'Order [' + @OrderCurrentStatusName + '] - Task [' + @TaskCurrentStatusName + ']', 'Active for both', current_user,  @Requestedby + ' - Ticket ' + @ServiceNowTicket)

		if @OrderCurrentStatus <> 3
			begin
				update ProdOrders set [status] = 3 where OrderNbr = @OrderNumber
			end

		if @TaskCurrentStatus <> 1
			begin
				update tasks set [status] = 1 where TaskNbr = @TaskNumber
			end

		exec msdb.dbo.sp_send_dbmail @profile_name='SQLMailp',
										@recipients='manpreet.singh@flex.com; naveenan.balakrishnan@flex.com',
										@subject=@EmailSubject,
										@body=@EmailBody


		print 'Order status changed successfully and e-mail sent'

	end

 return 0




