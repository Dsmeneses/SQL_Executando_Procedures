/*Usando o número de dias*/
/*PROCEDURE 1.4.0*/

SELECT '2023-01-01' + INTERVAL 5 DAY; 

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_4_6`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4_6`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    
    DECLARE EXIT HANDLER FOR 1452
    BEGIN /*Tratamento para verificação do erro 1452, referente a chave Estrangeira.*/
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    
    CASE
	WHEN vNumCliente = 0 THEN /*Tratamento para verificação da existência do cliente.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
			SELECT vMensagem;
            
    WHEN vNumCliente = 1 THEN /*Passando pelos dois tratamentos, o registro é inserido no Banco.*/
	
		-- SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
        SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel Inserido na base com sucesso.';
		SELECT vMensagem;
        
	WHEN vNumCliente > 1 THEN /*Tratamento para verificação da existência de clientes com o mesmo nome.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
        
    END CASE;
    
END$$
DELIMITER ;

DELETE FROM reservas WHERE reserva_id = '10008';
CALL novoAluguel_4_6('10008', 'Rafael Peixoto', '8635', '2023-04-05', 5, 40);
SELECT * FROM reservas WHERE reserva_id = '10008';

/******************************************************************************************************/

/*Aplicando o LOOPING condicional*/
/*PROCEDURE 1.4.0.1*/

SELECT DAYOFWEEK(STR_TO_DATE('2023-01-01', '%Y-%m-%d'));

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_46_Promocao_estranha`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_46_Promocao_estranha`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE vContador INT;
    DECLARE vDiaSemana INT;
    
    DECLARE EXIT HANDLER FOR 1452
    BEGIN /*Tratamento para verificação do erro 1452, referente a chave Estrangeira.*/
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    
    CASE
	WHEN vNumCliente = 0 THEN /*Tratamento para verificação da existência do cliente.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
			SELECT vMensagem;
            
    WHEN vNumCliente = 1 THEN /*Passando pelos dois tratamentos, o registro é inserido no Banco.*/
	
		-- SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
        -- SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);
        SET vContador = 1;
        SET vDataFinal = vDataInicio;
        WHILE vContador < vDias
        DO
			SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, '%Y-%m-%d')));
            IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
				SET vContador = vContador + 1;
			END IF;
			SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY);
        END WHILE;
        
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel Inserido na base com sucesso.';
		SELECT vMensagem;
        
	WHEN vNumCliente > 1 THEN /*Tratamento para verificação da existência de clientes com o mesmo nome.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
        
    END CASE;
    
END$$
DELIMITER ;

DELETE FROM reservas WHERE reserva_id = '10010';
CALL novoAluguel_46_Promocao_estranha('10010', 'Gabriela Pires', '8635', '2023-04-12', 5, 40);
SELECT * FROM reservas WHERE reserva_id = '10010';

/******************************************************************************************************/

/*Entendendo a passagem de parâmetro como referência*/
/*PROCEDURE 1.4.0.2*/


USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_46_Promocao_estranha_2`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_46_Promocao_estranha_2`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    
    DECLARE EXIT HANDLER FOR 1452
    BEGIN /*Tratamento para verificação do erro 1452, referente a chave Estrangeira.*/
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    
    CASE
	WHEN vNumCliente = 0 THEN /*Tratamento para verificação da existência do cliente.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
			SELECT vMensagem;
            
    WHEN vNumCliente = 1 THEN /*Passando pelos dois tratamentos, o registro é inserido no Banco.*/
	
		-- SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
        -- SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);
        CALL calcula_data_final_43(vDataInicio, vDataFinal, vDias);
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel Inserido na base com sucesso.';
		SELECT vMensagem;
        
	WHEN vNumCliente > 1 THEN /*Tratamento para verificação da existência de clientes com o mesmo nome.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
        
    END CASE;
    
END$$
DELIMITER ;

CALL novoAluguel_46_Promocao_estranha_2('10011', 'Livia Fogaça', '8635', '2023-04-20', 10, 40);
SELECT * FROM reservas WHERE reserva_id = '10011';

/******************************************************************************************************/

/*Calculando automaticamente o ID do aluguel*/
/*PROCEDURE 1.4.0.3*/

SELECT reserva_id, CAST(reserva_id AS UNSIGNED) FROM reservas;
SELECT MAX(CAST(reserva_id AS UNSIGNED)) + 1 FROM reservas;
SELECT CAST(MAX(CAST(reserva_id AS UNSIGNED)) + 1  AS CHAR) FROM reservas;

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_47`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_47`(vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vAluguel VARCHAR(10);
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDataFinal DATE;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    
    DECLARE EXIT HANDLER FOR 1452
    BEGIN /*Tratamento para verificação do erro 1452, referente a chave Estrangeira.*/
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    
    CASE
	WHEN vNumCliente = 0 THEN /*Tratamento para verificação da existência do cliente.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
			SELECT vMensagem;
            
    WHEN vNumCliente = 1 THEN /*Passando pelos dois tratamentos, o registro é inserido no Banco.*/
	
		SELECT CAST(MAX(CAST(reserva_id AS UNSIGNED)) + 1  AS CHAR) INTO vAluguel FROM reservas;
        CALL calcula_data_final_43(vDataInicio, vDataFinal, vDias);
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = CONCAT('Aluguel Inserido na base com sucesso, ID ', vAluguel);
		SELECT vMensagem;
        
	WHEN vNumCliente > 1 THEN /*Tratamento para verificação da existência de clientes com o mesmo nome.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
        
    END CASE;
    
END$$
DELIMITER ;

DELETE FROM reservas WHERE reserva_id = '10012';
CALL novoAluguel_47('Livia Fogaça', '8635', '2023-05-15', 5, 45);
SELECT * FROM reservas WHERE reserva_id = '10012';
