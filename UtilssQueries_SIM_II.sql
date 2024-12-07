

	SELECT * FROM ffPart WHERE PartNumber = 'THRL-PRT23207-750A'

	SELECT * FROM fbitLuSignalType

	SELECT * FROM fbitSignal s INNER JOIN fbitSignalXML x ON x.SignalID = s.id
	WHERE s.SignalTypeID = 13 ORDER BY s.CreateDt DESC

	SELECT * FROM ffProductionOrder po WHERE po.ProductionOrderNumber LIKE 'C%' ORDER BY po.CreationTime DESC


	SELECT * FROM ffMaterialUnit mu INNER JOIN ffPart p ON p.ID = mu.PartID 
		INNER JOIN ffMaterialUnitDetail mud ON mud.MaterialUnitID = mu.ID
	WHERE --p.PartNumber LIKE '%SENSOR%' AND 
	mud.Reserved_13 IS NOT NULL

	UPDATE mud 
		SET Reserved_13 = NULL
	FROM ffMaterialUnit mu INNER JOIN ffPart p ON p.ID = mu.PartID 
		INNER JOIN ffMaterialUnitDetail mud ON mud.MaterialUnitID = mu.ID
	WHERE mu.SerialNumber = 'SK00063'

SELECT * 
	FROM ffSerialNumber sn INNER JOIN udtTray t
	ON t.UnitID = sn.UnitID
WHERE sn.Value = 'TRAY266'

	SELECT * FROM ffStationType stt
		INNER JOIN ffStation st ON st.StationTypeID = stt.ID
		INNER JOIN ffLine l ON l.ID = st.LineID
	WHERE stt.Description LIKE 'Puck UC_Panel_PO_Tray'

	SELECT * FROM fsFieldDefinition WHERE TableName = 'ffUnitDetail'

	SELECT --c.SerialNumber CartID,
		st.SerialNumber AS StackSN,traySN.Value AS TraySN, t.StackOrder,ud.reserved_07 'Retain',ud.reserved_12 'Reconciliation',ud.reserved_17 'MDSStatus' ,* FROM ffUnit u
		INNER JOIN udtTray t ON t.UnitID = u.ID
		INNER JOIN ffSerialNumber traySN ON traySN.UnitID = u.ID
		INNER JOIN udtStack st ON st.ID = t.StackID
		INNER JOIN ffProductionOrder po ON po.ID = t.ProductionOrderID
		INNER JOIN ffUnitDetail ud ON ud.UnitID = u.ID AND ud.LooperCount = u.LooperCount
		--INNER JOIN ffUnitState stat ON stat.id	 = u.UnitStateID
		--INNER JOIN udtCart c ON c.ID = t.CartID
	WHERE ud.reserved_07 IS NOT NULL--po.ProductionOrderNumber = 'C51000082'

	SELECT * FROM ffTest t INNER JOIN ffSerialNumber sn ON sn.UnitID = t.UnitID AND sn.SerialNumberTypeID = 0 WHERE t.IsPass = 0 ORDER BY t.CreationTime DESC

	SELECT * FROM fsFieldDefinition WHERE TableName = 'ffMaterialUnitDetail'
	
	SELECT mu.SerialNumber,mud.Reserved_05 ExpirationDate,* FROM ffMaterialUnit mu
		INNER JOIN ffMaterialUnitDetail mud ON mud.MaterialUnitID = mu.ID
	WHERE mud.Reserved_05 IS NOT NULL


	SELECT DISTINCT p.SerialNumber FROM ffUnit u
	INNER JOIN ffUnitDetail ud ON ud.UnitID = u.ID AND ud.LooperCount = u.LooperCount
	INNER JOIN ffPackage p ON p.ID = ud.InmostPackageID
	INNER JOIN ffunit t ON t.ID = u.PanelID
	INNER JOIN ffSerialNumber unitSN ON unitsn.UnitID = u.ID
	INNER JOIN ffSerialNumber TraySN ON TraySN.UnitID = t.ID
	INNER JOIN ffProductionOrder po ON po.ID = u.ProductionOrderID
