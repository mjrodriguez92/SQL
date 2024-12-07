

declare @Cmd AS VARCHAR(255)
declare @ID int
declare @Folder varchar(max)
declare @FileName varchar(max)

set @Folder = '\\BFGM7827\temp\BuffaloGrove\Libre\Re-SentSignals\PackSN\Oct17\'

declare MySFCCOM cursor for
select x.ID, x.[FileName]
  from fbitSignalXML x
  left join fbitRESP r with (nolock) on x.Content.value('(flxint/app/sigref)[1]','varchar(100)') = r.ToSignalRefNumber and r.ToSignalTypeID = 14
 where x.SignalTypeID = 14
   and x.CreateDt > '2019-10-16 00:00:00'
   and r.ID is null

open MySFCCOM

fetch next from MySFCCOM into @ID, @FileName

while @@FETCH_STATUS = 0
	begin
		set @FileName = @Folder + @FileName 
		set @Cmd = 'bcp "select Content from P_LIBRE_FF.dbo.fbitSignalXML where ID = ' + rtrim(ltrim(cast(@ID as varchar(100)))) + '" queryout ' + @FileName + '  -c -T -S' + @@ServerName

		execute master.dbo.xp_CmdShell @Cmd

		fetch next from MySFCCOM into @ID, @FileName
	end

close MySFCCOM
deallocate MySFCCOM
