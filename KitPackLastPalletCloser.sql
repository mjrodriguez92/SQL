select * from UDT_PersistKitPackMDSFilesStatus WITH(NOLOCK)
where LotNumber = 'KTP001142'
ORDER BY CratedDate desc

select * from ffProductionOrder with(nolock) 
where ProductionOrderNumber = 'KTP001142'

select * from ffProductionOrderHistory poh with(nolock)
inner join luProductionOrderStatus lpos with(nolock) on lpos.ID = poh.ProductionOrderStatusID
where ProductionOrderID = 5985

select podd.*,pod.Content,po.StatusID from ffProductionOrder po with(nolock)
join ffProductionOrderDetail pod with(nolock) on pod.ProductionOrderID =po.ID 
join luProductionOrderDetailDef podd with(nolock) on podd.ID =pod.ProductionOrderDetailDefID
where po.ProductionOrderNumber ='KTP001142'

select * from ffPackage p with(nolock)
where P.CurrProductionOrderID = '5985' and p.SerialNumber like 'P%'


declare @order varchar (100)

set @order = 'KTP001142'
SELECT JSON_VALUE(REQUEST, '$.lot'), 
       *
FROM
(
    SELECT *
    FROM
    (
        SELECT TOP 10000 *
        FROM udtKitPack_APILog with(nolock)
        WHERE JSON_VALUE(REQUEST, '$.lot') = @order
    ) AS T
) AS t2
ORDER BY CreationTime DESC;