/*Mão na massa: implementando a Stored Procedure de inclusão do aluguel*/
/*“De que modo posso criar e integrar uma nova stored procedure, inclusao_cliente_43, 
para encapsular o processo de cálculo do preço total e inserção na tabela de aluguéis,
mantendo a organização e eficiência do sistema?”*/

USE `insight_places`;
DROP procedure IF EXISTS `inclusao_cliente_43_mao_na_massa`;

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`inclusao_cliente_43_mao_na_massa`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclusao_cliente_43_mao_na_massa`(vAluguel VARCHAR(10), vCliente VARCHAr(10),
vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, 
vDias INT, vPrecoUnitario DECIMAL(10,2))
BEGIN
	DECLARE vPrecoTotal DECIMAL(10,2);
    
	SET vPrecoTotal  = vDias * vPrecoUnitario;
	INSERT INTO reservas VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
    vDataFinal, vPrecoTotal);
END$$

DELIMITER ;
;

/******************************************************************************************************/

/*Atualizando a Procedure com a utilização da inserção de reservas*/

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_mao_na_massa`;
DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_mao_na_massa`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150),
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
    
        CALL calcula_data_final_43(vDataInicio, vDataFinal, vDias);
		SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
		CALL inclusao_cliente_43_mao_na_massa(vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vDias, vPrecoUnitario);
		SET vMensagem = 'Aluguel Inserido na base com sucesso.';
		SELECT vMensagem;
        
	WHEN vNumCliente > 1 THEN /*Tratamento para verificação da existência de clientes com o mesmo nome.*/
		SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
        
    END CASE;
    
END$$
DELIMITER ;

CALL novoAluguel_mao_na_massa('10014', 'Livia Fogaça', '8635', '2023-05-18', 10, 40);
SELECT * FROM reservas WHERE reserva_id = '10014';