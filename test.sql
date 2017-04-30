-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 21, 2017 at 11:05 AM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `test`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculate_tax`(IN v_Amount INT(11),IN v_Formula VARCHAR(255))
BEGIN
DECLARE v_Tax VARCHAR(255);
DECLARE v_Output VARCHAR(255);
DECLARE v_TaxDeductAmount VARCHAR(255);
DECLARE v_FirstTax VARCHAR(255);
DECLARE v_SecondTax VARCHAR(255);
DECLARE v_FirstOutput VARCHAR(255);
DECLARE v_SecondOutput VARCHAR(255);
DECLARE v_DeductAmount VARCHAR(255);
SELECT LENGTH(v_Formula) - LENGTH(REPLACE(v_Formula,',','')) INTO @v_CommaLenth;
IF(@v_CommaLenth = 1) THEN
	SELECT SPLIT_STRING(v_Formula,',',1) INTO @v_FirstFormula;
	SELECT SPLIT_STRING(v_Formula,',',2) INTO @v_SecondFormula;
	SELECT SPLIT_STRING(@v_FirstFormula,'=',1) INTO @v_StartAmount;
	SELECT SPLIT_STRING(@v_FirstFormula,'=',2) INTO @v_TaxAmount;
	SELECT SPLIT_STRING(@v_SecondFormula,'=',2) INTO @v_MaxAmount;
	IF (v_Amount >=@v_StartAmount && v_Amount<=@v_MaxAmount) THEN
		SET v_Tax = @v_TaxAmount*100;
		SET v_Output =  (v_Tax*v_Amount)/100;
		SET v_TaxDeductAmount = v_Amount - v_Output;
	ELSE
		SET v_Tax = @v_TaxAmount*100;
		SET v_Output =  (v_Tax*@v_MaxAmount)/100;
		SET v_TaxDeductAmount = v_Amount - v_Output;
	END IF;	
ELSEIF(@v_CommaLenth = 2) THEN
	SELECT SPLIT_STRING(v_Formula,',',1) INTO @v_FirstFormula;
	SELECT SPLIT_STRING(v_Formula,',',2) INTO @v_SecondFormula;
	SELECT SPLIT_STRING(v_Formula,',',3) INTO @v_ThirdFormula;
	SELECT SPLIT_STRING(@v_FirstFormula,'=',1) INTO @v_StartAmount;
	SELECT SPLIT_STRING(@v_FirstFormula,'=',2) INTO @v_FirstTaxAmount;
	SELECT SPLIT_STRING(@v_SecondFormula,'=',1) INTO @v_SecondAmount;
	SELECT SPLIT_STRING(@v_SecondFormula,'=',2) INTO @v_SecondTaxAmount;
	SELECT SPLIT_STRING(@v_ThirdFormula,'=',2) INTO @v_MaxAmount;
	IF (v_Amount >=@v_StartAmount && v_Amount<=@v_SecondAmount) THEN
		SET v_Tax = @v_FirstTaxAmount*100;
		SET v_Output =  (v_Tax*v_Amount)/100;
		SET v_TaxDeductAmount = v_Amount - v_Output;
	ELSEIF (v_Amount >@v_SecondAmount && v_Amount<=@v_MaxAmount) THEN
		SET v_FirstTax = @v_FirstTaxAmount*100;
		SET v_SecondTax = @v_SecondTaxAmount*100;
		SET v_FirstOutput  = (v_FirstTax*@v_SecondAmount)/100;
		SET v_DeductAmount = v_Amount-@v_SecondAmount;
		SET v_SecondOutput = (v_SecondTax*v_DeductAmount)/100;
		SET v_Tax = v_FirstOutput + v_SecondOutput; 
		SET v_Output =  v_Tax;
		SET v_TaxDeductAmount = v_Amount - v_Output;
	ELSE
		SET v_FirstTax = @v_FirstTaxAmount*100;
		SET v_SecondTax = @v_SecondTaxAmount*100;
		SET @v_MaxAmount = @v_MaxAmount-@v_SecondAmount;
		SET v_FirstOutput  = (v_FirstTax*@v_SecondAmount)/100;
		SET v_SecondOutput = (v_SecondTax*@v_MaxAmount)/100;
		SET v_Tax = v_FirstOutput + v_SecondOutput; 
		SET v_Output =  v_Tax;
		SET v_TaxDeductAmount = v_Amount - v_Output;
	END IF;
ELSE 
	SELECT SPLIT_STRING(v_Formula,'=',2) INTO @v_TaxAmount;
	SET v_Tax = @v_TaxAmount*100;
	SET v_Output =  (v_Tax*v_Amount)/100;
	SET v_TaxDeductAmount = v_Amount - v_Output;
END IF;
SELECT v_Output AS TaxAmount,v_TaxDeductAmount AS FinalAmount;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `SPLIT_STRING`(str VARCHAR(255), delim VARCHAR(12), pos INT) RETURNS varchar(255) CHARSET latin1
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(str, delim, pos),
       LENGTH(SUBSTRING_INDEX(str, delim, pos-1)) + 1),
       delim, '')$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `scrap`
--

CREATE TABLE IF NOT EXISTS `scrap` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organisasjonsnummer` varchar(255) NOT NULL,
  `foretaksnavn` varchar(255) NOT NULL,
  `organisasjonsform` varchar(255) NOT NULL,
  `forretningsadresse` varchar(255) NOT NULL,
  `kommune` varchar(255) NOT NULL,
  `postadresse` varchar(255) NOT NULL,
  `internettadresse` varchar(255) NOT NULL,
  `enhetsregisteret` varchar(255) NOT NULL,
  `stiftelsesdato` varchar(255) NOT NULL,
  `dagligleder` varchar(255) NOT NULL,
  `vedtektfestet` varchar(255) NOT NULL,
  `virksomhet` varchar(255) NOT NULL,
  `naringskode` varchar(255) NOT NULL,
  `sektorkode` varchar(255) NOT NULL,
  `opplysninger` varchar(255) NOT NULL,
  `styre` varchar(255) NOT NULL,
  `styrets` varchar(255) NOT NULL,
  `virksomheter` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `scrap`
