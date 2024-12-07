/*******************************************************************************************
Create a new record in ffpackage history Table in order to re-send a PackSN signla to BaaN
*******************************************************************************************/

declare @detalDefID int  
declare @ProductionOrderId int  
declare @SignalTypeId int  
declare @StatusId int   
declare @StID int
declare @MinID int
declare @MaxID int
declare @PackageID bigint
declare @PackingOldHistoryID bigint
declare @PackingNewHistoryID bigint
declare @PackingClosedAction_ID int
declare @PalletID int
declare @StationName varchar(100)

declare @OrderNumber varchar(100)
declare @Pallet varchar(100)

set @OrderNumber = 'C50000040'
set @Pallet = 'PLT00000000670'

/***************************************************
ApplicatorPreReleaseStationType --> for applicator
ContainerPreReleaseStationType --> for Container
****************************************************/
set @StationName = 'ContainerPreReleaseStationType'

select @ProductionOrderId = id from ffProductionOrder where ProductionOrderNumber = @OrderNumber -- Production Order Number
select @PalletID = id from ffPackage where SerialNumber = @Pallet -- Pallet

select @StID = ID
  from ffStation
 where StationTypeID = (select ID 
						  from ffStationType 
						 where [Description] = (select Value
												  from fsVar
												 where name = @StationName))
   and LineID = (select top 1 LineID 
				   from ffProductionOrder po
				   join ffLineOrder lo on po.ID = lo.ProductionOrderID 
				  where po.ID = @ProductionOrderId)

	if object_id('tempdb..#Palletlist') is not null
		drop table #Palletlist

    create table #Palletlist(ID int identity(1,1), PackID int, PackageSN varchar(80))
  
	/* If the Pallet is not closed, we have tlo closed it in order to send the PACKSN signal to BaaN */
	if not exists(select 1
				    from ffPackage p with (nolock) 
				   where p.StatusID in (select ID 
										  from luPackageStatus 
									     where [Description] in ('Closed','ForceClosed')) 
				     and p.ID = @PalletID)
		begin
			update ffPackage set StatusID = 2 where ID = @PalletID
		end

	insert into #Palletlist
	select p.ID, p.SerialNumber
	  from ffPackage p with (nolock) 
	 where p.CurrProductionOrderID = @ProductionOrderId 
	   and p.Stage = 2 
	   and p.StatusID in (select ID 
							from luPackageStatus 
						   where [Description] in ('Closed','ForceClosed')) 
	   and p.serialnumber = @Pallet

    select @MinID = min(ID), @MaxID = max(ID) from #Palletlist

    while @MaxID >= @MinID
    begin
        set @PackageID = null
        set @PackingOldHistoryID = null
        set @PackingNewHistoryID = null

        select @PackageID = PackID from #Palletlist where ID = @MinID
                                         
        insert into ffPackageHistory (PackageID, PackageStatusID, StationID, EmployeeID, [Time])  
        select p.ID, p.StatusID, @StID, p.EmployeeID, getdate()  
          from ffPackage p with (nolock) 
         where p.ID = @PackageID 

        set @PackingNewHistoryID = @@IDENTITY
              
        select top 1 @PackingOldHistoryID = PackageHistoryID 
          from ffPackingInfoLog with (nolock) 
         where PackageID = @PackageID 
		 order by PackageHistoryID desc

        update ffPackingInfoLog set PackageHistoryID = @PackingNewHistoryID where PackageHistoryID = @PackingOldHistoryID 
        
        set @MinID = @MinID + 1

    end

	if object_id('tempdb..#Palletlist') is not null
		drop table #Palletlist

