
--select * from ffProductionOrder po with(nolock)
--inner join luproductionorderdetaildef pd with(nolock) on 

select distinct po.id as ProductionOrderID,'18' as ProductionOrderDetailDefID,'PASS' as Content INTO #Result from ffproductionorder po (NOLOCK) 
left join ffproductionorderdetail pod(NOLOCK) on pod.productionorderid=po.ID and pod.ProductionOrderDetailDefID='18'
where po.ProductionOrderNumber in ('C5B000704',
'C5B000714',
'C5B000877',
'C5B000913',
'C5B001109',
'C5B001270',
'C5B001339',
'C5B001369',
'C5B001373',
'C5B001376',
'C5B001377',
'C5B001378',
'C5B001379',
'C5B001380',
'C5B001381',
'C5B001382',
'C5B001383',
'C5B001384',
'C5B001385',
'C5B001386',
'C5B001387',
'C5B001388',
'C5B001389',
'C5B001390',
'C5B001391',
'C5B001392',
'C5B001393',
'C5B001394',
'C5B001395',
'C5B001396',
'C5B001397',
'C5B001398',
'C5B001399',
'C5B001400',
'C5B001401',
'C5B001402',
'C5B001403',
'C5B001404',
'C5B001405',
'C5B001406',
'C5B001407',
'C5B001409',
'C5B001411',
'C5B001412',
'C5B001413',
'C5B001416',
'C5B001417',
'C5B001418',
'C5B001419',
'C5B001420',
'C5B001421',
'C5B001422',
'C5B001427',
'C5B001428',
'C5B001430',
'C5B001431',
'C5B001437',
'C5B001438',
'C5B001444',
'C5B001445',
'C5B001446',
'C5B001447',
'C5B001448',
'C5B001454',
'C5B001455',
'C5B001456',
'C5B001470',
'C5B001471',
'C5B001472',
'C5B001473',
'C5B001479',
'C5B001480',
'C5B001481',
'C5B001482',
'C5B001483',
'C5B001485',
'C5B001486',
'C5B001488',
'C5B001489',
'C5B001490',
'C5B001491',
'C5B001492',
'C5B001493',
'C5B001495',
'C5B001496',
'C5B001497',
'C5B001498',
'C5B001502',
'EPQ000402',
'EPQ000412',
'EPQ000413') and pod.Content is null


begin tran
select po.productionordernumber,pod.* from ffproductionorder po (NOLOCK) 
left join ffproductionorderdetail pod(NOLOCK) on pod.productionorderid=po.ID and pod.ProductionOrderDetailDefID='18'
where po.ProductionOrderNumber in ('C5B000704',
'C5B000714',
'C5B000877',
'C5B000913',
'C5B001109',
'C5B001270',
'C5B001339',
'C5B001369',
'C5B001373',
'C5B001376',
'C5B001377',
'C5B001378',
'C5B001379',
'C5B001380',
'C5B001381',
'C5B001382',
'C5B001383',
'C5B001384',
'C5B001385',
'C5B001386',
'C5B001387',
'C5B001388',
'C5B001389',
'C5B001390',
'C5B001391',
'C5B001392',
'C5B001393',
'C5B001394',
'C5B001395',
'C5B001396',
'C5B001397',
'C5B001398',
'C5B001399',
'C5B001400',
'C5B001401',
'C5B001402',
'C5B001403',
'C5B001404',
'C5B001405',
'C5B001406',
'C5B001407',
'C5B001409',
'C5B001411',
'C5B001412',
'C5B001413',
'C5B001416',
'C5B001417',
'C5B001418',
'C5B001419',
'C5B001420',
'C5B001421',
'C5B001422',
'C5B001427',
'C5B001428',
'C5B001430',
'C5B001431',
'C5B001437',
'C5B001438',
'C5B001444',
'C5B001445',
'C5B001446',
'C5B001447',
'C5B001448',
'C5B001454',
'C5B001455',
'C5B001456',
'C5B001470',
'C5B001471',
'C5B001472',
'C5B001473',
'C5B001479',
'C5B001480',
'C5B001481',
'C5B001482',
'C5B001483',
'C5B001485',
'C5B001486',
'C5B001488',
'C5B001489',
'C5B001490',
'C5B001491',
'C5B001492',
'C5B001493',
'C5B001495',
'C5B001496',
'C5B001497',
'C5B001498',
'C5B001502',
'EPQ000402',
'EPQ000412',
'EPQ000413') and pod.Content is null

INSERT INTO ffproductionorderdetail --Save Tracebility Status Histpory
select ProductionOrderID,ProductionOrderDetailDefID,Content 
FROM #Result



select po.productionordernumber,pod.* from ffproductionorder po (NOLOCK) 
left join ffproductionorderdetail pod(NOLOCK) on pod.productionorderid=po.ID and pod.ProductionOrderDetailDefID='18'
where po.ProductionOrderNumber in ('C5B000704',
'C5B000714',
'C5B000877',
'C5B000913',
'C5B001109',
'C5B001270',
'C5B001339',
'C5B001369',
'C5B001373',
'C5B001376',
'C5B001377',
'C5B001378',
'C5B001379',
'C5B001380',
'C5B001381',
'C5B001382',
'C5B001383',
'C5B001384',
'C5B001385',
'C5B001386',
'C5B001387',
'C5B001388',
'C5B001389',
'C5B001390',
'C5B001391',
'C5B001392',
'C5B001393',
'C5B001394',
'C5B001395',
'C5B001396',
'C5B001397',
'C5B001398',
'C5B001399',
'C5B001400',
'C5B001401',
'C5B001402',
'C5B001403',
'C5B001404',
'C5B001405',
'C5B001406',
'C5B001407',
'C5B001409',
'C5B001411',
'C5B001412',
'C5B001413',
'C5B001416',
'C5B001417',
'C5B001418',
'C5B001419',
'C5B001420',
'C5B001421',
'C5B001422',
'C5B001427',
'C5B001428',
'C5B001430',
'C5B001431',
'C5B001437',
'C5B001438',
'C5B001444',
'C5B001445',
'C5B001446',
'C5B001447',
'C5B001448',
'C5B001454',
'C5B001455',
'C5B001456',
'C5B001470',
'C5B001471',
'C5B001472',
'C5B001473',
'C5B001479',
'C5B001480',
'C5B001481',
'C5B001482',
'C5B001483',
'C5B001485',
'C5B001486',
'C5B001488',
'C5B001489',
'C5B001490',
'C5B001491',
'C5B001492',
'C5B001493',
'C5B001495',
'C5B001496',
'C5B001497',
'C5B001498',
'C5B001502',
'EPQ000402',
'EPQ000412',
'EPQ000413')
rollback tran


