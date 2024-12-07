--select * from ffPackage with(nolock)
--where SerialNumber = 'PLTK3700000347'

--select * from ffProductionOrder
--where ProductionOrderNumber like 'K%'
--ORDER BY ID DESC

select sn.Value as YellowBox,us.Description as YellowBoxStatus,u.StatusID as YelowBoxUID,ybp.PartNumber as YellowBoxPart,PO.ProductionOrderNumber AS YellowBoxPO,kwop.PartNumber as KPPart,L.Description AS KitPack_Line,
uc.ChildSerialNumber as APP_USN,aus.Description as APPUIDStatus,APO.ProductionOrderNumber AS APPPO,AL.Description AS APP_Line,appp.PartNumber as APP_WOPart,
uc2.ChildSerialNumber as CON_USN,cus.Description as CONUIDStatus,CPO.ProductionOrderNumber AS CONPO,CL.Description AS CON_Line,cppp.PartNumber as CON_WOPart,
pbox.SerialNumber AS ShipperBoxSN,pbox.StatusID,BoxStatus.Description as BoxStatus,BOXP.PartNumber as ShiiperBox_Part,
ppallet.SerialNumber AS PalletSN,ppallet.StatusID,PalletStatus.Description as PalletStatus,PalletP.PartNumber as Pallet_Part
from ffUnitDetail  ud with(nolock)
inner join ffUnit u with(nolock) on u.ID = ud.UnitID
inner join ffProductionOrder PO WITH(NOLOCK) ON PO.ID = U.ProductionOrderID
inner join ffPart kwop with(nolock) on kwop.ID = po.PartID
inner join luUnitStatus us with(nolock) on us.ID = u.StatusID
inner join ffSerialNumber sn with(nolock) on sn.UnitID = u.ID
inner join ffPart ybp with(nolock) on ybp.ID = u.PartID
INNER JOIN ffLineOrder LO with(nolock) on Lo.ProductionOrderID = po.ID
inner join ffLine l with(nolock) on L.ID = LO.LineID
inner join ffUnitComponent uc with(nolock) on uc.UnitID = u.ID AND SUBSTRING(uc.ChildSerialNumber,1,1) = 'E'
inner join ffUnit au with(nolock) on au.ID = uc.ChildUnitID 
inner join ffProductionOrder APO WITH(NOLOCK) ON APO.ID = AU.ProductionOrderID
inner join ffPart appp with(nolock) on appp.ID = apo.PartID
INNER JOIN ffLineOrder ALO with(nolock) on Alo.ProductionOrderID = apo.ID
inner join ffLine Al with(nolock) on AL.ID = ALO.LineID
inner join ffUnitComponent uc2 with(nolock) on uc2.UnitID = u.ID AND SUBSTRING(uc2.ChildSerialNumber,1,1) = '3'
inner join ffUnit cu with(nolock) on cu.ID = uc2.ChildUnitID 
inner join ffProductionOrder CPO WITH(NOLOCK) ON CPO.ID = CU.ProductionOrderID
inner join ffPart cppp with(nolock) on cppp.ID = CPO.PartID
INNER JOIN ffLineOrder CLO with(nolock) on Clo.ProductionOrderID = CPO.ID
inner join ffLine Cl with(nolock) on CL.ID = CLO.LineID
inner join luUnitStatus cus with(nolock) on cus.ID = cu.StatusID
inner join luUnitStatus aus with(nolock) on aus.ID = au.StatusID
inner join ffPackage pbox with(nolock) on pbox.ID = ud.InmostPackageID
INNER JOIN ffPart BOXP WITH(NOLOCK) ON BOXP.ID = PBOX.CurrPartID
inner join luPackageStatus BoxStatus with(nolock) on BoxStatus.ID = pbox.StatusID
inner join ffPackage ppallet with(nolock) on ppallet.ID = ud.OutmostPackageID
INNER JOIN ffPart PalletP with(nolock) on palletp.ID = ppallet.CurrPartID
inner join luPackageStatus PalletStatus with(nolock) on PalletStatus.ID = pbox.StatusID
where ppallet.SerialNumber = 'PLTK3800000258' 
--PLTK3800000258 
--where OutmostPackageID = '663566' 
--PLTK3700000347

--select top 1000 * from ffUnitComponent with(nolock)
--where UnitID = -2058157147
--order by id desc



