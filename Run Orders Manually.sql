/* Run Orders Manually */

begin tran

declare @request_xml [nvarchar](max),
	@signal_xml [nvarchar](max),
	@signal_xml_def [nvarchar](max),
	@error_code [bigint],
	@error_message_xml [nvarchar](max)

	set @request_xml = '<flxint>
  <app>
    <comp>768</comp>
    <signal>ORDERBOOK</signal>
    <sigref>RE0060725</sigref>
    <date>20190914</date>
    <time>060844</time>
    <id>BAAN_FF_LIBRE</id>
    <revision>008</revision>
    <data>
      <rec>
        <rpos>1</rpos>
        <change>NEW</change>
        <revision>000</revision>
        <order>
          <type>SFC</type>
          <orno>C50000030</orno>
          <pono>0</pono>
          <cpo />
          <seri>C50</seri>
          <project />
          <item>THRL-PRT23200-750-MAN</item>
          <citm />
          <sfc_type>BTS</sfc_type>
          <revi>D</revi>
          <sel_code>COM</sel_code>
          <family>Container Manual Pack</family>
          <qty>51000</qty>
          <del_qty>0</del_qty>
          <rej_qty>0</rej_qty>
          <uom>EA</uom>
          <weight>0</weight>
          <weight_unit />
          <coo />
          <com_code />
          <clot />
          <prio>999</prio>
          <wh>768089</wh>
          <bonded>N</bonded>
          <cdel_date>20190902</cdel_date>
          <cdel_time>115400</cdel_time>
          <cdel_date_iso>2019-09-02T11:54:00-05:00</cdel_date_iso>
          <prod_date>20190901</prod_date>
          <prod_time>223859</prod_time>
          <prod_date_iso>2019-09-01T22:38:59-05:00</prod_date_iso>
          <eff_date>20190901</eff_date>
          <eff_time>223859</eff_time>
          <eff_date_iso>2019-09-01T22:38:59-05:00</eff_date_iso>
          <target>4320</target>
          <line>F76806</line>
          <status>Released</status>
          <apdt_date_iso />
          <cmdt_date_iso />
          <cldt_date_iso />
          <skit_nr />
          <pick_stat>N</pick_stat>
          <so_orno />
          <so_pono>0</so_pono>
          <attributes>
            <attribute>
              <attrno>9</attrno>
              <attrseq>1</attrseq>
              <attrname />
              <attritem>THRL-PRT23200-750-MAN</attritem>
              <attrval>20L768089</attrval>
            </attribute>
            <attribute>
              <attrno>20</attrno>
              <attrseq>1</attrseq>
              <attrname>PO</attrname>
              <attritem>THRL-PRT23200-750-MAN</attritem>
              <attrval />
            </attribute>
            <attribute>
              <attrno>21</attrno>
              <attrseq>1</attrseq>
              <attrname>Resin</attrname>
              <attritem>THRL-PRT23200-750-MAN</attritem>
              <attrval>         FBA-CSD-ASM23200-500</attrval>
            </attribute>
          </attributes>
          <est_mats>
            <est_mat>
              <pos>10</pos>
              <project />
              <item>FBA-CSD-ASM23200-500</item>
              <citm />
              <revi>D-1</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768010</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>N</backflush>
              <rpl_method />
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>20</pos>
              <project />
              <item>FBA-CSD-DOC23200-750</item>
              <citm />
              <revi>C</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768010</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>N</backflush>
              <rpl_method />
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>30</pos>
              <project />
              <item>FBA-CSD-DOC37708-02C</item>
              <citm />
              <revi>A-1</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768010</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>N</backflush>
              <rpl_method />
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>40</pos>
              <project />
              <item>THRLC-PRT24681-001</item>
              <citm />
              <revi>B-1</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>50</pos>
              <project />
              <item>THRL-PRT24681-001</item>
              <citm />
              <revi>B-1</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>60</pos>
              <project />
              <item>THRL-PRT24683</item>
              <citm />
              <revi>C-3</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0.0021</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>70</pos>
              <project />
              <item>THRL-PRT25386-01H</item>
              <citm />
              <revi>D-2</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>80</pos>
              <project />
              <item>THRL-PRT26341-01H</item>
              <citm />
              <revi>F</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>90</pos>
              <project />
              <item>THRL-PRT26800-01H</item>
              <citm />
              <revi>B</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>100</pos>
              <project />
              <item>THRLC-PRT23626-109</item>
              <citm />
              <revi>C</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>ORDER BASED</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>110</pos>
              <project />
              <item>THRL-PRT28309-01H</item>
              <citm />
              <revi>B</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>120</pos>
              <project />
              <item>THRL-PRT23563-50H</item>
              <citm />
              <revi>B</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>130</pos>
              <project />
              <item>THRLC-PRT25385-01H</item>
              <citm />
              <revi>C</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>140</pos>
              <project />
              <item>THRL-PRT25385-01H</item>
              <citm />
              <revi>C-1</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>150</pos>
              <project />
              <item>THRL-PRT25385-50H</item>
              <citm />
              <revi>A-1</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>160</pos>
              <project />
              <item>THRLC-PRT23255</item>
              <citm />
              <revi>E-2</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>0</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
            <est_mat>
              <pos>170</pos>
              <project />
              <item>THRL-PRT23255</item>
              <citm />
              <revi>E-3</revi>
              <weight>0</weight>
              <weight_unit />
              <coo />
              <com_code />
              <opno>10</opno>
              <qty>1</qty>
              <uom>EA</uom>
              <wh>768026</wh>
              <bonded>N</bonded>
              <references>
                <prel />
                <e_owner />
              </references>
              <backflush>Y</backflush>
              <rpl_method>MANUAL</rpl_method>
              <point_of_usage />
              <mss_alt_ref />
            </est_mat>
          </est_mats>
          <routing>
            <plid>13809</plid>
            <opro>001</opro>
            <opro_desc>001.AAL04</opro_desc>
            <routing_line>
              <opno>10</opno>
              <tano>150</tano>
              <tano_desc>Container</tano_desc>
              <cwoc>F76806</cwoc>
              <cwoc_desc>Libre Container</cwoc_desc>
              <mcno>AAL04</mcno>
              <mcno_desc>Container Line 1</mcno_desc>
              <start_date>20190902</start_date>
              <start_time>000000</start_time>
              <start_date_iso>2019-09-02T00:00:00-05:00</start_date_iso>
              <finish_date>20190902</finish_date>
              <finish_time>115400</finish_time>
              <finish_date_iso>2019-09-02T11:54:00-05:00</finish_date_iso>
              <project />
              <item>THRL-PRT23200-750-MAN</item>
              <citm />
              <next_opno>0</next_opno>
              <setup_date>20190902</setup_date>
              <setup_time>000000</setup_time>
              <setup_date_iso>2019-09-02T00:00:00-05:00</setup_date_iso>
              <run_date>20190902</run_date>
              <run_time>115400</run_time>
              <run_date_iso>2019-09-02T11:54:00-05:00</run_date_iso>
              <avg_setup_time>0</avg_setup_time>
              <avg_setup_time_uom>MINUTE</avg_setup_time_uom>
              <cycle_time>0.014</cycle_time>
              <cycle_time_uom>MINUTE</cycle_time_uom>
              <subcon />
              <subcon_name />
              <fixed_duration>N</fixed_duration>
              <transfer_delay>0</transfer_delay>
              <queue_time>0</queue_time>
              <delay_unit>DAYS</delay_unit>
              <opr_stat>PLANNED</opr_stat>
              <sltm>0</sltm>
              <sltm_uom>DAYS</sltm_uom>
              <prte>4320</prte>
              <prte_uom>HOURS</prte_uom>
              <fxsu>0</fxsu>
              <fxsu_uom>MINUTE</fxsu_uom>
              <runi>1</runi>
              <runi_uom>ea</runi_uom>
              <mcoc>1</mcoc>
              <most>0</most>
              <mopr>1</mopr>
              <maho>11.9</maho>
              <mcho>11.9</mcho>
              <trf_lot>Y</trf_lot>
              <trf_lot_qty>0</trf_lot_qty>
              <prtm>11.9</prtm>
              <prtm_uom>HOURS</prtm_uom>
              <sptm>0</sptm>
              <sptm_uom>HOURS</sptm_uom>
              <retm>11.9</retm>
              <retm_uom>HOURS</retm_uom>
              <fxpd>N</fxpd>
              <qty_pl_in>51000</qty_pl_in>
              <qty_pl_out>51000</qty_pl_out>
              <qty_comp>0</qty_comp>
              <qty_reject>0</qty_reject>
              <qty_extra>0</qty_extra>
              <qty_tb_insp>0</qty_tb_insp>
              <qty_to_bf>0</qty_to_bf>
              <qty_bfd>0</qty_bfd>
              <backflushing>N</backflushing>
              <ydtp>DISCRETE</ydtp>
              <yldp>100</yldp>
              <scpq>0</scpq>
              <phsp>0</phsp>
              <phsp_uom>ea</phsp_uom>
              <copo>N</copo>
              <blcd />
              <ploc />
              <cmdt />
              <cmdt_time />
              <cmdt_date_iso />
              <subr>0</subr>
              <qsbc>0</qsbc>
              <qsbc_uom>ea</qsbc_uom>
              <nnts>0</nnts>
              <pnpt>N</pnpt>
            </routing_line>
          </routing>
          <references>
            <prel />
            <e_owner />
          </references>
        </order>
      </rec>
    </data>
  </app>
