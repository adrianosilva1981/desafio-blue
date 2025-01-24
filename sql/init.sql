-- MySQL dump 10.13  Distrib 5.5.62, for Win64 (AMD64)
--
-- Host: localhost    Database: desafio_blue
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.48-MariaDB-1~bionic

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `cpf` varchar(14) NOT NULL,
  `nome` varchar(45) DEFAULT NULL,
  `sobrenome` varchar(45) DEFAULT NULL,
  `fone_res` varchar(16) DEFAULT NULL,
  `fone_cel` varchar(16) DEFAULT NULL,
  `fone_com` varchar(16) DEFAULT NULL,
  `end_logradouro` varchar(128) DEFAULT NULL,
  `end_numero` varchar(16) DEFAULT NULL,
  `end_bairro` varchar(64) DEFAULT NULL,
  `end_uf_estado` varchar(2) DEFAULT NULL,
  `end_cidade` varchar(64) DEFAULT NULL,
  `end_cep` varchar(9) DEFAULT NULL,
  `id_pais` int(11) DEFAULT NULL,
  `obito` tinyint(4) DEFAULT '0',
  `data_nasc` date DEFAULT NULL,
  `data_atualizacao` datetime DEFAULT NULL,
  PRIMARY KEY (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'12345678910','Adriano','Silva','123456654','(35) 99135-3804',NULL,'Condomínio Recanto de Deus','197','Rio Verde','MG','Caldas','37133-652',1,0,NULL,NULL);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER after_insert_cliente

AFTER INSERT ON cliente

FOR EACH ROW

BEGIN

    -- insere em endereco:

    INSERT INTO endereco (id_cliente, endereco_logradouro, bairro, cep, uf_endereco, cidade, id_pais)

    VALUES (

        NEW.id_cliente,

        NEW.end_logradouro,

        NEW.end_bairro,

        NEW.end_cep,

        NEW.end_uf_estado,

        NEW.end_cidade,

        NEW.id_pais

    );



    -- insere em telefone:

    INSERT INTO telefone (id_cliente, telefone_res, telefone_cel, telefone_com)

    VALUES (

        NEW.id_cliente,

        NEW.fone_res,

        NEW.fone_cel,

        NEW.fone_com

    );



    -- insere em contatos_sp, se o cliente for de SP e o óbito for 0:

    INSERT INTO contatos_sp (id_cliente, id_endereco, id_telefone, endereco_completo)

    SELECT

        NEW.id_cliente,

        e.id_endereco,

        t.id_telefone,

        CONCAT(e.endereco_logradouro, ' ', e.cidade, ' ', e.uf_endereco, ' ', e.cep) AS endereco_completo

    FROM endereco e

    INNER JOIN telefone t ON e.id_cliente = t.id_cliente

    WHERE e.id_cliente = NEW.id_cliente

    AND t.id_cliente = NEW.id_cliente

    AND NEW.end_uf_estado = 'SP'

    AND NEW.obito = 0

    ORDER BY e.id_endereco DESC, t.id_telefone DESC

    LIMIT 1;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER after_update_cliente

AFTER UPDATE ON cliente

FOR EACH ROW

