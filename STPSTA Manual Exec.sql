
SELECT 'fbipExportProxy_LibreSTPSTA' RunTable, getdate() AS RunTime

--begin tran

declare @p2 nvarchar(max)
set @p2=NULL
declare @p3 nvarchar(max)
set @p3=NULL
declare @p4 int
set @p4=0
declare @p5 nvarchar(max)
set @p5=NULL
declare @p6 int
set @p6=NULL
exec fbipExportProxy_LibreSTPSTA @request_xml=N'',@signal_xml=@p2 output,@signal_xml_def=@p3 output,@error_code=@p4 output,@error_message_xml=@p5 output,@filename=@p6 output
select @p2, @p3, @p4, @p5, @p6

--rollback tran

SELECT 'END fbipExportProxy_LibreSTPSTA' RunTable, getdate() AS RunTime



DECLARE @SourceLastID as int
DECLARE @SourcePackageLastID as int		
DECLARE @SourceCartLastID as int


SELECT @SourcePackageLastID=Value from fbitconfig(nolock) where typeid=17 and name ='SourcePackageLastID'
SELECT @SourceLastID=Value from fbitconfig(nolock) where typeid=17 and name ='PackageLastID'

SELECT 'STPSTA_ffPackageHistory' Signal,GETDATE(), @SourcePackageLastID 'SourcePackageLastID' ,max(id) ffPackageID ,@SourcePackageLastID-max(id) Delta from ffPackageHistory

SELECT st.* ,pk.SerialNumber ,po.ProductionOrderNumber, sxml.Content
FROM udtfbitLibreSTPSTAPackage st WITH(nolock)
LEFT OUTER JOIN ffPackage pk WITH(nolock) ON st.PackageID = pk.ID
LEFT OUTER JOIN ffProductionOrder po WITH(nolock) ON st.ProductionOrderID = po.ID
LEFT OUTER JOIN fbitSignalXML sxml WITH(nolock) ON st.SignalXMLID = sxml.ID
WHERE st.CreateDt >= '2022-01-15 04:00:00' --and st.packageid = 2783821
ORDER BY st.ID