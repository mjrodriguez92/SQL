/* Get the unkown Serial Number from Flexlfow */

select SN.Value, ud.reserved_22 unknownSN
  from ffSerialNumber SN
  join ffUnitDetail ud on sn.UnitID = ud.UnitID
 where SN.value in ('P36190016',
'P36190013',
'P36190015',
'P3619001D',
'P3619001E',
'P36190014',
'P3619001B',
'P3619001K',
'P36190018',
'P3619001F',
'P3619001N',
'P3619001G',
'P3619001I',
'P3619001H',
'P3619001J',
'P3619001M',
'P3619001L',
'P3619000Z',
'P3619001C',
'P3619001A',
'P36190017',
'P36190019',
'P36190010',
'P36190012',
'P36190011',
'P3619001O')

/* With the Unkown Serial Number get the real SN in Flexflow and then go  back to flexflow and look */

select fct.RFSerialNumber, unit.SerialNumber  
  from DS_FT_FCTest fct 
  join DS_FT_Unit unit on unit.Unit_Id = fct.Unit_Id 
 where RFserialNumber in ('E007A000046EBB52')


