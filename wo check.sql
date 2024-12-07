USE P_REP_LIBRE_FF
GO

------- CART AND HISTORY INFORMATION
SELECT DISTINCT 
c.SerialNumber Cart, 
tsn.Value TraySN,  
cs.Description CartStatus 
,c.CreationTime ,c.LastUpdate ,c.CurrentCount ,c.LastUpdate 
,e.UserID
FROM udtCart c WITH(nolock)
INNER JOIN udtCartHistory ch WITH(nolock) ON c.ID = ch.CartID
INNER JOIN ffEmployee e WITH(nolock) ON c.EmployeeID = e.ID 
INNER JOIN udtCartStatus cs WITH(nolock) ON c.StatusID = cs.ID
INNER JOIN ffEmployee ech WITH(nolock) ON ch.EmployeeID = ech.ID 
INNER JOIN udtCartStatus csch WITH(nolock) ON ch.StatusID = csch.ID
INNER JOIN ffStation st WITH(nolock) ON ch.StationID = st.ID
LEFT OUTER JOIN udtTray t WITH(nolock) ON c.ID = t.CartID
LEFT OUTER JOIN ffSerialNumber tsn WITH(nolock) ON t.UnitID = tsn.UnitID
WHERE c.SerialNumber IN ('A-51200163') 

---------- SEARCH THE TRAYS TO REVIEW IF CONTAINS CARTS
SELECT DISTINCT		
	tsn.value TraySN, 
	po.ProductionOrderNumber WO 
	,c.SerialNumber Cart
FROM ffSerialNumber tsn WITH(nolock)
INNER JOIN ffUnit tu WITH(nolock) ON tsn.UnitID = tu.ID
INNER JOIN ffUnit u WITH(nolock) ON tsn.UnitID = u.PanelID
INNER JOIN ffProductionOrder po WITH(nolock) ON u.ProductionOrderID = po.ID
INNER JOIN udtTray t WITH(nolock) ON tsn.UnitID = t.UnitID
LEFT OUTER JOIN udtTrayHistory th WITH(nolock) ON t.UnitID = th.UnitID
LEFT OUTER JOIN udtCart c WITH(nolock) ON t.CartID = c.ID
WHERE tsn.value IN ('A0115863-M19','A0131904-A20','A0125231-M19','A0055088-K19','A0169240-M20')

----- SEARCH THE CARTS ON THE WO
  SELECT   distinct   
	cr.WO,
	cr.Reserved_17,
   count(SN2.Value) TRAY                                                                    
  FROM
  (
	SELECT Reserved_04 WO, Reserved_17
	FROM ffMaterialUnitDetail WITH(nolock)
	WHERE Reserved_04 IN ('KTP000562')
) cr
	left outer join 
   udtCart C(NOLOCK) ON cr.Reserved_17 = c.SerialNumber        
   left outer JOIN udtTray T(NOLOCK)                                                                    
    ON T.CartID = C.ID                                                                    
   left outer JOIN ffUnit U(NOLOCK)                                                      
    ON T.UnitID = U.PanelID                                                                    
   left outer JOIN ffSerialNumber SN1(NOLOCK)                                                                    
    ON SN1.UnitID = U.ID                                                                    
   left outer JOIN ffSerialNumber SN2(NOLOCK)                                                                    
    ON SN2.UnitID = T.UnitID                                                                    
   left outer JOIN ffPart P(NOLOCK)                                                                    
    ON U.PartID = P.ID                
   left outer JOIN ffProductionOrder PO(NOLOCK)                                                                    
    ON T.ProductionOrderID = PO.ID                   
   left outer JOIN ffLineOrder LO(NOLOCK)                                                                    
    ON LO.ProductionOrderID = PO.ID                                                             
   left outer JOIN ffLine L(NOLOCK)                                                        
    ON LO.LineID = L.ID                                                                    
   left outer JOIN dbo.ffUnitDetail fud (NOLOCK)                          
    ON U.ID = fud.UnitID                                                                
GROUP BY cr.WO , cr.Reserved_17                                                     
HAVING COUNT(SN2.Value) = 0 
