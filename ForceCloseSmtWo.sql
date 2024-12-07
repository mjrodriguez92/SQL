/*
select o.ProductionOrderNumber, os.[Description] OrderStatus 
  from ffProductionOrder o
  join luProductionOrderStatus os on o.StatusID = os.ID
 where o.ProductionOrderNumber in ('S20000033','S20000034')
*/
begin tran

declare @POID int
declare @PartID int
declare @PartFamilyID  int
declare @OrderQuantity int
declare @ReadyQuantity int
declare @ScrapQuantity int
declare @ScrapStatusID int
declare @NumberOfProcessingUnitsInCart int
declare @UnitStatusCompletedID int
declare @POStatusCompletedID int
declare @UnitStatusProssesingID int
declare @CartPOID int
declare @CartPOStatusID int
declare @POHistoryID int  
declare @CompleteStatusID int 
declare @CompleteQuantity int 
declare @SFCCOMCompletedTypeID int 
declare @SFCCOMForceClosedTypeID int
declare @ActivePOStatusID int
declare @MinID int
declare @MaxID int
declare @EmployeeID int
declare @WorkOrder varchar(100)

set @WorkOrder = 'S20000034'

select @POStatusCompletedID = ID 
  from luProductionOrderStatus with (nolock)
 where [Description] = 'Force-Closed'

set @EmployeeID = 1000

select @POID = po.ID, @PartID = PartID, @PartFamilyID=p.PartFamilyID  
  from ffProductionOrder po with (nolock)
  join ffpart p with (nolock) on po.PartID = p.ID
  join luPartFamily pf with (nolock) on p.PartFamilyID=pf.ID
 where pf.Name = 'PCA'
   and ProductionOrderNumber = @WorkOrder

update ffProductionOrder
   set StatusID = @POStatusCompletedID, ActualFinishTime = getdate() 
 where ID = @POID 

insert into ffProductionOrderHistory
select ID, StatusID, getdate(), 'Unit had been completed Manually by ' + SYSTEM_USER + ' due to issues to close the order automatically.', @EmployeeID 
  from ffProductionOrder
 where ID = @POID

--================================================================================================ 
-- Add SFCCOM register to trigger the Close Order to Baan
--================================================================================================ 
    set @POHistoryID = @@IDENTITY
                     
    select @SFCCOMCompletedTypeID = ID from udtfbitLuSFCCOMType with (nolock) where [Type] = 'POCompleted'
    select @SFCCOMForceClosedTypeID = ID from udtfbitLuSFCCOMType with (nolock) where [Type] = 'POForceClosed'
              
    if not exists (select top 1 1 from udtfbitSFCCOM with (nolock) where ProductionOrderID = @POID and TypeID in (@SFCCOMCompletedTypeID, @SFCCOMForceClosedTypeID))
		begin                

			insert into udtfbitSFCCOM  
					(SignalXMLID, PartID, PartNumber ,ProductionOrderID, UnitID, LooperCount, PackageID, PackageSize, Operation, StatusID, StationID, HistoryID, TypeID, CreateBy  
					,CreateDt, UpdateBy, UpdateDt, PartFamilyID, LotUnitID, LotUnitLooperCount, LotSize, LotUnitType, BindUnitType)  
			values
					(0, @PartID, NULL, @POID, NULL, NULL, NULL, NULL, '', 0, NULL, @POHistoryID, @SFCCOMForceClosedTypeID, 'admin',
					getdate(), 'admin', getdate(), @PartFamilyID, NULL, NULL, NULL, NULL, NULL)
		end

select o.ProductionOrderNumber, os.[Description] OrderStatus 
  from ffProductionOrder o
  join luProductionOrderStatus os on o.StatusID = os.ID
 where o.ProductionOrderNumber in ('S20000033','S20000034')

 --commit
rollback tran






