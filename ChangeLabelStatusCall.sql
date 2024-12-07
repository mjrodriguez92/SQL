/*******************************************
Change a Label status from MESPro

Allowed Status Values

0 = New
1 = Production
2 = PendingQA
6 = Cancelled

Parameters in order
@OrderNumber : Order Number for the Label that needs to be changed
@LabelNumber : Label Number that needs to be changed
@NewStatus   : Destination status that needs to be set it up (according to the table above)
@Requestedby : Ops team person that requested the status change
@ServiceNowTicket : Service Now ticket that the Ops team open.

********************************************/

declare @OrderNumber varchar(100)
declare @LabelNumber varchar(100)
declare @NewStatus varchar(100)
declare @Requestedby varchar(100)
declare @ServiceNowTicket varchar(100)

/*
Sample Values for the parameters

set @OrderNumber = 'PQ0040259'
set @LabelNumber = '2'
set @NewStatus = 'PendingQA'
set @Requestedby = 'Doris Rivera'
set @ServiceNowTicket = 'INC7888786'
*/

set @OrderNumber = ''
set @LabelNumber = ''
set @NewStatus = ''
set @Requestedby = ''
set @ServiceNowTicket = ''

exec udpChangeLabelStatus @OrderNumber, @LabelNumber, @NewStatus, @Requestedby, @ServiceNowTicket