BEGIN

    -- atualiza endereco:

    UPDATE endereco SET

        endereco_logradouro = NEW.end_logradouro,

        bairro = NEW.end_bairro,

        cep = NEW.end_cep,

        uf_endereco = NEW.end_uf_estado,

        cidade = NEW.end_cidade,

        id_pais = NEW.id_pais

    WHERE id_cliente = NEW.id_cliente;



    -- atualiza telefone:

    UPDATE telefone SET

        telefone_res = NEW.fone_res,

        telefone_cel = NEW.fone_cel,

        telefone_com = NEW.fone_com

    WHERE id_cliente = NEW.id_cliente;



    IF NEW.end_uf_estado = 'SP' AND NEW.obito = 0 THEN

        UPDATE contatos_sp

        SET

            id_endereco = (SELECT id_endereco

                           FROM endereco

                           WHERE id_cliente = NEW.id_cliente

                           ORDER BY id_endereco DESC LIMIT 1),

            id_telefone = (SELECT id_telefone

                           FROM telefone

                           WHERE id_cliente = NEW.id_cliente

                           ORDER BY id_telefone DESC LIMIT 1),

            endereco_completo = CONCAT(

                (SELECT endereco_logradouro

                 FROM endereco

                 WHERE id_cliente = NEW.id_cliente

                 ORDER BY id_endereco DESC LIMIT 1),

                ' ',

                (SELECT cidade

                 FROM endereco

                 WHERE id_cliente = NEW.id_cliente

                 ORDER BY id_endereco DESC LIMIT 1),

                ' ',

                (SELECT uf_endereco

                 FROM endereco

                 WHERE id_cliente = NEW.id_cliente

                 ORDER BY id_endereco DESC LIMIT 1),

                ' ',

                (SELECT cep

                 FROM endereco

                 WHERE id_cliente = NEW.id_cliente

                 ORDER BY id_endereco DESC LIMIT 1)

            )

        WHERE id_cliente = NEW.id_cliente;



        IF ROW_COUNT() = 0 THEN

            INSERT INTO contatos_sp (id_cliente, id_endereco, id_telefone, endereco_completo)

            SELECT

                NEW.id_cliente,

                e.id_endereco,

                t.id_telefone,

                CONCAT(e.endereco_logradouro, ' ', e.cidade, ' ', e.uf_endereco, ' ', e.cep) AS endereco_completo

            FROM endereco e

            INNER JOIN telefone t ON e.id_cliente = t.id_cliente

                WHERE e.id_cliente = NEW.id_cliente

                AND t.id_cliente = NEW.id_cliente

                ORDER BY e.id_endereco DESC, t.id_telefone DESC

            LIMIT 1;

        END IF;

    ELSE

        DELETE FROM contatos_sp WHERE id_cliente = NEW.id_cliente;

    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `contatos_sp`
--

DROP TABLE IF EXISTS `contatos_sp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contatos_sp` (
  `id_contato` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `id_endereco` int(11) NOT NULL,
  `id_telefone` int(11) NOT NULL,
  `endereco_completo` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_contato`),
  KEY `contatos_sp_ibfk_1` (`id_cliente`),
  KEY `contatos_sp_ibfk_2` (`id_endereco`),
  KEY `contatos_sp_ibfk_3` (`id_telefone`),
  CONSTRAINT `contatos_sp_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE CASCADE,
  CONSTRAINT `contatos_sp_ibfk_2` FOREIGN KEY (`id_endereco`) REFERENCES `endereco` (`id_endereco`) ON DELETE CASCADE,
  CONSTRAINT `contatos_sp_ibfk_3` FOREIGN KEY (`id_telefone`) REFERENCES `telefone` (`id_telefone`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contatos_sp`
--

LOCK TABLES `contatos_sp` WRITE;
/*!40000 ALTER TABLE `contatos_sp` DISABLE KEYS */;
/*!40000 ALTER TABLE `contatos_sp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `endereco`
--

DROP TABLE IF EXISTS `endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `endereco` (
  `id_endereco` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `endereco_logradouro` varchar(150) DEFAULT NULL,
  `bairro` varchar(64) DEFAULT NULL,
  `cep` varchar(9) DEFAULT NULL,
  `uf_endereco` varchar(2) DEFAULT NULL,
  `cidade` varchar(45) DEFAULT NULL,
  `id_pais` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_endereco`),
  KEY `fk_id_cliente_endereco_idx` (`id_cliente`),
  CONSTRAINT `fk_id_cliente_endereco` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco`
--

LOCK TABLES `endereco` WRITE;
/*!40000 ALTER TABLE `endereco` DISABLE KEYS */;
INSERT INTO `endereco` VALUES (4,1,'Condomínio Recanto de Deus','Rio Verde','37133-652','MG','Caldas',1),(5,1,'Condomínio Recanto de Deus','Rio Verde','37133-652','MG','Caldas',1),(6,1,'Condomínio Recanto de Deus','Rio Verde','37133-652','MG','Caldas',1);
/*!40000 ALTER TABLE `endereco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telefone`
--

DROP TABLE IF EXISTS `telefone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telefone` (
  `id_telefone` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `telefone_res` varchar(16) DEFAULT NULL,
  `telefone_cel` varchar(16) DEFAULT NULL,
  `telefone_com` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id_telefone`),
  KEY `fk_id_cliente_telefone_idx` (`id_cliente`),
  CONSTRAINT `fk_id_cliente_telefone` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telefone`
--

LOCK TABLES `telefone` WRITE;
/*!40000 ALTER TABLE `telefone` DISABLE KEYS */;
INSERT INTO `telefone` VALUES (1,1,'123456654','(35) 99135-3804',NULL);
/*!40000 ALTER TABLE `telefone` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'desafio_blue'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-24 13:21:00
