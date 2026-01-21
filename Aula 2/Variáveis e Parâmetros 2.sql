SELECT DATEDIFF('2023-04-03', '2023-04-01') as Diferenca_Dias;
/*Atribuição de valores*/
/*PROCEDURE 1.2*/

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_3_0`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_3_0`(vAluguel VARCHAR(10), vCliente VARCHAR(10),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;

CALL novoAluguel_3_0('10005','1004','8635','2023-03-13','2023-03-16', 40);
SELECT * FROM reservas WHERE reserva_id = '10005';

/******************************************************************************************************/

/* Tratando exceções*/
/*PROCEDURE 1.2.1*/

SELECT * FROM clientes WHERE cliente_id = '10001';
CALL novoAluguel_3_0('10004','10001','8635','2023-03-17','2023-03-25', 40);

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_4_0`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4_0`(vAluguel VARCHAR(10), vCliente VARCHAR(10),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel Inserido na base com sucesso.';
	SELECT vMensagem;
END$$
DELIMITER ;

CALL novoAluguel_4_0('10004','10001','8635','2023-03-17','2023-03-25', 40);
CALL novoAluguel_4_0('10004','1004','8635','2023-03-17','2023-03-25', 40);