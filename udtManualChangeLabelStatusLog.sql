
if exists(select 1 from sys.objects where name = 'udtManualChangeLabelStatusLog')
	begin
		drop table dbo.udtManualChangeLabelStatusLog
	end
go

create table dbo.udtManualChangeLabelStatusLog(ID int identity(1,1) not null,
											   ProductionOrder varchar(100),
											   LotID int,
											   LotNumber varchar(100),
											   CreationDate datetime default(getdate()),
											   PreviousStatus int not null,
											   FutureStatus int not null,
											   ChangeUser varchar(100),
											   RequestedBy varchar(100))

go

create index udtManualChangeLabelStatusLog_ProductionOrder on udtManualChangeLabelStatusLog(ProductionOrder)
go

create index udtManualChangeLabelStatusLog_LotID on udtManualChangeLabelStatusLog(LotID)
go

create index udtManualChangeLabelStatusLog_LotNumber on udtManualChangeLabelStatusLog(LotNumber)
go

create index udtManualChangeLabelStatusLog_CreationDate on udtManualChangeLabelStatusLog(CreationDate)
go

create index udtManualChangeLabelStatusLog_ChangeUser on udtManualChangeLabelStatusLog(ChangeUser)
go

create index udtManualChangeLabelStatusLog_RequestedBy on udtManualChangeLabelStatusLog(RequestedBy)
go

