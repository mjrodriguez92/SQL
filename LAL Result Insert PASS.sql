--11539,
--11540,
--11570,
--11574,
--11589,
--11608,
--11638,
--11688,
--11687,
--11723,
--11740,
--11748,
--11752,
--11777,
--11793,
--11799
----select * from ffProductionOrder po with(nolock)
--inner join luproductionorderdetaildef pd with(nolock) on 

DROP TABLE #RESULT

select distinct po.id as ProductionOrderID,'18' as ProductionOrderDetailDefID,'PASS' as Content INTO #Result from ffproductionorder po (NOLOCK) 
left join ffproductionorderdetail pod(NOLOCK) on pod.productionorderid=po.ID and pod.ProductionOrderDetailDefID='18'
where po.ProductionOrderNumber in ('C5B001680',
'C5B001660',
'C5B001558',
'C5B001631',
'C5B001696',
'C5B001601',
'C5B001685',
'C5B001628',
'C5B001616',
'C5B001627',
'C5B001693',
'C5B001564',
'C5B001658',
'C5B001667',
'C5B001638',
'C5B001645',
'C5B001612',
'C5B001653',
'C5B001682',
'C5B001686',
'C5B001668',
'C5B001635',
'C5B001663',
'C5B001676',
'C5B001623',
'C5B001646',
'C5B001665',
'C5B001700',
'C5B001648',
'C5B001573',
'C5B001651',
'C5B001671',
'C5B001669',
'C5B001641',
'C5B001636',
'C5B001683',
'C5B001681',
'C5B001640',
'C5B001694',
'C5B001670',
'C5B001678',
'C5B001633',
'C5B001652',
'C5B001643',
'C5B001613',
'C5B001657',
'C5B001629',
'C5B001634',
'C5B001647',
'C5B001675',
'C5B001649',
'C5B001679',
'C5B001692',
'C5B001673',
'C5B001684',
'C5B001659',
'C5B001672',
'C5B001583',
'C5B001626',
'C5B001576',
'C5B001656',
'C5B001632',
'C5B001655',
'C5B001637',
'C5B001662',
'C5B001687',
'C5B001661',
'C5B001569',
'C5B001644',
'C5B001625',
'C5B001698',
'C5B001577',
'C5B001639',
'C5B001666') and pod.Content is null

select * from #RESULT

begin tran
select po.productionordernumber,pod.* from ffproductionorder po (NOLOCK) 
left join ffproductionorderdetail pod(NOLOCK) on pod.productionorderid=po.ID and pod.ProductionOrderDetailDefID='18'
where po.ProductionOrderNumber in ('C5B001680',
'C5B001660',
'C5B001558',
'C5B001631',
'C5B001696',
'C5B001601',
'C5B001685',
'C5B001628',
'C5B001616',
'C5B001627',
'C5B001693',
'C5B001564',
'C5B001658',
'C5B001667',
'C5B001638',
'C5B001645',
'C5B001612',
'C5B001653',
'C5B001682',
'C5B001686',
'C5B001668',
'C5B001635',
'C5B001663',
'C5B001676',
'C5B001623',
'C5B001646',
'C5B001665',
'C5B001700',
'C5B001648',
'C5B001573',
'C5B001651',
'C5B001671',
'C5B001669',
'C5B001641',
'C5B001636',
'C5B001683',
'C5B001681',
'C5B001640',
'C5B001694',
'C5B001670',
'C5B001678',
'C5B001633',
'C5B001652',
'C5B001643',
'C5B001613',
'C5B001657',
'C5B001629',
'C5B001634',
'C5B001647',
'C5B001675',
'C5B001649',
'C5B001679',
'C5B001692',
'C5B001673',
'C5B001684',
'C5B001659',
'C5B001672',
'C5B001583',
'C5B001626',
'C5B001576',
'C5B001656',
'C5B001632',
'C5B001655',
'C5B001637',
'C5B001662',
'C5B001687',
'C5B001661',
'C5B001569',
'C5B001644',
'C5B001625',
'C5B001698',
'C5B001577',
'C5B001639',
'C5B001666') and pod.Content is null

INSERT INTO ffproductionorderdetail --Save Tracebility Status Histpory
select ProductionOrderID,ProductionOrderDetailDefID,Content 
FROM #Result



select po.productionordernumber,pod.* from ffproductionorder po (NOLOCK) 
left join ffproductionorderdetail pod(NOLOCK) on pod.productionorderid=po.ID and pod.ProductionOrderDetailDefID='18'
where po.ProductionOrderNumber in ('C5B001680',
'C5B001660',
'C5B001558',
'C5B001631',
'C5B001696',
'C5B001601',
'C5B001685',
'C5B001628',
'C5B001616',
'C5B001627',
'C5B001693',
'C5B001564',
'C5B001658',
'C5B001667',
'C5B001638',
'C5B001645',
'C5B001612',
'C5B001653',
'C5B001682',
'C5B001686',
'C5B001668',
'C5B001635',
'C5B001663',
'C5B001676',
'C5B001623',
'C5B001646',
'C5B001665',
'C5B001700',
'C5B001648',
'C5B001573',
'C5B001651',
'C5B001671',
'C5B001669',
'C5B001641',
'C5B001636',
'C5B001683',
'C5B001681',
'C5B001640',
'C5B001694',
'C5B001670',
'C5B001678',
'C5B001633',
'C5B001652',
'C5B001643',
'C5B001613',
'C5B001657',
'C5B001629',
'C5B001634',
'C5B001647',
'C5B001675',
'C5B001649',
'C5B001679',
'C5B001692',
'C5B001673',
'C5B001684',
'C5B001659',
'C5B001672',
'C5B001583',
'C5B001626',
'C5B001576',
'C5B001656',
'C5B001632',
'C5B001655',
'C5B001637',
'C5B001662',
'C5B001687',
'C5B001661',
'C5B001569',
'C5B001644',
'C5B001625',
'C5B001698',
'C5B001577',
'C5B001639',
'C5B001666')
rollback tran


select * from luProductionOrderStatus