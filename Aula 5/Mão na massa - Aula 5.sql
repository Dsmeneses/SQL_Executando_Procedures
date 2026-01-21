/*Mão na massa: construindo cursor com múltiplos campos*/

/*Na atividade anterior, desafiamos você a mencionar o que deveria ser modificado na 
procedure looping_cursor_54 para aceitar múltiplos campos. 
Agora,supondo que a tabela temp_nomes tenha o campo email,além do campo nome, 
como ficaria a nova procedure para listar ambos os campos na saída?

Sua tarefa é realizar a modificação necessária na procedure looping_cursor_54 para que ela possa selecionar 
e listar tanto o campo nome quanto o campo email da tabela temp_nomes. 
Dê continuidade ao seu aprendizado e pratique essa modificação.*/

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`mao_na_massa_aula_5`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `mao_na_massa_aula_5`()
BEGIN
	DECLARE fim_Cursor INT DEFAULT 0;
    DECLARE vNome VARCHAR(255);
    DECLARE vEmail VARCHAR(50);
    
	/* Atualiza a declaração do cursor para incluir o campo email*/
    DECLARE cursor1 CURSOR FOR SELECT nome, email FROM temp_nomes;
    /*Saída do Looping*/
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fim_Cursor = 1;
    /*Abertura do cursor*/
    OPEN cursor1;
    FETCH cursor1 INTO vNome, vEmail;
    
    WHILE fim_Cursor = 0 DO
        SELECT vNome, vEmail;
        FETCH cursor1 INTO vNome, vEmail;
    END WHILE;
    
    CLOSE cursor1;
    
END$$

DELIMITER ;
;