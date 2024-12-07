
declare @PO VARCHAR(50)= 'C50000018'
declare @SENSORPARTID INT

/* Get the skids fro the order */
select  mu.id, mu.SerialNumber,mu.BalanceQty,  P.PartNumber, P.Revision, ms.[Description], sd.LotCode, mud.Reserved_02, mud.Reserved_13, MU.*, mud.*, sd.*
  from ffmaterialunit MU
  join ffmaterialunitdetail MUD on MUD.MaterialUnitID = MU.ID
  join ffPart P on P.ID = MU.PartID
  join luMaterialUnitStatus ms on ms.ID = mu.StatusID
  join udtSensorData sd on sd.LotCode =  mud.Reserved_02
where MUD.reserved_04 = @PO 

/* Review if the signal were sent for the reels form BaaN */
select x.Content.value('(flxint/app/data/rec/skids/skid_rec/order/orno)[1]','varchar(100)'), x.Content.value('(flxint/app/data/rec/item)[1]','varchar(100)'), *
  from fbitSignalXML x
 where x.SignalTypeID = 1
   and x.Content.value('(flxint/app/data/rec/skids/skid_rec/order/orno)[1]','varchar(100)') = @PO
 order by id desc

