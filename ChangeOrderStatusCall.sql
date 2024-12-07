/*******************************************
Change a Order status from MESPro

Parameters in order
@OrderNumber : Order Number that needs to be updated
@Press: This is the Machine (Resourse) in which the order was last used, in order to locate the task and activate it as well (Mandatory Field)
@Mold: This is the Mold the order was last used, in order to locate the task and activate it as well (Mandatory Field)@Requestedby : Ops team person that requested the status change
@ServiceNowTicket : Service Now ticket that the Ops team open.

********************************************/

declare @OrderNumber varchar(100)
declare @Press varchar(100)
declare @Mold varchar(100)
declare @Requestedby varchar(100)
declare @ServiceNowTicket varchar(100)

/*
Sample Values for the parameters

set @OrderNumber = 'PQ0040259'
set @Press = '2-47'
set @Mold = 'M1415012'
set @Requestedby = 'Doris Rivera'
set @ServiceNowTicket = 'INC8026879'
*/

set @OrderNumber = ''
set @Press = ''
set @Mold = ''
set @Requestedby = ''
set @ServiceNowTicket = ''

exec udpChangeOrderStatus @OrderNumber, @Press, @Mold, @Requestedby, @ServiceNowTicket

