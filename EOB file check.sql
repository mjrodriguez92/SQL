declare
@order VARCHAR(50)
set @order = 'KTP001606'

select *
from udt_persistkitpackmdsfilesstatus(nolock)
where lotnumber = @order
order by ID desc ;
select JSON_VALUE(REQUEST,'$.lot'), *
from
(
select *
from
(
select top 10000 *
from udtkitpack_APIlog(nolock)
where JSON_VALUE(REQUEST, '$.lot') = @order
) AS T
) AS t2
ORDER BY creationtime DESC;
