declare @order varchar (100)

set @order = 'K60000139'
SELECT *
FROM UDT_PersistKitPackMDSFilesStatus(NOLOCK)
WHERE lotnumber = @order
ORDER BY ID DESC;
SELECT JSON_VALUE(REQUEST, '$.lot'), 
       *
FROM
(
    SELECT *
    FROM
    (
        SELECT TOP 10000 *
        FROM udtKitPack_APILog
        WHERE JSON_VALUE(REQUEST, '$.lot') = @order
    ) AS T
) AS t2
ORDER BY CreationTime DESC;
print 'xxxx'

--------
hotline number   SQL DBA Team HotLine
6666-150-6677
