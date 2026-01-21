/*Atribuindo valor usando SELECT*/
/*PROCEDURE 1.3*/
SELECT * FROM clientes WHERE nome = 'Luana Moura';

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_4_1`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4_1`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vCliente VARCHAR(10);
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
    SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
    INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel Inserido na base com sucesso.';
	SELECT vMensagem;
END$$
DELIMITER ;


CALL novoAluguel_4_1('10006','Luana Moura','8635','2023-03-26','2023-03-30', 40);
Select * FROM reservas WHERE reserva_id = '10006';

/******************************************************************************************************/

/*Entendendo o IF-THEN-ELSE*/
/*PROCEDURE 1.3.1*/
/*Error 1172 - Mais de um registro na tabela, duas pessoas diferentes mas com o mesmo nome.*/
CALL novoAluguel_41('10007','Júlia Pires','8635','2023-03-30','2023-04-04', 40);
SELECT * FROM clientes WHERE nome = 'Júlia Pires';

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_4_2`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4_2`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    IF vNumCliente > 1 THEN
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
	ELSE
		SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel Inserido na base com sucesso.';
		SELECT vMensagem;
	END IF;
    
END$$
DELIMITER ;
CALL novoAluguel_4_2('10007','Júlia Pires','8635','2023-03-30','2023-04-04', 40);

/******************************************************************************************************/

/*Aprendendo o IF THEN ELSEIF*/
/*PROCEDURE 1.3.2*/
/*Inserção de uma reserva de um cliente não cadastrado no Banco de Dados.*/
CALL novoAluguel_43('10007','Victorino Vila','8635','2023-03-30','2023-04-04',40);
SELECT * FROM clientes WHERE nome = 'Victorino Vila';
SELECT * FROM reservas WHERE reserva_id = '10007';
DELETE FROM reservas WHERE reserva_id = '10007';
/*Uma vez que o banco aceitou uma reserva de um cliente não cadastrado no sistema, isso é obvimanente
um erro, tendo que ser tratado, utilizando a mesma variável que registra a contagem de nomes iguais, caso
não encontre qualquer registro com o nome da pessoa, retorna uma mensagem de erro, aonde o erro não ocorre mais. */

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_4_3`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4_3`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN /*Tratamento para verificação do erro 1452, referente a chave Estrangeira.*/
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    IF vNumCliente > 1 THEN /*Tratamento para verificação da existência de clientes com o mesmo nome.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
	ELSEIF vNumCliente = 0 THEN /*Tratamento para verificação da existência do cliente.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;	
	ELSE /*Passando pelos dois tratamentos, o registro é inserido no Banco.*/
		SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel Inserido na base com sucesso.';
		SELECT vMensagem;
	END IF;
    
END$$
DELIMITER ;

/******************************************************************************************************/

/*Tratando o CASE-END CASE*/
/*PROCEDURE 1.3.3*/

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_4_4`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4_4`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDias INT DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    
    DECLARE EXIT HANDLER FOR 1452
    BEGIN /*Tratamento para verificação do erro 1452, referente a chave Estrangeira.*/
		SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    
    CASE vNumCliente
    
	WHEN 0 THEN /*Tratamento para verificação da existência do cliente.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
			SELECT vMensagem;
            
    WHEN 1 THEN /*Passando pelos dois tratamentos, o registro é inserido no Banco.*/
	
		SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
		SET vPrecoTotal = vDias * vPrecoUnitario;
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		INSERT INTO reservas VALUES(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
		SET vMensagem = 'Aluguel Inserido na base com sucesso.';
		SELECT vMensagem;
        
	ELSE /*Tratamento para verificação da existência de clientes com o mesmo nome.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
        
    END CASE;
    
END$$
DELIMITER ;

CALL novoAluguel_4_4('10007','Victorino Vila','8635','2023-03-30','2023-04-04',40);
CALL novoAluguel_4_4('10007','Júlia Pires','8635','2023-03-30','2023-04-04', 40);
CALL novoAluguel_4_4('10007','Luana Moura','8635','2023-03-26','2023-03-30', 40);

/******************************************************************************************************/

/* Implementando o CASE CONDICIONAL*/
/*PROCEDURE 1.3.4*/

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_4_5`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4_5`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vNumCliente INT;
	DECLARE vCliente VARCHAR(10);
	DECLARE vDias INT DEFAULT 0;
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
	
		SET vDias = (SELECT DATEDIFF( vDataFinal, vDataInicio));
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

DELETE FROM reservas WHERE reserva_id = '10007';
CALL novoAluguel_4_5('10007','Victorino Vila','8635','2023-03-30','2023-04-04', 40);
CALL novoAluguel_4_5('10007','Júlia Pires','8635','2023-03-30','2023-04-04', 40);
CALL novoAluguel_4_5('10008','Luana Moura','8635','2023-03-26','2023-03-30', 40);