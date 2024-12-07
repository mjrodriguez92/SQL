declare @order varchar (100)

 

set @order = 'KTP000996'
SELECT *
FROM UDT_PersistKitPackMDSFilesStatus WITH(NOLOCK)
WHERE lotnumber = @order
ORDER BY ID DESC;