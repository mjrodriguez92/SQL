/*

Server: BFGSQLAP502.bfg.flextronics.com
DB: P_Libre_MDS

This is the query when you try to find a SN after scanning the PCBA
*/

select fct.RFSerialNumber, unit.SerialNumber  
  from DS_FT_FCTest fct with (nolock)
  join DS_FT_Unit unit on with (nolock) unit.Unit_Id = fct.Unit_Id 
 where RFserialNumber in ('E007A000604814f5')

/*
And this query is to check the status of a tray when you get the error that the tray is still attached to another cart of previous orders
*/

select top 1000 *
  from DS_FT_TraySorter ts with (nolock)
  join DS_Dim_Tray t on with (nolock) ts.Tray_Id=t.Tray_Id
 where t.TraySN in ('S0001804-F-19')
 order by t.TraySN, ts.CreateDttm desc


