-- MySQL dump 10.11
--
-- Host: localhost    Database: barbera_development
-- ------------------------------------------------------
-- Server version	5.0.51a-24+lenny3
-- Schema completo con tutte le correzioni integrate

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

USE barbera_development;

--
-- Table structure for table `auto_prova_rapporto_items`
--

DROP TABLE IF EXISTS `auto_prova_rapporto_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `auto_prova_rapporto_items` (
  `id` int(11) NOT NULL auto_increment,
  `prova_id` int(11) default NULL,
  `rapporto_id` int(11) default NULL,
  `prezzo` float default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `campione_prova_items`
--

DROP TABLE IF EXISTS `campione_prova_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `campione_prova_items` (
  `id` int(11) NOT NULL auto_increment,
  `campione_id` int(11) default NULL,
  `prova_id` int(11) default NULL,
  `prezzo` float default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `campione_tipologia_items`
--

DROP TABLE IF EXISTS `campione_tipologia_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `campione_tipologia_items` (
  `id` int(11) NOT NULL auto_increment,
  `campione_id` int(11) default NULL,
  `tipologia_id` int(11) default NULL,
  `prezzo` float default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `numero` int(11) default NULL,
  `data` date default NULL,
  `note` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `campioni`
--

DROP TABLE IF EXISTS `campioni`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `campioni` (
  `id` int(11) NOT NULL auto_increment,
  `cliente_id` int(11) default NULL,
  `campione_di` varchar(255) default NULL,
  `etichetta` text,
  `nome_richiedente` varchar(255) default NULL,
  `numero` int(11) default NULL,
  `data` date default NULL,
  `campionamento` varchar(255) default NULL,
  `non_conforme_motivo` varchar(255) default NULL,
  `suggello` varchar(255) default NULL,
  `comune` varchar(255) default NULL,
  `provincia` varchar(255) default NULL,
  `località` varchar(255) default NULL,
  `tipo_di_coltura` varchar(255) default NULL,
  `fase_coltura` varchar(255) default NULL,
  `ettari` varchar(255) default NULL,
  `superficie_di_prelievo` varchar(255) default NULL,
  `profondita_di_prelievo` varchar(255) default NULL,
  `numero_foglio_di_mappa` varchar(255) default NULL,
  `particelle` varchar(255) default NULL,
  `note` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `anno` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `clienti`
--

DROP TABLE IF EXISTS `clienti`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `clienti` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(255) default NULL,
  `denominazione` varchar(255) default NULL,
  `codice` varchar(255) default NULL,
  `indirizzo` varchar(255) default NULL,
  `cap` varchar(255) default NULL,
  `comune` varchar(255) default NULL,
  `provincia` varchar(255) default NULL,
  `partita_iva` varchar(255) default NULL,
  `codice_fiscale` varchar(255) default NULL,
  `tel` varchar(255) default NULL,
  `fax` varchar(255) default NULL,
  `email_per_notifiche` varchar(255) default NULL,
  `cellulare_per_sms` varchar(255) default NULL,
  `titolare_cellulare` varchar(255) default NULL,
  `note` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `cellulare_per_sms_2` varchar(255) default NULL,
  `titolare_cellulare_2` varchar(255) default NULL,
  `fatt_indirizzo` varchar(255) default NULL,
  `fatt_comune` varchar(255) default NULL,
  `fatt_cap` varchar(255) default NULL,
  `fatt_provincia` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fattura_rapporto_items`
--

DROP TABLE IF EXISTS `fattura_rapporto_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `fattura_rapporto_items` (
  `id` int(11) NOT NULL auto_increment,
  `fattura_id` int(11) default NULL,
  `rapporto_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fatture`
--

DROP TABLE IF EXISTS `fatture`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `fatture` (
  `id` int(11) NOT NULL auto_increment,
  `cliente_id` int(11) default NULL,
  `numero` int(11) default NULL,
  `anno` int(11) default NULL,
  `data_emissione` date default NULL,
  `percentuale_sconto` float default '0',
  `data_inizio` date default NULL,
  `data_fine` date default NULL,
  `data_pagamento` date default NULL,
  `totale_in_pdf` float default NULL,
  `pdf_esiste` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `note` text,
  `usa_indirizzo_di_fatturazione` tinyint(1) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `matrici`
--

DROP TABLE IF EXISTS `matrici`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `matrici` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(255) default NULL,
  `nome_esteso` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `parametri`
--

DROP TABLE IF EXISTS `parametri`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `parametri` (
  `id` int(11) NOT NULL auto_increment,
  `codice` varchar(255) default NULL,
  `nome` varchar(255) default NULL,
  `note` varchar(255) default NULL,
  `valore` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prova_rapporto_items`
--

DROP TABLE IF EXISTS `prova_rapporto_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prova_rapporto_items` (
  `id` int(11) NOT NULL auto_increment,
  `prova_id` int(11) default NULL,
  `rapporto_id` int(11) default NULL,
  `prezzo` float default '0',
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prova_tipologia_items`
--

DROP TABLE IF EXISTS `prova_tipologia_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prova_tipologia_items` (
  `id` int(11) NOT NULL auto_increment,
  `prova_id` int(11) default NULL,
  `tipologia_id` int(11) default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prova_variabile_items`
--

DROP TABLE IF EXISTS `prova_variabile_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prova_variabile_items` (
  `id` int(11) NOT NULL auto_increment,
  `prova_id` int(11) default NULL,
  `variabile_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `prove`
--

DROP TABLE IF EXISTS `prove`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `prove` (
  `id` int(11) NOT NULL auto_increment,
  `matrice_id` int(11) default NULL,
  `nome` varchar(255) default NULL,
  `nome_esteso` varchar(255) default NULL,
  `metodo_di_prova` varchar(255) default NULL,
  `prezzo` float default '0',
  `subappalto` tinyint(1) default NULL,
  `note` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rapporti`
--

DROP TABLE IF EXISTS `rapporti`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rapporti` (
  `id` int(11) NOT NULL auto_increment,
  `tipologia_id` int(11) default NULL,
  `campione_id` int(11) default NULL,
  `numero` int(11) default NULL,
  `numero_supplemento` int(11) default NULL,
  `status` varchar(255) default NULL,
  `data_richiesta` date default NULL,
  `data_scadenza` datetime default NULL,
  `data_invio_email` datetime default NULL,
  `data_invio_sms` datetime default NULL,
  `data_esecuzione_prove_inizio` date default NULL,
  `data_esecuzione_prove_fine` date default NULL,
  `data_stampa` date default NULL,
  `prezzo_tipologia_forfeit` float default NULL,
  `note` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `anno` int(11) default NULL,
  `pie_pagina` text NOT NULL,
  `fattura_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_rapporti_on_campione_id` (`campione_id`),
  KEY `index_rapporti_on_fattura_id` (`fattura_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tipologie`
--

DROP TABLE IF EXISTS `tipologie`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tipologie` (
  `id` int(11) NOT NULL auto_increment,
  `matrice_id` int(11) default NULL,
  `nome` varchar(255) default NULL,
  `nome_esteso` varchar(255) default NULL,
  `forfeit` tinyint(1) default NULL,
  `prezzo` float default '0',
  `note` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `sinal` tinyint(1) default NULL,
  `pie_pagina` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `udm_items`
--

DROP TABLE IF EXISTS `udm_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `udm_items` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_sessions`
--

DROP TABLE IF EXISTS `user_sessions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) default NULL,
  `password` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `cliente_id` int(11) default NULL,
  `nome` varchar(255) default NULL,
  `role` int(11) default NULL,
  `email` varchar(255) NOT NULL default '',
  `crypted_password` varchar(255) NOT NULL default '',
  `password_salt` varchar(255) NOT NULL default '',
  `persistence_token` varchar(255) NOT NULL default '',
  `single_access_token` varchar(255) NOT NULL default '',
  `perishable_token` varchar(255) NOT NULL default '',
  `login_count` int(11) NOT NULL default '0',
  `failed_login_count` int(11) NOT NULL default '0',
  `last_request_at` datetime default NULL,
  `current_login_at` datetime default NULL,
  `last_login_at` datetime default NULL,
  `current_login_ip` varchar(255) default NULL,
  `last_login_ip` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `variabile_rapporto_items`
--

DROP TABLE IF EXISTS `variabile_rapporto_items`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `variabile_rapporto_items` (
  `id` int(11) NOT NULL auto_increment,
  `variabile_id` int(11) default NULL,
  `rapporto_id` int(11) default NULL,
  `vecchio_campo_data_buttami` date default NULL,
  `valore_numero` decimal(25,11) default NULL,
  `valore_testo` varchar(255) default NULL,
  `incertezza_di_misura` varchar(255) default NULL,
  `errore` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `valore_numero_forzato` decimal(25,11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_variabile_rapporto_items_on_rapporto_id` (`rapporto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `variabili`
--

DROP TABLE IF EXISTS `variabili`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `variabili` (
  `id` int(11) NOT NULL auto_increment,
  `codice` varchar(255) default NULL,
  `nome` varchar(255) default NULL,
  `udm_item_id` int(11) default NULL,
  `metodo_di_misura` varchar(255) default NULL,
  `limiti_legge` varchar(255) default NULL,
  `tipo` varchar(255) default NULL,
  `note` varchar(255) default NULL,
  `position` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `valori_possibili` varchar(255) default NULL,
  `decimali` int(11) default NULL,
  `matrice_id` int(11) default NULL,
  `simbolo` varchar(255) default NULL,
  `funzione` varchar(255) default NULL,
  `nome_esteso` varchar(255) default NULL,
  `min` float default NULL,
  `max` float default NULL,
  `forza_zero` boolean default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_variabili_on_matrice_id_and_simbolo` (`matrice_id`, `simbolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed 