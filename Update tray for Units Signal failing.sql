update 
u
set u.UnitStateID = 7200
from ffUnit u with(nolock)
inner join ffSerialNumber sn with(nolock) on sn.UnitID = u.PanelID
where sn.Value in ('P0004469-G19',
'P0004479-G19',
'P0005549-G19',
'P0005969-G19',
'P0068249-K19',
'P0076656-K19',
'P0130464-A20',
'P0137851-A20',
'P0138207-A20',
'P0138609-A20',
'P0138651-A20',
'P0157560-K20',
'P0160532-K20',
'P0162295-K20',
'P0162501-K20',
'P0162939-K20',
'P0167593-K20',
'P0218503-K21',
'P0219094-K21',
'P0219657-K21',
'P0004826-G19',
'P0005739-G19',
'P0031725-J19',
'P0077078-K19',
'P0129028-M19',
'P0130017-A20',
'P0148546-A20',
'P0154789-J20',
'P0158349-K20',
'P0158953-K20',
'P0159097-K20',
'P0159560-K20',
'P0160688-K20',
'P0162476-K20',
'P0163634-K20',
'P0165139-K20',
'P0165473-K20',
'P0166829-K20',
'P0218781-K21',
'P0219024-K21',
'P0005747-G19',
'P0032170-J19',
'P0103085-L19',
'P0103088-L19',
'P0129695-A20',
'P0129715-A20',
'P0130119-A20',
'P0130535-A20',
'P0137892-A20',
'P0148779-A20',
'P0154398-J20',
'P0154786-J20',
'P0159940-K20',
'P0160586-K20',
'P0160597-K20',
'P0161720-K20',
'P0161788-K20',
'P0161954-K20',
'P0165635-K20',
'P0168493-K20',
'P0005048-G19',
'P0031507-J19',
'P0103054-L19',
'P0103299-L19',
'P0138313-A20',
'P0138621-A20',
'P0142066-A20',
'P0145104-A20',
'P0148541-A20',
'P0157582-K20',
'P0157909-K20',
'P0159327-K20',
'P0164623-K20',
'P0164661-K20',
'P0164775-K20',
'P0164875-K20',
'P0167444-K20',
'P0218704-K21',
'P0219114-K21',
'P0220122-K21')