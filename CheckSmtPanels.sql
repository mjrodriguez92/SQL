declare @PanelSN VARCHAR (50)
declare @IntRequestID BIGINT

set @PanelSN = 'P-L1B11910079000044800011600'

SET @IntRequestID =
(select TOP 1 spi.IntRequest_ID
   from DS_FT_SPITest spi
   join DS_FT_Unit u on spi.Unit_Id = u.Unit_Id and u.SerialNumber like (substring(@PanelSN, 3, 25) + '%')
  where spi.TestResult = 0 )--[ 0 = Pass | 1 = FAIL ]

-- Retrieve the SPI test records for the units within the PanelSN given
select spi.* 
  from DS_FT_SPITest spi
  join DS_FT_Unit u on spi.Unit_Id = u.Unit_Id and u.SerialNumber LIKE (SUBSTRING(@PanelSN, 3, 25) + '%')

-- Retrieve the Error Detail (if any) for the units within the PanelSN given.
select urd.* , u.SerialNumber
  from Req_UnitErrorDetail urd
  join DS_FT_Unit u ON urd.Unit_Id = u.Unit_Id
 where urd.IntRequest_Id = @IntRequestID

/*
SPI
P-L1B11910079000044800011600
P-L1B11910079000044800011610
P-L1B11910079000044800011570

AOI
P-L1B11910079000044800011600
P-L1B11910079000044800011610
P-L1B11910079000044800011570

FTS
P-L1B11910079000044800011600
P-L1B11910079000044800011610
P-L1B11910079000044800011570
P-L1B11910079000044800011150
P-L1B11910079000044800008690

*/

-- Retrieve the list of test results received in MDS for the PanelSN given
select * 
  from Log_InFileProcess
 where [FileName] like '%P-L1B11910079000044800008690%' --+ @PanelSN + '%'

/*
SPI-L1_P-L1B11910079000044800011600.xml
SPI-L1_P-L1B11910079000044800011610.xml
SPI-L1_P-L1B11910079000044800011570.xml

AOI-L1_P-L1B11910079000044800011600.xml
AOI-L1_P-L1B11910079000044800011610.xml
AOI-L1_P-L1B11910079000044800011570.xml

ADC22175FTS11_P-L1B11910079000044800011600_10072019_121154.xml
ADC22175FTS12_P-L1B11910079000044800011610_10072019_121302.xml
ADC22175FTS12_P-L1B11910079000044800011570_10072019_121836.xml
ADC22175FTS11_P-L1B11910079000044800011150_10072019_115540.xml
ADC22175FTS12_P-L1B11910079000044800008690_10072019_104634.xml
 */


