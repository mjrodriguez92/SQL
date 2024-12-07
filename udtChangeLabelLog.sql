
if exists(select 1 from sys.objects where name = 'udtChangeLabelLog')
	begin
		drop table dbo.udtChangeLabelLog
	end
go

create table dbo.udtChangeLabelLog(ID int identity(1,1) not null,
								   ChangeType varchar(100),
								   ProductionOrder varchar(100),
								   LotID int,
								   LotNumber varchar(100),
								   CreationDate datetime default(getdate()),
								   PreviousValue varchar(100) not null,
								   FutureValue varchar(100) not null,
								   ChangeUser varchar(100),
								   RequestedBy varchar(100))

go

create index udtChangeLabelLog_ProductionOrder on udtChangeLabelLog(ProductionOrder)
go

create index udtChangeLabelLog_LotID on udtChangeLabelLog(LotID)
go

create index udtChangeLabelLog_LotNumber on udtChangeLabelLog(LotNumber)
go

create index udtChangeLabelLog_CreationDate on udtChangeLabelLog(CreationDate)
go

create index udtChangeLabelLog_ChangeUser on udtChangeLabelLog(ChangeUser)
go

create index udtChangeLabelLog_RequestedBy on udtChangeLabelLog(RequestedBy)
go