WHERE po.ProductionOrderNumber = 'C50000086'



--	OBJTSKSETUNITSTATE
--@xmlSerialNumber = '<?xml version="1.0" encoding="ISO-8859-1"?><SerialNumber><S Descr="ID"><![CDATA[247241]]></S></SerialNumber>', -- (System.String)
--	@OutputStateDef = 'FAIL', -- (System.String)
--	@xmlStation = '<?xml version="1.0" encoding="ISO-8859-1"?><StationInfo ID="249" Description="ABW03 Reconcilation" StationTypeID="124" LineID="20" />', -- (System.String)
--	@EmployeeID = 1040, -- (System.Int32)
--	@EnterTime = 5/6/2019 4:32:57 PM, -- (System.DateTime)
--	@ExitTime = 5/6/2019 4:32:57 PM, -- (System.DateTime)
--RETURN VALUE = 250010070


	SELECT * 
	--UPDATE u
	--	SET u.UnitStateID = 4900
		FROM udtTray tray INNER JOIN ffSerialNumber TraySN ON tray.UnitID = TraySN.UnitID
		INNER JOiN ffUnit u ON u.ID = tray.UnitID
		--INNER JOIN ffunit child ON child.PanelID = u.ID
	WHERE TraySN.Value = 'TRAY19116'


	SELECT * FROM udtSensorData

	SELECT * FROM udtSensorSerials

	SELECT * FROM fsFieldDefinition WHERE TableName = 'ffMaterialUnitDetail'


	SELECT DISTINCT TOP 10  mu.SerialNumber
	FROM	ffserialnumber sn 
		INNER JOIN udtSensorSerials ss ON ss.Serial = sn.Value
		INNER JOIN udtSensorData sd ON sd.ID = ss.SensorDataID
		INNER JOIN ffMaterialUnitDetail ud ON ud.Reserved_02 = sd.LotCode
		INNER JOIN ffMaterialUnit mu ON mu.ID = ud.MaterialUnitID
	WHERE ud.Reserved_13 IS NOT NULL --mu.SerialNumber = 'SK00233'

	SELECT TOP 10	ss.Serial 'Sensor Serial Number',
					mu.SerialNumber 'Baan SKID',
					ud.Reserved_02 'Sensor Lot Number',
					ud.Reserved_13 'Open Bag Time'				 
	FROM ffserialnumber sn 
		INNER JOIN udtSensorSerials ss ON ss.Serial = sn.Value
		INNER JOIN udtSensorData sd ON sd.ID = ss.SensorDataID
		INNER JOIN ffMaterialUnitDetail ud ON ud.Reserved_02 = sd.LotCode
		INNER JOIN ffMaterialUnit mu ON mu.ID = ud.MaterialUnitID
	WHERE sn.Value = '0000190506022004'

	SELECT --TOP 10	
					ss.Serial 'Sensor Serial Number',
					mu.SerialNumber 'Baan SKID',
					ud.Reserved_02 'Sensor Lot Number',
					ud.Reserved_13 'Open Bag Time'				 
	FROM --ffserialnumber sn 
		--INNER JOIN 
		udtSensorSerials ss --ON ss.Serial = sn.Value
		INNER JOIN udtSensorData sd ON sd.ID = ss.SensorDataID
		INNER JOIN ffMaterialUnitDetail ud ON ud.Reserved_02 = sd.LotCode
		INNER JOIN ffMaterialUnit mu ON mu.ID = ud.MaterialUnitID
	WHERE mu.SerialNumber  = 'SK00232' --ss.Serial = '0000190506022004'


	SELECT 	ss.Serial 'Sensor Serial Number',
			mu.SerialNumber 'Baan SKID',
			ud.Reserved_02 'Sensor Lot Number',
			ud.Reserved_13 'Open Bag Time'		
	FROM	ffserialnumber sn 
		INNER JOIN udtSensorSerials ss ON ss.Serial = sn.Value
		INNER JOIN udtSensorData sd ON sd.ID = ss.SensorDataID
		INNER JOIN ffMaterialUnitDetail ud ON ud.Reserved_02 = sd.LotCode
		INNER JOIN ffMaterialUnit mu ON mu.ID = ud.MaterialUnitID
	WHERE sd.LotCode = 'LOT_TD0005_SEN1_1'

	

	INSERT INTO ffMaterialUnit (SerialNumber,PartID,StatusID,MaterialTypeID,StationID,
	EmployeeID,LotCode,DateCode,TraceCode,MPN,VendorID,Quantity,BalanceQty,LooperCount,
	CreationTime,FinishTime,LineID,LastUpdate,ProcessNameID)
	SELECT 'SK10246',mu.PartID,mu.StatusID,mu.MaterialTypeID,mu.StationID,
	mu.EmployeeID,mu.LotCode,mu.DateCode,mu.TraceCode,mu.MPN,mu.VendorID,mu.Quantity,mu.BalanceQty,mu.LooperCount,
	mu.CreationTime,mu.FinishTime,mu.LineID,mu.LastUpdate,mu.ProcessNameID --p.*, mud.reserved_13 
	FROM ffPart p
		INNER JOIN ffMaterialUnit mu ON mu.PartID = p.ID
		INNER JOIN ffMaterialUnitDetail mud ON mud.MaterialUnitID = mu.ID
	WHERE mu.SerialNumber = 'SK00246'


	INSERT INTO ffMaterialUnitDetail(MaterialUnitID,LooperCount)
	SELECT ID,LooperCount FROM ffMaterialUnit WHERE SerialNumber = 'SK10246'


	SELECT * 
	FROM ffPart p

	SELECT * 
	FROM ffPart p
		INNER JOIN ffMaterialUnit mu ON mu.PartID = p.ID
		INNER JOIN ffMaterialUnitDetail mud ON mud.MaterialUnitID = mu.ID
	WHERE mu.SerialNumber = 'SK10246'
	--SK00233

	SELECT *
	FROM	ffserialnumber sn 
		INNER JOIN udtSensorSerials ss ON ss.Serial = sn.Value
		INNER JOIN udtSensorData sd ON sd.ID = ss.SensorDataID
		RIGHT JOIN ffMaterialUnitDetail ud ON ud.Reserved_02 = sd.LotCode
		RIGHT JOIN ffMaterialUnit mu ON mu.ID = ud.MaterialUnitID
	WHERE ud.Reserved_13 IS NULL AND ss.ID IS NULL

	SELECT * FROM ffPart WHERE description LIKE '%SENSORS, H/V%'




	--Sensor Serial Number (Container Serial Number from Sensor Purchased Component)

	SELECT * FROM udtSensorSerials ss
		INNER JOIN ffSerialNumber sn ON sn.Value = ss.Serial

		
		SELECT	DISTINCT po.ProductionOrderNumber,
				sn.Value 'ApplicatorSN',
				parent.PartNumber ParentPart,
				parent.Revision ParentRev,
				p.PartNumber childPart,
				p.Revision childRev,
				CASE WHEN u.ID IS NULL THEN 'N' ELSE CAST(u.ID AS VARCHAR) END AS 'IsPuck'
				--u.ID
		FROM ffEBOM eb
			INNER JOIN ffProductionOrder po ON eb.ProductionOrderID = po.ID
			INNER JOIN ffPart p ON p.ID = eb.PartID
			INNER JOIN ffPart parent ON parent.ID = po.PartID
			INNER JOIN ffUnit app ON app.ProductionOrderID = po.ID
			INNER JOIN ffSerialNumber sn ON sn.UnitID = app.ID
			--LEFT JOIN ffUnit u ON u.PartID = p.ID
		WHERE po.ProductionOrderNumber = 'A40000038' -- sn.Value = 'P1619003F'

		SELECT * 
			FROM ffUnit u 
				INNER JOIN ffSerialNumber sn ON sn.UnitID = u.ID
				INNER JOIN ffProductionOrder po ON po.id = u.ProductionOrderID
		WHERE po.ProductionOrderNumber = 'A40000038'

		--P1619003H
		SELECT * FROM ffPackage ORDER BY ID DESC


		SELECT --* 
			p.PartNumber AppPN,
			sn.Value AppSN
		FROM ffSerialNumber sn 
			INNER JOIN ffUnit u ON u.ID = sn.UnitID
			INNER JOIN ffPart p ON p.ID = u.PartID
		WHERE sn.Value = 'P1619003H'

		SELECT * FROM ffPart WHERE Description LIKE '%kit%'

		SELECT * FROM luUnitComponentType

		SELECT * FROM luUnitComponentStatus

		SELECT * 
			FROM ffPart p
			INNER JOIN ffUnit u ON u.PartID = p.ID 
			INNER JOIN ffSerialNumber sn ON sn.UnitID = u.ID
		WHERE p.PartNumber LIKE '%-MAN' AND p.Description LIKE '%CONTAINER%'

		SELECT * FROM luPartDetailDef

		SELECT * FROM ffPartDetail pd WHERE pd.Content LIKE '%PRT71538-01F%'

		SELECT * FROM luProductionOrderDetailDef

		SELECT * FROM ffProductionOrderDetail 

		SELECT	DISTINCT
				Kpsn.Value SensorKitSN				
				,CONVERT(VARCHAR, kpu.Creationtime,101) AS 'Kit Pack Manufacture Date'
				,APPsn.Value ApplicatorSN
				--,Appp.PartNumber
				,CONVERT(VARCHAR, Appu.Creationtime,101) AS 'Applicator Manufacture Date'
				,Consn.Value SensorContainerSN
				--,Conp.PartNumber				
				,CONVERT(VARCHAR, Conu.Creationtime,101) AS 'Container Manufacture Date'--CAST(YEAR(KPu.CreationTime) AS VARCHAR) + '-' + LEFT(CAST(MONTH(KPu.CreationTime) AS VARCHAR(2)),'00') + '-' + LEFT(CAST(DAY(KPu.CreationTime) AS VARCHAR(2)),'00')
				,Conpo.ProductionOrderNumber 'Sensor ContainerLot#'
				,'NONE' 'JTAG PASS DATE'
				,SUBSTRING(Kpp.PartNumber,CHARINDEX('-',kpp.PartNumber)+1,LEN(kpp.PartNumber)) 'Part/SKU Build#'
				--,kppod.Content 'Sensor Kit Expiry Date'
				,CONVERT(VARCHAR(50),DATEADD(m,12,GETDATE()),101) 'Sensor Kit Expiry Date'
				,CASE WHEN (SELECT 1 FROM ffTest t WHERE t.unitID = kpu.ID AND t.LooperCount = kpu.LooperCount AND t.IsPass = 0 ) IS NOT NULL 
					THEN 'FAIL' ELSE 'PASS' END 'Results of Testing (Pass / Fail)'
			FROM ffSerialNumber KPsn
				INNER JOIN ffUnit KPu ON KPu.ID = KPsn.UnitID
				INNER JOIN ffPart KPp ON KPp.ID = KPu.PartID
				--INNER JOIN ffProductionOrder kpPO ON kpPO.ID = kpu.ProductionOrderID
				--INNER JOIN ffProductionOrderDetail kpPOd ON  kpPOd.ProductionOrderID = kpPO.ID
				--INNER JOIN luProductionOrderDetailDef kpPOdd ON kpPOdd.ID = kpPOd.ProductionOrderDetailDefID AND kpPOdd.Description = 'ExpirationDate'
				INNER JOIN ffUnitComponent KPuc ON KPuc.UnitID = KPsn.UnitID
				INNER JOIN ffUnit APPu ON Appu.ID = KPuc.ChildUnitID
				INNER JOIN ffSerialNumber APPsn ON Appsn.UnitID = Appu.ID
				INNER JOIN ffPart Appp ON Appp.ID = APPu.PartID AND appp.PartNumber = 'THRL-PRT23199-750A-MAN'
				INNER JOIN ffUnitComponent ConUC ON ConUC.UnitID = KPu.ID				
				INNER JOIN ffUnit Conu ON Conu.ID = ConUC.ChildUnitID
				INNER JOIN ffProductionOrder Conpo ON Conpo.ID = Conu.ProductionOrderID
				INNER JOIN ffSerialNumber Consn ON Conu.ID = Consn.UnitID
				INNER JOIN ffPart Conp ON Conp.ID = Conu.PartID AND Conp.PartNumber = 'THRL-PRT23200-750-MAN'
		WHERE KPsn.Value = 'KP1619003H'


		INSERT INTO ffUnitComponent(UnitID,
									UnitComponentTypeID,
									ChildUnitID,
									ChildSerialNumber,
									ChildPartID,
									StatusID)
		SELECT ku.ID,1,appu.ID,Appsn.Value,appp.ID,0
		--UPDATE sn
			--SET PartID = 2930
			--SET value = 'KP1619003H'
			FROM ffUnit Ku
			INNER JOIN ffSerialNumber Ksn ON Ksn.UnitID = Ku.ID
			INNER JOIN ffPart Kp ON Kp.ID = Ku.PartID,
			ffSerialNumber Appsn 
			INNER JOIN ffUnit Appu ON Appu.ID = Appsn.UnitID
			INNER JOIN ffPart Appp ON Appp.ID = Appu.PartID
		WHERE Appsn.Value = 'P1619003H' AND ksn.Value = 'KP1619003H'



		INSERT INTO ffUnitComponent(UnitID,
									UnitComponentTypeID,
									ChildUnitID,
									ChildSerialNumber,
									ChildPartID,
									StatusID)
		SELECT ku.ID,1,Conu.ID,Consn.Value,COnp.ID,0
		--UPDATE sn
			--SET PartID = 2930
			--SET value = 'KP1619003H'
			FROM ffUnit Ku
			INNER JOIN ffSerialNumber Ksn ON Ksn.UnitID = Ku.ID
			INNER JOIN ffPart Kp ON Kp.ID = Ku.PartID,
			ffSerialNumber Consn 
			INNER JOIN ffUnit Conu ON Conu.ID = Consn.UnitID
			INNER JOIN ffPart Conp ON Conp.ID = Conu.PartID
		WHERE Consn.Value = 'LOT170419000000401' AND ksn.Value = 'KP1619003H'


		SELECT sn.* FROM ffProductionOrder po 
			INNER JOIN ffunit u ON u.ProductionOrderID = po.ID
			INNER JOIN ffSerialNumber sn ON sn.UnitID = u.ID
		WHERE po.ProductionOrderNumber = 'A40000038'

		SELECT * FROM luSerialNumberType





		select u.PartID,u.ProductionOrderID,
			[Senso_ Kit_Serial_Number_PUID] =p.PartNumber,
			[Sensor_Container_Serial_Number_SUID] = container.Serial,
			[Applicator_Serial_Number_AUID] = sn.[Value]
		FROM ffUnit u JOIN ffSerialNumber sn ON
			sn.UnitID = u.ID JOIN udtSensorSerials container ON
			container.Serial = sn.Value JOIN ffPart p on
			p.id = u.PartID
		WHERE u.id = sn.UnitID
		and p.PartNumber ='THRL1-PRT23275-750'



	SELECT * FROM ffseria