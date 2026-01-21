/*Incluindo clientes em uma tabela temporária*/
/*Inserção de vários clientes numa mesma reserva. Ex: Uma família de 4 pessoas.
Causando uma repetição de valores, como os Dias das reservas, o Valor Total.*/
/*Aplicando a inclusão da lista na tabela*/
/*PROCEDURE 1.4.1.0*/

-- temp_nomes (nome)

DROP TEMPORARY TABLE IF EXISTS temp_nomes;
CREATE TEMPORARY TABLE temp_nomes(nome VARCHAR(255));
CALL inclui_usuarios_lista_4_8('Luana Moura,Enrico Correia,Paulo Vieira,Marina Nunes');
SELECT * FROM temp_nomes;

/******************************************************************************************************/

/*Entendendo o funcionamento do CURSOR*/
/* O CURSOR é uma estrutura implementada no MySQL para permitir uma interatividade linha a linha
 através de uma determinada ordem.*/
 
 /*Prática*/
/*
COD	NOME	VALOR
1	JOÃO	10
2	JOSÉ	15
3	MARIA	10
4	LÚCIA	5
*/
 
 /*
 DECLARE vNOME VARCHAR(10);
 DECLARE CURSOR1 CURSOR FOR SELECT NOME FROM TABELA;
 OPEN CURSOR1;
FETCH CURSOR1 INTO vNOME; --vNOME JOÃO
FETCH CURSOR1 INTO vNOME; --vNOME JOSÉ
FETCH CURSOR1 INTO vNOME; --vNOME MARIA
CLOSE CURSOR1;
 */
 
 /*Demos três FETCH, mas poderíamos ter dado quatro, porque sabíamos que a variável CURSOR tinha 
 quatro posições, que foi o resultado da nossa consulta.
Porém, como fazemos se não sabemos quantas posições tem um CURSOR e queremos percorrê-lo até o final?*/
 /*Basta definir um CURSOR e um HANDLER, que força uma exceção que vai acontecer quando não existir mais posição no CURSOR.

Quando não encontrarmos mais ninguém no final do CURSOR, uma variável, que declaramos como 0 inicialmente,
passa a ser 1. Nesse caso, chamamos essa variável de fimCursor.*/

/*
DECLARE fimCursor INTEGER DEFAULT 0;
DECLARE vNOME VARCHAR(10);
DECLARE CURSOR1 CURSOR FOR SELECT NOME FROM TABELA;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;

OPEN CURSOR1; --vNOME vazio, fimCursor 0
WHILE fimCursor = 0 DO
    FETCH CURSOR1 INTO vNOME;
END WHILE;
CLOSE CURSOR1; --vNOME vazio, fimCursor 1
*/
/*E quando demos o último FETCH, automaticamente fimCursor passa a ser igual a 1. 
Então, saímos do loop, e podemos dar o CLOSE do CURSOR.*/

/******************************************************************************************************/

/*Fazendo o looping com o cursor*/
/*PROCEDURE 1.4.1.1*/

DROP TEMPORARY TABLE IF EXISTS temp_nomes;
CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
CALL inclui_usuarios_lista_48('João, Pedro, Maria, Lucia, Joana, Beatriz');
SELECT * FROM temp_nomes;
CALL looping_cursor_49();

/******************************************************************************************************/

/*Aplicando o cursor na inclusão de múltiplos aluguéis*/
/*PROCEDURE 1.4.2*/

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novos_alugueis_48`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novos_alugueis_48`(lista VARCHAR(255), vHospedagem VARCHAR(10), 
vDataInicio DATE, vDias INT, vPrecoUnitario DECIMAl(10,2))
BEGIN
	DECLARE vClienteNome VARCHAR(150);
	DECLARE fim_Cursor INT DEFAULT 0;
    DECLARE vNome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_Cursor = 1;
    
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
	CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
    CALL inclui_usuarios_lista_48(lista);
    
    OPEN cursor1;
    FETCH cursor1 INTO vNome;
    
    WHILE fim_Cursor = 0 DO
        SET vClienteNome = vNome;
        CALL novoAluguel_47(vClienteNome,vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vNome;
    END WHILE;
    CLOSE cursor1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
    
END$$

DELIMITER ;
;

CALL novos_alugueis_4_8('Gabriel Carvalho,Erick Oliveira,Catarina Correia,Lorena Jesus', '8635', '2023-06-03', 7, 45);
SELECT * FROM reservas WHERE reserva_id IN ('10015','10016','10017','10018');