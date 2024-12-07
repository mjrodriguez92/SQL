/*******************************************************************************************
Create a new record in ffpackage history Table in order to re-send a INVMOV signal to BaaN

@StationName: Is the station type configured on the Libre INVMOV Station Type Warehouse Map
			  External module FAISignalManagerAdd-Ons below the station type per each factory
			  to send INVMOV for O2P (if need it for another stage, please check first the
			  Libre INVMOV Station Type Warehouse Map module to get the right Station Name 			

For O2P only!!
Applicator = "Applicator Move Pallet to O2P"
Container = "Container Move Pallet to O2P"
KitPack = "KP_Move_Release_to_O2P"
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

declare @Pallet varchar(100)
declare @OrderNumber varchar(100)

set @OrderNumber = 'K60000012'
set @Pallet = 'PLTK4700000017'
set @StationName = 'KP_Move_Release_to_O2P'

select @PalletID = id from ffPackage where SerialNumber = @Pallet
select @ProductionOrderId = ID from ffProductionOrder where ProductionOrderNumber = @OrderNumber

select @StID = ID
  from ffStation
 where StationTypeID = (select ID 
						  from ffStationType 
						 where [Description] = @StationName)
   and LineID = (select top 1 LineID 
				   from ffProductionOrder po
				   join ffLineOrder lo on po.ID = lo.ProductionOrderID 
				  where po.ID = @ProductionOrderId)

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

    insert into ffPackageHistory (PackageID, PackageStatusID, StationID, EmployeeID, [Time])  
    select p.ID, p.StatusID, @StID, p.EmployeeID, getdate()  
      from ffPackage p with (nolock) 
     where p.ID = @PalletID 
