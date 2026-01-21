/*Procedures Utilizadas na Aula 1*/

CALL alo_mundo;

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`alo_mundo`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `alo_mundo`()
BEGIN
	DECLARE texto CHAR(20) DEFAULT 'Alô Mundo !!!';
	SELECT texto;
END$$

DELIMITER ;
;

/******************************************************************************************************/

CALL listaCLientes;

USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`listaClientes`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listaClientes`()
BEGIN
	SELECT * FROM clientes;
END$$

DELIMITER ;
;

/******************************************************************************************************/

CALL listaHospedagens;


USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`listaHospedagens`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `listaHospedagens`()
BEGIN
	SELECT * FROM hospedagens
    WHERE tipo = 'apartamento';
END$$

DELIMITER ;
;


/*Comando para excluir uma Procedure*/
DROP PROCEDURE nao_faz_nada;