</flxint>'
	
	-- =============================================
	-- VARRIABLE DECLARATION
	-- =============================================
	DECLARE @ErrorNumber AS INT
	DECLARE @ErrorSeverity AS INT
	DECLARE @ErrorState AS INT
	DECLARE @ErrorLine AS INT
	DECLARE @ErrorMessage AS NVARCHAR(MAX)--07th FEB 2017, Sean Zhang,Change VARCHAR(MAX) to NVARCHAR(MAX)
	DECLARE @RetErrorMessage AS VARCHAR(MAX)
	DECLARE @curDatetime AS DATETIME
	DECLARE @SPName AS VARCHAR(50)
	DECLARE @SQL AS VARCHAR(MAX) 
	DECLARE @ServerName AS VARCHAR(MAX)
	DECLARE @DBName AS VARCHAR(MAX)
	
	DECLARE @RetErrorLogID AS BIGINT
	DECLARE @SignalTypeName AS VARCHAR(MAX)
	DECLARE @EmployeeName AS VARCHAR(MAX)

	DECLARE @SignalXml XML
	DECLARE @SignalType NVARCHAR(20)
	DECLARE @SignalRef NVARCHAR(200)
	DECLARE @TosignalProcessingRespSPName  AS VARCHAR(MAX)
	DECLARE @TosignalTypeID AS INT
	DECLARE @TosignalReqAck AS BIT
	DECLARE @NewStatusID AS INT
	DECLARE @SignalTypeID AS INT
	DECLARE @ProcSP AS VARCHAR(MAX)
	DECLARE @responseXml AS XML
	
	DECLARE @v_ID INT
	DECLARE @v_SignalTypeID INT
	DECLARE @v_Content XML
	DECLARE @v_StatusID INT
	DECLARE @v_SignalID BIGINT
	DECLARE @v_FileName VARCHAR(200)
	DECLARE @v_UpdateBy VARCHAR(50)

	DECLARE @SignalRespConfigType AS VARCHAR(MAX)
	DECLARE @SignalRespConfigTypeID AS INT
	DECLARE @smtp NVARCHAR(100)
	DECLARE @From NVARCHAR(500)
	DECLARE @To NVARCHAR(1000)
	DECLARE @Subject NVARCHAR(1000)
	DECLARE @Body NVARCHAR(max)
	DECLARE @hrOutput INT
	DECLARE @TranCounter INT
	DECLARE @CompletedFCSSignalStatusID AS INT
	DECLARE @ErrorFCSSignalStatusID AS INT
	DECLARE @NewFCSSignalStatusID AS INT
	DECLARE @SignalID AS BIGINT
	DECLARE @IsReady AS BIT
	DECLARE @ErrExcludeFCSSignalStatus INT  -- TO Indicate the Error happen is from importProxy. Will not update the FCSSignal status.
	DECLARE @MailErrorMessage AS VARCHAR(200) --2012009130900_01
	DECLARE @output AS VARCHAR(4000) --2012009130900_01
	
	--20131108
	DECLARE @StartTime DATETIME
	DECLARE @EndTime DATETIME
	DECLARE @TraceExecutionLog VARCHAR(3)
	SET @StartTime = GETDATE()
