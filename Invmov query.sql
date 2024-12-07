USE P_LIBRE_FF
GO

---- TO TAKE THE CURRENT PALLET INFORMATION
 select ph.* from ffPackageHistory  ph
    join ffPackage p on ph.PackageID = p.ID
	 where p.SerialNumber in ('PLTK4700000266')

	 --,'PLTK4700000280','PLTK4700000256','PLTK4700000260','PLTK4700000263','PLTK4700000266'
	 
  --select * from ffStationType where Description like 'KP_Move_Pallet_O2P_OUT%'
  select * from ffStation  where Description like 'KP_Move_Release_to_O2P%'
  select * from ffLine  where ID = 19


begin tran 
  insert into ffPackageHistory values (925332,1,663,1000,GETDATE() )
  insert into ffPackageHistory values (925182,1,663,1000,GETDATE() )
  insert into ffPackageHistory values (925712,1,663,1000,GETDATE() )
  insert into ffPackageHistory values (924252,1,663,1000,GETDATE() )
  insert into ffPackageHistory values (924477,1,663,1000,GETDATE() )
  insert into ffPackageHistory values (924657,1,663,1000,GETDATE() )
  insert into ffPackageHistory values (924829,1,663,1000,GETDATE() )

    DECLARE @p2 NVARCHAR(MAX);
    SET @p2 = NULL;
    DECLARE @p3 NVARCHAR(MAX);
    SET @p3 = NULL;
    DECLARE @p4 INT;
    SET @p4 = 0;
    DECLARE @p5 NVARCHAR(MAX);
    SET @p5 = NULL;
    DECLARE @p6 INT;
    SET @p6 = NULL;
    
    EXEC @p6 = fbipExportProxy_LibrEInvMov
         @request_xml = N'', 
         @signal_xml = @p2 OUTPUT, 
         @signal_xml_def = @p3 OUTPUT, 
         @error_code = @p4 OUTPUT, 
         @error_message_xml = @p5 OUTPUT, 
         @filename = @p6 OUTPUT;
    SELECT @p2, 
           @p3, 
           @p4, 
           @p5, 
           @p6;


    EXEC @p6 = fbipExportProxy_LibrEInvMov
         @request_xml = N'', 
         @signal_xml = @p2 OUTPUT, 
         @signal_xml_def = @p3 OUTPUT, 
         @error_code = @p4 OUTPUT, 
         @error_message_xml = @p5 OUTPUT, 
         @filename = @p6 OUTPUT;
    SELECT @p2, 
           @p3, 
           @p4, 
           @p5, 
           @p6;


rollback tran 