--

INSERT INTO `scrap` (`id`, `organisasjonsnummer`, `foretaksnavn`, `organisasjonsform`, `forretningsadresse`, `kommune`, `postadresse`, `internettadresse`, `enhetsregisteret`, `stiftelsesdato`, `dagligleder`, `vedtektfestet`, `virksomhet`, `naringskode`, `sektorkode`, `opplysninger`, `styre`, `styrets`, `virksomheter`) VALUES
(10, '817 812 902', 'ZECURECODE AS', 'Aksjeselskap', 'Anton Antonsens veg 6\r\n9146 OLDERDALEN', 'K&Aring;FJORD', '-', ' www.zecurecode.com ', '30.09.2016', '08.07.2016', 'H&aring;kon Berntsen', 'Programmeringstjenester, herunder utvikling og salg av apper for&nbsp;                 smarttelefoner, samt drift og utvikling av egne og andre selskapers&nbsp;                 digitale l&oslash;sninger.&nbsp;                 ', 'Programmeringstjenester, utvikling av digitale l&oslash;sninger.&nbsp;                ', '62.010&nbsp; 	                   Programmeringstjenester', '2100 Private aksjeselskaper mv.', 'Registrert i Foretaksregisteret', '-', 'H&aring;kon Berntsen', ' Oversikt over registrerte virksomheter '),
(11, '817 812 902', 'ZECURECODE AS', 'Aksjeselskap', 'Anton Antonsens veg 6\r\n9146 OLDERDALEN', 'K&Aring;FJORD', '-', ' www.zecurecode.com ', '30.09.2016', '08.07.2016', 'H&aring;kon Berntsen', 'Programmeringstjenester, herunder utvikling og salg av apper for&nbsp;                 smarttelefoner, samt drift og utvikling av egne og andre selskapers&nbsp;                 digitale l&oslash;sninger.&nbsp;                 ', 'Programmeringstjenester, utvikling av digitale l&oslash;sninger.&nbsp;                ', '62.010&nbsp; 	                   Programmeringstjenester', '2100 Private aksjeselskaper mv.', 'Registrert i Foretaksregisteret', '-', 'H&aring;kon Berntsen', ' Oversikt over registrerte virksomheter ');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