BEGIN
	
	SET NOCOUNT ON;
	SET ARITHABORT ON;
	 SET @TranCounter = @@TRANCOUNT
	 IF @TranCounter > 0
			SAVE TRANSACTION fbipImportProxy
	 ELSE 
			BEGIN TRAN fbipImportProxy	
			
	BEGIN TRY
		PRINT 'START PROCESS TRY LOOP'
		-- =============================================
		-- PRE-SET VARIABLE
		-- =============================================
		SET @SPName = '[fbipImportProxy]'
		SELECT @curDatetime = GETDATE()
		SET @SQL = ''
		SET @IsReady = 1 -- DEFAULT TO 1 TO INDICATE THAT IS READY TO PROCESS
		SET @EmployeeName = 'admin'
		SET @signalXml = convert(XML, @request_xml)
		SET @signalType = @signalXml.value('(/flxint/app/signal/text())[1]', 'varchar(20)')		
		SET @SignalRef =  @signalXml.value('(/flxint/app/sigref/node())[1]','varchar(max)')
		SELECT @SignalTypeID = ID, @SignalTypeName = Name FROM fbitLuSignalType	WHERE Name = @signalType --20131108
		SELECT TOP 1 @NewFCSSignalStatusID = StatusID FROM fbitLuStatus WHERE TableName = 'fbitSignal' AND ColumnName = 'StatusID' AND StatusName = 'New'
		SELECT TOP 1 @CompletedFCSSignalStatusID = StatusID FROM fbitLuStatus WHERE TableName = 'fbitSignal' AND ColumnName = 'StatusID' AND StatusName = 'Completed'
		SELECT TOP 1 @ErrorFCSSignalStatusID = StatusID FROM fbitLuStatus WHERE TableName = 'fbitSignal' AND ColumnName = 'StatusID' AND StatusName = 'Error'
		SET @ErrExcludeFCSSignalStatus = 0	
		SELECT @ServerName = @@SERVERNAME
		SELECT @DBName = DB_NAME()			
		
		-- =============================================
		-- PRE-REQUISITE CHECKING
		-- =============================================
		
		IF @signalType is null 
			RAISERROR('Cannot determine signal type.', 16, 1)
		
		--20131108
		SELECT @TraceExecutionLog = Value FROM fbitConfig
		WHERE TypeID = (SELECT ID FROM fbitLuConfigType WHERE Name = 'Global')
		AND Name = 'TraceExecutionLog'
										
				IF @signalType = '#RESP#'
					BEGIN
						
						PRINT 'PROCESS #RESP# SIGNAL'
												
						-- =============================================
						-- TASKs :-INSERT THE TO fbitSignal AS NEW
						-- =============================================
					   /*2012006121000_04*/
					   SET @SignalID = NULL
					   EXECUTE [fbipSaveSignal]  @EmployeeName,NULL ,@SignalRef,@SignalTypeID,@NewFCSSignalStatusID,@CurDatetime,0,@SignalID OUTPUT
						
						
	   					IF @TranCounter = 0
							COMMIT TRAN fbipImportProxy 
								
						 SET @TranCounter = @@TRANCOUNT
						 IF @TranCounter > 0
								SAVE TRANSACTION fbipImportProxy
						 ELSE 
								BEGIN TRAN fbipImportProxy	
						/*END 2012006121000_04*/
		
						-- =============================================
						-- VARRIABLE DECLARATION
						-- =============================================
						DECLARE @TosignalType NVARCHAR(200)
						DECLARE @Tosigref NVARCHAR(200)
						DECLARE @RespStatus NVARCHAR(200)
						
						-- =============================================
						-- PRE-SET VARIABLE
						-- =============================================
						SET @RespStatus = @signalXml.value('(/flxint/app/status/node())[1]','varchar(max)') --2012006121000_01
						SET @TosignalType =  @signalXml.value('(/flxint/app/tosignal/node())[1]','varchar(max)')
						SET @Tosigref =  @signalXml.value('(/flxint/app/tosigref/node())[1]','varchar(max)')
						
						IF @signalXml.exist('(/flxint/app/data/rec/status[text()="NACK"])') =1
							BEGIN
								SET @RespStatus ='NACK'
							END
						ELSE
							BEGIN
								IF ISNULL(@RespStatus,'') =''  --2012006121000_01
								BEGIN
									SET @RespStatus = @signalXml.value('(/flxint/app/data/rec/status/node())[1]','varchar(max)')
								END
							END	
						
						
						--2013043014120_01--Yean Hui.Start
						  SELECT TOP 1 @TosignalProcessingRespSPName = sigtype.ProcessingRespSPName ,
									 @TosignalTypeID = sigtype.ID,
									 @TosignalReqAck = sigtype.ReqAck
						  FROM fbitLuSignalType AS sigtype (NOLOCK)
						  INNER JOIN fbitSignal AS sig ON sigtype.id=sig.SignalTypeID AND sig.SignalRefNumber = @Tosigref
						  INNER JOIN fbitLuSignalDirection sigDir ON sigDir.Name = 'Outgoing' AND sigDir.id=sigtype.SignalDirectionID 
						
						/*
						SELECT TOP 1 @TosignalProcessingRespSPName = sig.ProcessingRespSPName ,
									 @TosignalTypeID = sig.ID,
									 @TosignalReqAck = sig.ReqAck
						FROM fbitLuSignalType AS sig (NOLOCK)
						WHERE Name = @TosignalType
						*/
						--2013043014120_01--Yean Hui.End
											
						-- =============================================
						-- PRE-REQUISITE CHECKING
						-- =============================================
						IF (ISNULL(@TosignalType, '') = '')
						RAISERROR ( 'Wrong XML. tosignal missing', 16, 1)
					
						IF (ISNULL(@Tosigref, '') = '')
							RAISERROR ( 'Wrong XML. tosigref missing', 16, 1)
					
						IF (ISNULL(@RespStatus, '') = '')
							RAISERROR ( 'Wrong XML. status missing', 16, 1)
						
						IF NOT EXISTS (SELECT 1 FROM fbitSignal WHERE SignalRefNumber = @Tosigref AND SignalTypeID =@TosignalTypeID )
						BEGIN
							RAISERROR('Cannot find signal related to received response.', 16, 1)
						END
						
						-- =============================================
						-- TASKs :-Run configured stored procedure to do signal type specific RESP processing
						-- =============================================	
						IF @TranCounter = 0
							COMMIT TRAN fbipImportProxy 
				
						print @ToSignalProcessingRespSPName
						
						IF ISNULL(@ToSignalProcessingRespSPName, '') <> '' --2012009041300_01
						--IF @ToSignalProcessingRespSPName IS NOT NULL --2012009041300_01
						BEGIN
							PRINT 'EXECUTE ' +@ToSignalProcessingRespSPName
							EXEC  @ToSignalProcessingRespSPName @signalXml, 0, @error_code out
							
						END
						ELSE
						BEGIN
							PRINT 'EXECUTE [udpfbipRESPDefault] ' 
							EXEC udpfbipRESPDefault @signalXml, 0, @error_code out
						END
						
						 SET @TranCounter = @@TRANCOUNT
						 IF @TranCounter > 0
								SAVE TRANSACTION fbipImportProxy
						 ELSE 
								BEGIN TRAN fbipImportProxy	
			
							-- =============================================
							-- TRIGGER EMAIL IF THE STATUS RETURN IS NACK
							-- =============================================
							IF @RespStatus='NACK' 
							BEGIN
								SET @SignalRespConfigTypeID = NULL
								SET @SignalRespConfigType ='Signal_RESP'
								SELECT  @SignalRespConfigTypeID = ID FROM fbitLuConfigType WHERE Name = @SignalRespConfigType
								SELECT @smtp = value FROM fbitConfig WHERE Name = '#RESP#_smtp'  and TypeID = @SignalRespConfigTypeID
								SELECT @From = value FROM fbitConfig WHERE Name = '#RESP#_EmailFrom' and TypeID = @SignalRespConfigTypeID
								--2013019031000_01
								--SELECT @To = Value FROM fbitConfig context WHERE Name =  '#RESP#_EmailTo' and TypeID = @SignalRespConfigTypeID
								SELECT @To = EmailTo FROM [fbifGetEmailTo] (@SignalRespConfigTypeID)		
								--2013019031000_01	
								SET @Subject = '#RESP# Notification'
								--2012009041300_01
								SET @Body ='
								<html>
									<head>
										<style type="text/css">
											h2 {color:red}
											h3 {color:blue}
											h4 {color:black}
											h5 {
											    color:black;
												font-size:14px;
												font-weight:normal;
											    }												
										</style>
									</head>
									<body>
										<H3 align="left">Server:			' + IsNull(@ServerName,'') +'</H3>
										<H3 align="left">FF DB:				' + IsNull(@DBName,'') +'</H3>	
										<H2 align="left">#RESP# Notification</H1>
										<H3 align="left">Status:			' + IsNull(@RespStatus,'') +'</H3>
										<H3 align="left">To Signal:			' + IsNull(@TosignalType,'') +'</H3>
										<H3 align="left">To Signal Ref No.:	' + CAST (IsNull(@Tosigref,'') as nvarchar(100)) + '</H3>
										<H2 align="left">Message:			' + Isnull('Error - Refer to XML Content for detail','') + '</H2>
										<H4 align="left">=====================================================<br />
										                 XML Content<br />		
														 =====================================================</H4>
										<H5 align="left">'+ REPLACE(dbo.fbifEncodeXML (CAST(ISNULL(@signalXml, '') AS NVARCHAR(MAX))), '&lt;rec&gt;', '<br />&lt;rec&gt;') +'</H5>	
										<H4 align="left">=====================================================</H4>												
										<H4 align="left"></H4>
										<H4 align="left">Send Time:			' + cast(getdate() as nvarchar(100) ) + '</H4>
									</body>
									Auto-sent from #RESP# Signal!!!
								</html>'
								--2012009041300_01

								-- 2013110810200_01
								IF (ISNULL(@smtp,'') <> '' and ISNULL(@To,'') <> '' AND ISNULL(@From,'') <> '')
								BEGIN
									EXECUTE [fbipSMTPSendEmail]
											@From
											,@To
											,@Subject
											,@Body
											,@smtp
											,null--@FileName
											,@hrOutput OUTPUT
											,@output OUTPUT
											
									/* 2012009130900_01 */
									IF @hrOutput <> 0
									BEGIN									
										SET @MailErrorMessage = @SPName + ' Failed to send the email, ' + @output
										EXEC fbipSaveErrorLog @SPName , @SignalID, @signalType,@ErrorLine,'ERROR',@MailErrorMessage,@EmployeeName,@CurDatetime, NULL, NULL, @RetErrorLogID OUTPUT
									END
									/* 2012009130900_01 */		
								END								
							END 	
							SET	@signal_xml  = @request_xml 
							SET @error_code = 0
							SET @error_message_xml = ''
					END
				ELSE
					BEGIN
						PRINT 'PROCESS INCOMING SIGNAL'
						-- =============================================
						-- PRE-SET VARIABLE
						-- =============================================	
						SELECT @ProcSP = ProcessingSPName FROM fbitLuSignalType WHERE ID = @SignalTypeID 
						SET @SignalID = NULL
					    SELECT @SignalID = ID FROM fbitsignal WHERE SignalRefNumber = @SignalRef AND SignalTypeID = @SignalTypeID
						-- =============================================
						-- PRE-REQUISITE CHECKING
						-- =============================================
								-- =============================================
								-- TASKs :- Check SignalRefNumber.
								-- =============================================
								IF (ISNULL(@SignalRef, '') = '') 
								BEGIN
								  SET @ErrExcludeFCSSignalStatus = 1
								  RAISERROR('%s signal do no have signal ref number.', 16, 1, @signalType)
								END
								-- =============================================
								-- TASKs :- Check if Signal SP Has Been Configured
								-- =============================================
								IF (ISNULL(@ProcSP, '') = '')  --2012006121000_02
								BEGIN
								  SET @ErrExcludeFCSSignalStatus = 1
								  RAISERROR('%s signal do not configure Processing Store Procedure.', 16, 1, @signalType)
								END
								
								-- =============================================
								-- TASKs :- SignalREF DUPLICATION CHECK
								-- =============================================
								SET @IsReady = NULL
								EXECUTE [fbipIsSignalReadyToProcess] 
								   @SignalRef
								  ,@signalTypeID
								  ,@IsReady OUTPUT
								  ,0

								IF (@IsReady = 0)
								BEGIN	
										SET @ErrExcludeFCSSignalStatus = 1
										RAISERROR('%s signal %s already processed.', 16, 1, @signalType, @SignalRef)
								END
						
						-- =============================================
						-- TASKs :-INSERT/UPDATE THE TO fbitSignal AS NEW
						-- =============================================
					   /*2012006121000_04*/
					   IF (@SignalID IS NULL)
					   BEGIN
							EXECUTE [fbipSaveSignal]  @EmployeeName,NULL ,@SignalRef,@SignalTypeID,@NewFCSSignalStatusID,@CurDatetime,0,@SignalID OUTPUT
					   END
						
	   					IF @TranCounter = 0
							COMMIT TRAN fbipImportProxy 
						
						IF @procSP IS NOT NULL
						BEGIN
							DECLARE  @retCode AS INT
							DECLARE @error_Message AS NVARCHAR(MAX)
							EXEC @retCode  = @procSP @signalXml, @responseXml OUT, @error_Message OUT
							
							IF @retCode <> 0
							BEGIN	
								PRINT @SPName + ' RETURN CODE <> 0'
								/* THis is to Ensure the rollback will be at this Stop*/
								 SET @TranCounter = @@TRANCOUNT
								 IF @TranCounter > 0
										SAVE TRANSACTION fbipImportProxy
								 ELSE 
										BEGIN TRAN fbipImportProxy	
															
								RAISERROR (@error_Message, 16,1)
							END
						END

						 SET @TranCounter = @@TRANCOUNT
						 IF @TranCounter > 0
								SAVE TRANSACTION fbipImportProxy
						 ELSE 
								BEGIN TRAN fbipImportProxy	
			
						SET	@signal_xml  = CAST(@responseXml AS NVARCHAR(MAX))
						SET @error_code = 0
						SET @error_message_xml = ''
					END
				
				-- =============================================
				-- TASKs :-UPDATE THE TO FCSSignal AS COMPLETED
				-- =============================================
				EXECUTE [fbipSaveSignal]  @EmployeeName,@SignalID ,@SignalRef,@SignalTypeID,@CompletedFCSSignalStatusID,@CurDatetime,0,@SignalID OUTPUT

				IF @TranCounter = 0
					COMMIT TRAN fbipImportProxy 

				--20131108
				IF @TraceExecutionLog = 'Y'
				BEGIN
					SET @EndTime = GETDATE()
					EXEC [fbipInsertExecutionLog] @SignalID, @SignalTypeID, @SignalTypeName, @SignalRef, @SPName, @StartTime, @EndTime 
				END
									
				print 'RETURN 0'
	END TRY
	BEGIN CATCH
				PRINT 'ERROR [fbipImportProxy]'
				IF @TranCounter = 0
					BEGIN
							IF (@@TRANCOUNT > 0 )ROLLBACK TRANSACTION
					END
				ELSE
				IF XACT_STATE() <> -1
					BEGIN
						IF (@@TRANCOUNT > 0 )ROLLBACK TRANSACTION fbipImportProxy
					END
				
			 				
				SELECT  @ErrorNumber = ERROR_NUMBER(), 
						@ErrorSeverity = ERROR_SEVERITY(), 
						@ErrorState = ERROR_STATE(), 
						@ErrorLine = ERROR_LINE(), 
						@ErrorMessage = @SPName + '[Line:'+ CAST(@ErrorLine AS VARCHAR(MAX)) + ']'+ ERROR_MESSAGE()	
					
				SET @error_message_xml = @ErrorMessage;
			
				EXEC fbipSaveErrorLog @SPName , @SignalID, @signalType,@ErrorLine,'ERROR',@ErrorMessage,@EmployeeName,@CurDatetime, NULL, NULL, @RetErrorLogID OUTPUT
				SET @error_code = @RetErrorLogID
				
				SET	@signal_xml  = CAST(ISNULL(@responseXml,'') AS NVARCHAR(MAX))
				
				-- =============================================
				-- TASKs :-UPDATE THE TO FCSSignal AS ERROR
				-- =============================================
				IF (@ErrExcludeFCSSignalStatus= 0)
				BEGIN
					IF (@SignalRef IS NOT NULL) --2012008161400_01
					BEGIN
						EXECUTE [fbipSaveSignal]  @EmployeeName,@SignalID ,@SignalRef,@SignalTypeID,@ErrorFCSSignalStatusID,@CurDatetime,0,@SignalID OUTPUT
					END
				END
				-- =============================================
				-- TRIGGER EMAIL IF TO NOTIFY
				-- =============================================
				SET @SignalRespConfigType ='Signal_RESP'
				SET @SignalRespConfigTypeID = NULL
				
				SELECT  @SignalRespConfigTypeID = ID FROM fbitLuConfigType WHERE Name = @SignalRespConfigType
				SELECT @smtp = value FROM fbitConfig WHERE Name = '#RESP#_smtp'  and TypeID = @SignalRespConfigTypeID
				SELECT @From = value FROM fbitConfig  WHERE Name = '#RESP#_EmailFrom' and TypeID = @SignalRespConfigTypeID
				--2013019031000_01
				--SELECT @To = Value FROM fbitConfig context WHERE Name =  '#RESP#_EmailTo' and TypeID = @SignalRespConfigTypeID
				SELECT @To = EmailTo FROM [fbifGetEmailTo] (@SignalRespConfigTypeID)		
				--2013019031000_01	
				SET @Subject = '#Signal Error# Notification'
				SET @Body ='
				<html>
					<head>
						<style type="text/css">
							h2 {color:red}
							h3 {color:blue}
							h4 {color:black}
						</style>
					</head>
					<body>
						<H3 align="left">Server:			' + IsNull(@ServerName,'') +'</H3>
						<H3 align="left">FF DB:				' + IsNull(@DBName,'') +'</H3>							
						<H2 align="left">#Signal Error# Notification</H1>				
						<H3 align="left">To Signal:			' + IsNull(@SignalType,'') +'</H3>
						<H3 align="left">To Signal Ref No.:	' + CAST (IsNull(@Signalref,'') as nvarchar(100)) + '</H3>
						<H2 align="left">Error Message:			' + Isnull(@ErrorMessage,'') + '</H2>
						<H4 align="left"></H4>
						<H4 align="left">Send Time:			' + cast(getdate() as nvarchar(100) ) + '</H4>
					</body>
					Auto-sent from #RESP# Signal!!!
				</html>'
				PRINT @Body
				
				-- 2013110810200_01
				IF (ISNULL(@smtp,'') <> '' and ISNULL(@To,'') <> '' AND ISNULL(@From,'') <> '')
				BEGIN
					EXECUTE [fbipSMTPSendEmail]
							@From
							,@To
							,@Subject
							,@Body
							,@smtp
							,null--@FileName
							,@hrOutput OUTPUT
							,@output OUTPUT

					/* 2012009130900_01 */
					IF @hrOutput <> 0
					BEGIN
						SET @MailErrorMessage = @SPName + ' Failed to send the email, ' + @output
						EXEC fbipSaveErrorLog @SPName , @SignalID, @signalType,@ErrorLine,'ERROR',@MailErrorMessage,@EmployeeName,@CurDatetime, NULL, NULL, @RetErrorLogID OUTPUT
					END
				END
				/* 2012009130900_01 */			

				--20131108
				IF @TraceExecutionLog = 'Y'
				BEGIN
					SET @EndTime = GETDATE()
					SET @SPName = @SPName+'-Catch'
					EXEC [fbipInsertExecutionLog] @SignalID, @SignalTypeID, @SignalTypeName, @SignalRef, @SPName, @StartTime, @EndTime 
				END
				
				print 'Return 999'
	END CATCH

END

select * from ffProductionOrder where ProductionOrderNumber = 'C50000030'

rollback tran
--commit
