SELECT TOP (1000) [ID]
      ,[MaterialUnitID]
      ,[LooperCount]
      ,[Reserved_01]
      ,[Reserved_02]
      ,[Reserved_03]
      ,[Reserved_04]
      ,[Reserved_05]
      ,[Reserved_06]
      ,[Reserved_07]
      ,[Reserved_08]
      ,[Reserved_09]
      ,[Reserved_10]
      ,[Reserved_11]
      ,[Reserved_12]
      ,[Reserved_13]
      ,[Reserved_14]
      ,[Reserved_15]
      ,[Reserved_16]
      ,[Reserved_17]
      ,[Reserved_18]
      ,[Reserved_19]
      ,[Reserved_20]
  FROM [p_REP_LIBRE_FF].[dbo].[ffMaterialUnitDetail]
  Where
  --Reserved_04 = 'KTP000450' -- Change the WO 
  --and 
   reserved_17 = 'C49200408' -- Change the Cart ID 

--Begin tran   
--Update ffMaterialUnitDetail
--set reserved_17 =  Reserved_17 + '_3296409', -- Attached the Monitor Ticket
--Reserved_04 = Reserved_04 + '_3296409'  -- Attached the Monitor Ticket 
--Where ID = -2146761078 -- Change the ID 

--select * from ffmaterialunitdetail where ID = -2146761078

--Rollback Tran