--1
select * from udtTray join 
ffSerialNumber on ffSerialNumber.UnitID= udtTray.UnitID

where ffSerialNumber.value=''

--2
select * from udtTray join 
ffSerialNumber on ffSerialNumber.UnitID= udtTray.UnitID

where udtTray.StackID=''

--3
select * from udtTray join 
ffSerialNumber sn on sn.UnitID= udtTray.UnitID
join ffunit u
on u.ID=udtTray.UnitID
join ffUnit u2
on u2.PanelID=u.ID
JOIN ffSerialNumber ff2
on ff2.UnitID=u2.ID and ff2.SerialNumberTypeID=0
where udtTray.StackID=''
