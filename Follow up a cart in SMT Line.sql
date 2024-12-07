/* Con el query sig pueden se muestran los movimientos de un carro */

select * from udtCartHistory ch
join ffStation s on ch.StationID=s.ID where CartID=-2147483528
order by ch.ID

/* Con este query pueden sacar las unidades q se escrapearon del carro */

select sn.Value, hs.StationID, s.Description, hs.UnitStatusID, hs.Time from ffSerialNumber sn
join ffUnitStatusHistory hs on sn.UnitID=hs.UnitID
join ffHistory h on sn.UnitID=h.UnitID 
join ffStation s on hs.StationID=s.ID
where h.StationID=51 and h.ProductionOrderID=133 and sn.SerialNumberTypeID=0 and len(sn.Value) > 20 and Time < '2019-08-04 17:33:07.870' and hs.UnitStatusID=3
order by sn.Value, hs.Time

/* y el carro después de regresar solo sale con 1004 como se ve en el query sig. */

select sn.Value, hs.StationID, min(s.Description), count(hs.UnitStatusID), hs.Time from ffSerialNumber sn
join ffUnitStatusHistory hs on sn.UnitID=hs.UnitID
join ffHistory h on sn.UnitID=h.UnitID 
join ffStation s on hs.StationID=s.ID
where h.StationID=157 and h.ProductionOrderID=133 and sn.SerialNumberTypeID=0 and len(sn.Value) > 20 and Time < '2019-08-04 17:33:07.870' and hs.UnitStatusID in(0,1,3)
group by hs.StationID, sn.Value, hs.Time
having count(hs.UnitStatusID)<2
order by sn.Value, hs.Time

