/*Declarando uma variável*/
CALL alo_mundo;
CALL tiposDados;
CALL dataHora;

/*Manipulando dados*/

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_0`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_0`()
BEGIN
	DECLARE vAluguel VARCHAR(10) DEFAULT 10001;
    DECLARE vCliente VARCHAR(10) DEFAULT 1002;
    DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
    DECLARE vDataInicio DATE DEFAULT '2023-03-01';
    DECLARE vDataFinal DATE DEFAULT '2023-03-05';
    DECLARE vPrecoTotal DECIMAl(10,2) DEFAULT 550.23;
    SELECT vAluguel, vCLiente, VHospedagem, vDataInicio, vDataFinal, vPrecoTotal;
END$$
DELIMITER ;
/***************************************************************************************************/

/*PROCEDURE 1.0*/
USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_1_0`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_1_0`()
BEGIN
	DECLARE vAluguel VARCHAR(10) DEFAULT 10001;
    DECLARE vCliente VARCHAR(10) DEFAULT 1002;
    DECLARE vHospedagem VARCHAR(10) DEFAULT 8635;
    DECLARE vDataInicio DATE DEFAULT '2023-03-01';
    DECLARE vDataFinal DATE DEFAULT '2023-03-05';
    DECLARE vPrecoTotal DECIMAl(10,2) DEFAULT 550.23;
    INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;

SELECT * FROM reservas WHERE reserva_id = '10001';
CALL novoAluguel_1;

/***************************************************************************************************/

/*Trabalhando com parâmetros*/
/*PROCEDURE 1.1*/
USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_2_0`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_2_0`(vAluguel VARCHAR(10), vCliente VARCHAR(10),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoTotal DECIMAl(10,2))
BEGIN
    INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;

CALL novoAluguel_2_0('10002', '1003', '8635', '2023-03-06', '2023-03-10', 600);
SELECT * FROM reservas WHERE reserva_id = '10002';
CALL novoAluguel_2_0('10003', '1004', '8635', '2023-03-10', '2023-03-12', 250);
SELECT * FROM reservas WHERE reserva_id = '10003';

/***************************************************************************************************/